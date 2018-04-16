defmodule HitbWeb.TransactionController do
  use HitbWeb, :controller
  alias Block
  alias Repos
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def getTransactions(conn, _) do
    transactions = Repos.TransactionRepository.get_all_transactions |> Enum.map(fn x -> %{x | :id => to_string(x.id)} end)
    json(conn, %{data: transactions})
  end

  def getTransaction(conn, %{"id" => id}) do
    transaction = Repos.TransactionRepository.get_transactions_by_id(id)
    json conn, %{data: transaction}
  end

  def getUnconfirmedTransaction(conn, _) do
    json(conn,  %{})
  end

  def getUnconfirmedTransactions(conn, _) do
    json(conn,  %{})
  end

  def addTransactions(conn, %{"publicKey" => publicKey, "amount" => amount, "recipientId" => recipientId, "message" => message}) do
    %{"secondPassword" => secondPassword} = Map.merge(%{"secondPassword" => "dzc944262316"}, conn.params)
    case Transaction.newTransaction(%{publicKey: publicKey, amount: String.to_integer(amount), recipientId: recipientId, message: message, secondPassword: secondPassword, fee: 1}) do
      [:ok, transaction, info] -> json(conn,  %{success: true, transaction: transaction, info: info})
      [:error, _, info] -> json(conn,  %{success: false, transaction: [], info: info})
    end
  end

  def getTransactionsByBlockHeight(conn, %{"height" => height}) do
    transaction = Repos.TransactionRepository.get_transactions_by_blockIndex(height)
    IO.inspect transaction
    json conn, %{data: transaction}
  end

  def getTransactionsByBlockHash(conn, %{"hash" => hash}) do
    block = Repos.BlockRepository.get_block_by_hash(hash)
    transaction = Repos.TransactionRepository.get_transactions_by_blockHash(block.index)
    json conn, %{data: transaction}
  end


  def getStorage(conn, _) do
    json(conn,  %{})
  end

  def putStorage(conn, _) do
    json(conn,  %{})
  end
end
