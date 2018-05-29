defmodule Block.TransactionRepository do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Transaction

  def insert_transaction(transaction) do
    %Transaction{}
    |> Transaction.changeset(transaction)
    |> Repo.insert
    :ok
  end

  def get_transactions_by_id(id) do
    Repo.get_by(Transaction, transaction_id: id)
  end

  def get_transactions_by_blockIndex(id) do
    Repo.get_by(Transaction, blockId: id)
  end

  def get_transactions_by_publicKey(publicKey) do
    Repo.get_by(Transaction, senderPublicKey: publicKey)
  end

  def get_all_transactions() do
    Repo.all(from p in Transaction, order_by: [asc: p.datetime])
  end

  def get_all_transactions_id() do
    Repo.all(from p in Transaction, select: p.transaction_id)
  end
end
