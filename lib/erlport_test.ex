defmodule ErlportTest do
  use Export.Python


  def ifc_test do
    {:ok, python} = Python.start(python_path: Path.expand("/Users/bhseong/Documents/Develop/python_dev/bin") , python: "python3")


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

    # Python.call(python, "py_functions", "add", [1,2])
    #   |> dbg()

    # Python.call(python, "py_functions", "large_list", [])
    #   |> Enum.map(&List.to_string/1)
    #   |> dbg()
    #   |> Enum.each(fn i -> IO.puts(i) end)


    Python.stop(python)
  end

end
