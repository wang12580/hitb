defmodule Block.TransactionRepository do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Transaction
  alias Block.BlockList

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
    Repo.all(from p in BlockList, order_by: [asc: p.index])
  end
end
