defmodule BlockTest do
  use ExUnit.Case
  doctest Block.Token

  test "greets the world" do
    assert Block.Token.hello() == :world
  end
end
