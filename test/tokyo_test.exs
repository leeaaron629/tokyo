defmodule TokyoTest do
  use ExUnit.Case
  doctest Tokyo

  test "greets the world" do
    assert Tokyo.hello() == :world
  end
end
