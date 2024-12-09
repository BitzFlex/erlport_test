defmodule OPCClient do
  use GenServer
  use Export.Python

  # Client API
  def start_link(%{url: _url, name_uri: _name_uri, venv_path: _venv_path, name: name} = opts) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def get_name_index(pid) do
    GenServer.call(pid, :get_name_index)
  end

  def get_sub_objects_of(pid, name_list) do
    GenServer.call(pid, {:get_sub_objects_of, name_list} )
  end

  def get_variables_of(pid, name_list) do
    GenServer.call(pid, {:get_variables_of, name_list} )
  end


  def stop(pid) do
    GenServer.stop(pid)
  end

  # ---------------- private ---------------------
  defp make_name_list(_name_index,[]) do
    "/"
  end

  defp make_name_list(_name_index,"") do
    "/"
  end

  defp make_name_list(_name_index,"/") do
    "/"
  end

  defp make_name_list(name_index,name_list) when is_list(name_list) do
    name_list
      |> Enum.map(fn name -> "#{name_index}:#{name}" end)
      |> Enum.join("/")
  end

  defp make_name_list(name_index,name_str) when is_binary(name_str) do
    make_name_list(name_index, String.split(name_str,"/") )
  end

  #-- charlist to string conversion
  defp to_str(charlist) when is_list(charlist) do
    List.to_string(charlist)
  end

  defp to_str({charlist, v}) when is_list(charlist) do
    {List.to_string(charlist), v}
  end

  defp to_string_list(list) when is_list(list) do
    list
      |> Enum.map(fn item -> to_str(item) end )
  end

  defp to_string_list(value)  do
    value
  end

  # Server Callbacks
  @impl true
  def init(%{url: url, name_uri: name_uri, venv_path: venv_path} = opts) do
    cwd = File.cwd!() |>  Path.expand()

    Python.start(
                cd: cwd,
                python_path: cwd ,
                python: Path.join([venv_path,"bin/python3"])
    ) |> case do
        {:ok, python} ->
              Python.call(python, "opc_client", "connect", [url, name_uri] )
              {true,name_index} = Python.call(python, "opc_client", "get_name_index", [])
              {:ok, %{python: python, opts: opts , name_index: name_index}}
        _ -> {:stop, "python connection failure"}
    end
  end

  @impl true
  def handle_call(:get_name_index, _from, state) do
    {:reply, Map.get(state,:name_index) , state}
  end

  def handle_call({:get_sub_objects_of, name_list}, _from, %{python: python,name_index: name_index} = state) do
    name_list = make_name_list(name_index,name_list)
                # |> dbg()
    result = Python.call(python, "opc_client", "get_sub_objects_of_path", [name_list] )
              |> to_string_list()
    {:reply, result , state}
  end

  def handle_call({:get_variables_of, name_list}, _from, %{python: python,name_index: name_index} = state) do
    name_list = make_name_list(name_index,name_list)
    result = Python.call(python, "opc_client", "get_variables_of_path", [name_list] )
                |> to_string_list()
    {:reply, result , state}
  end


  @impl true
  def handle_info(msg, state) do
    IO.puts("Unhandled message: #{inspect(msg)}")
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, %{python: python}) do
    dbg("Teminate")
    Python.call(python, "opc_client", "disconnect", [] )
    :ok
  end

  @impl true
  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end




end
