defmodule TokenTest do
  use ExUnit.Case
  doctest Token

  test "greets the world" do
    assert Token.hello() == :world
  end
end
