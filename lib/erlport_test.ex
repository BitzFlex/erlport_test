defmodule ErlportTest do
  use Export.Python




  def charlist_proc(r) when is_list(r) do

  end

  def ifc_test do
    {:ok, python} = Python.start(python_path: Path.expand("/Users/bhseong/Documents/Develop/python_dev/bin") ,
                                python: "python3")

    Python.call(python, "sys", "path.append", [File.cwd!()] )

    Python.call(python, "sys", "version.__str__", [])
      |> List.to_string()
      |> dbg()

    Python.call(python, "datetime", "datetime.now", [])
      # |> List.to_string()
      |> dbg()

    Python.call(python, "py_functions", "get_current_datetime_str", [])
      |> List.to_string()
      |> dbg()

    Python.call(python, "py_functions", "get_sys_path", [])
      # |> List.to_string()
      |> dbg()

    Python.call(python, "py_functions", "greet", [ "Elixir 엘릭서" ])
      |> List.to_string()
      |> dbg()

    Python.call(python, "py_functions", "get_dict", [])
      |> dbg()

    Python.call(python, "py_functions", "add", [1,2])
      |> dbg()

    Python.call(python, "py_functions", "large_list", [])
      |> Enum.map(&List.to_string/1)
      |> dbg()
      # |> Enum.each(fn i -> IO.puts(i) end)

    Python.stop(python)
  end


  @venv_path "/Users/bhseong/Documents/Develop/python_dev/"

  def ready_python do

    cwd = File.cwd!() |>  Path.expand()
    {:ok, python} = Python.start(
                                cd: cwd,
                                python_path: cwd ,
                                python: Path.join([@venv_path,"bin/python3"])
                                #  python_path: File.cwd!() |>  Path.expand(),
                                )

    # dbg  File.cwd!()
    Python.call(python, "sys", "path.append", [File.cwd!()] )
    # Python.call(python, "sys", "path.append", ["/Users/bhseong/Documents/Develop/python_dev/lib/python3.13/site-packages"] )
    python
  end


  def opc_test do
    python = ready_python()

    # Python.call(python, "sys", "version.__str__", [])
    #   |> dbg()

    # Python.call(python, "sys", "path.__str__", [])
    #   |> dbg()

    url =  "opc.tcp://localhost:4840/freeopcua/server/"
    name_uri = "http://example.org"

    Python.call(python, "opc_client", "connect", [url , name_uri])
      |> dbg()
  end

  def gs_test(count \\ 1) do

    opts = %{
      url: "opc.tcp://localhost:4840/freeopcua/server/",
      name_uri: "http://example.org",
      venv_path: @venv_path,
      name: :opc_client
    }
    OPCClient.start_link(opts)


    OPCClient.get_name_index(:opc_client)
      |> dbg()


    start = DateTime.utc_now() |> DateTime.to_unix()

    0..count
      |> Enum.each(fn _ ->

      # OPCClient.get_sub_objects_of(:opc_client,"/")
        # |> dbg()

      OPCClient.get_sub_objects_of(:opc_client,["obj1"])
        # |> dbg()

      # OPCClient.get_variables_of(:opc_client,"obj1")
        # |> dbg()

      # OPCClient.get_variables_of(:opc_client,"obj1/obj1_1")
        # |> dbg()

      OPCClient.get_variables_of(:opc_client,["obj1", "obj1_1"])
        # |> dbg()

    end)


    OPCClient.stop(:opc_client)

    fin = DateTime.utc_now() |> DateTime.to_unix()

    dbg(fin - start)

  end



end
