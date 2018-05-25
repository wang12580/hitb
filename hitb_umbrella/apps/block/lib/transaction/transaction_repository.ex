defmodule Block.TransactionRepository do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Transaction

  def insert_transaction(transaction) do
    %Transaction{}
    |> Transaction.changset(transaction)
    |> Repo.insert
    :ok
  end

  def get_transactions_by_id(id) do
    Repo.get_by(Transaction, transaction_id: String.to_integer(id))
  end

  def get_transactions_by_blockIndex(id) do
    Repo.get_by(Transaction, blockId: to_string(id))
  end

  def get_transactions_by_publicKey(publicKey) do
    Repo.get_by(Transaction, senderPublicKey: publicKey)
  end

  def get_all_transactions() do
    Repo.all(from p in BlockList, order_by: [asc: p.datetime])
  end
end
