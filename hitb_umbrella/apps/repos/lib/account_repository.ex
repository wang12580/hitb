defmodule Repos.AccountRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  def insert_account() do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write({:account,
        1,
        "test",
        nil,
        1,
        0,
        0,
        0,
        "4",
        "123",
        "124",
        10000,
        1,
        20,
        1,
        "",
        "",
        "",
        "",
        1,
        1,
        1,
        1,
        "12",
        true,
        true,
        12,
        12,
        1,
        12,
        1})
        # :ets.insert(:account, {:latest, block})
    end)
    :ok
  end
end
