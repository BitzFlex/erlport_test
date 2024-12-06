defmodule ErlportTestTest do
  use ExUnit.Case
  doctest ErlportTest

  test "greets the world" do
    assert ErlportTest.hello() == :world
  end
end
