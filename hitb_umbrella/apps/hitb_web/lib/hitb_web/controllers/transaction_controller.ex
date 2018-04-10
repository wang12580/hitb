defmodule HitbWeb.TransactionController do
  use HitbWeb, :controller
  alias Block
  alias Repos
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def getTransactions(conn, _) do
    transactions = Repos.TransactionRepository.get_all_transactions
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
    %{"secondPassword" => secondPublicKey} = Map.merge(conn.params, %{"secondPassword" => "dzc944262316"})
    case Transaction.newTransaction(%{publicKey: publicKey, amount: amount, recipientId: recipientId, message: message, secondPublicKey: secondPublicKey, fee: 1}) do
      [:ok, transaction] -> json(conn,  %{success: true, transaction: transaction})
      [:error, _] -> json(conn,  %{success: false, transaction: []})
    end
  end

  def getStorage(conn, _) do
    json(conn,  %{})
  end

  def putStorage(conn, _) do
    json(conn,  %{})
  end
end
