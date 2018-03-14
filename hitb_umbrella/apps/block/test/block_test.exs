defmodule BlockTest do
  use ExUnit.Case
  doctest Block

  test "greets the world" do
    assert Block.hello() == :block
  end
end
