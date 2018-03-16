defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  test "greets the world" do
    assert Account.hello() == :account
  end
end
