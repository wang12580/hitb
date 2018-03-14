defmodule BlockTest do
  use ExUnit.Case
  doctest Block

  test "greets the world" do
    assert Block.hello() == :world
  end
end
