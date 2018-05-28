defmodule BlockTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.AccountRepository

  test "greets the world" do
    # IO.inspect AccountRepository.get_all_accounts()
    assert Block.Token.hello() == :world
  end
end
