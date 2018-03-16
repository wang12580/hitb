defmodule TransactionTest do
  use ExUnit.Case
  doctest Transaction

  test "greets the world" do
    assert Transaction.hello() == :transaction
  end
end
