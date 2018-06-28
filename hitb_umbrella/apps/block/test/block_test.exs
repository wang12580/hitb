defmodule BlockTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  # alias Block.AccountRepository

  test "greets the world" do
    assert Block.Token.hello() == :world
  end
end
