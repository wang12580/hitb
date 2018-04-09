defmodule Transaction do
  @moduledoc """
  Documentation for Transaction.
  """
  def hello do
    :transaction
  end

  def newTransaction(transaction) do
    transaction = Map.merge(%{fee: 0, type: 1, id: generateId}, transaction)
    latest_block = Block.BlockService.get_latest_block()
    sender = Account.getAccount(transaction.secret)
    tran = %{
      id: transaction.id,
      height: latest_block.index,
      blockId: to_string(latest_block.index),
      type: transaction.type,
      timestamp: :os.system_time(:seconds),
      senderPublicKey: sender.publicKey,
      requesterPublicKey: "",
      senderId: sender.index,
      recipientId: transaction.recipientId,
      amount: transaction.amount,
      fee: transaction.fee,
      signature: "",
      signSignature: "",
      args: {},
      asset: %{},
      message: transaction.message}
    case sender.secondPublicKey do
      nil ->
        Repos.TransactionRepository.insert_transaction(tran)
        [:ok, %{tran | :args => Tuple.to_list(tran.args)}]
      _ ->
        if(:crypto.hash(:sha256, "#{transaction.secondPublicKey}")|> Base.encode64 == sender.secondPublicKey)do
          Repos.TransactionRepository.insert_transaction(tran)
          [:ok, %{tran | :args => Tuple.to_list(tran.args)}]
        else
          [:error, nil]
        end
    end
  end

  def attachAssetType do

  end

  def sign do

  end

  def multisign do

  end

  def getId do

  end

  def getId2 do

  end

  def getHash do

  end

  def ready do

  end

  def process do

  end

  def verify do

  end

  def verifySignature do

  end

  def verifySecondSignature do

  end

  def generateId do
    {megaSecs, secs, microSecs} = :erlang.now()
    # randMegaSecs = :random.uniform(megaSecs)
    randSecs = :random.uniform(secs)
    randMicroSecs = :random.uniform(microSecs)
    randSec = :os.system_time(:seconds)
    Enum.sort([randSecs, randMicroSecs, randSec]) |> Enum.map(fn x -> to_string(x) end) |> Enum.join("") |> String.to_integer
  end
end
