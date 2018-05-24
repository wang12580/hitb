defmodule Block.Transaction do
  @moduledoc """
  Documentation for Transaction.
  """
  def hello do
    :transaction
  end

  def newTransaction(transaction) do
    transaction = Map.merge(%{fee: 0, type: 1, id: generateId()}, transaction)
    latest_block = Block.BlockService.get_latest_block()
    sender = Account.getAccountByPublicKey(transaction.publicKey)
    case sender do
      [] -> [:error, nil, ""]
      _ ->
      tran = %{
        id: transaction.id,
        height: latest_block.index,
        blockId: to_string(latest_block.hash),
        type: transaction.type,
        timestamp: :os.system_time(:seconds),
        datetime: Block.Transaction.generateDateTime,
        senderPublicKey: sender.publicKey,
        requesterPublicKey: sender.publicKey,
        senderId: sender.index,
        recipientId: transaction.recipientId,
        amount: transaction.amount,
        fee: transaction.fee,
        signature: "",
        signSignature: "",
        args: {},
        asset: %{},
        message: transaction.message}
      #验证是否有二级密码
      case sender.secondPublicKey do
        nil ->
          recipient = Block.Account.getAccountByPublicKey(tran.recipientId)
          pay(sender, recipient, transaction, tran)
        _ ->
          if(:crypto.hash(:sha256, "#{transaction.secondPassword}")|> Base.encode64|> regex == sender.secondPublicKey)do
            recipient = Block.Account.getAccountByPublicKey(tran.recipientId)
            pay(sender, recipient, transaction, tran)
          else
            [:error, nil, "交易失败,二级密码错误"]
          end
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
  #从一个账户转移到另一个账户
  def pay(sender, recipient, transaction, insert_tran) do
    case transaction.amount > 0 do
      true ->
        case sender.balance - transaction.amount - transaction.fee < 0 do
          true ->
            [:error, nil, "交易失败,费用不足"]
          false ->
            Repos.TransactionRepository.insert_transaction(insert_tran)
            sender = %{sender | :balance => sender.balance - transaction.amount - transaction.fee}
            Repos.AccountRepository.insert_account(sender)
            recipient = %{recipient | :balance => sender.balance + transaction.amount}
            Repos.AccountRepository.insert_account(recipient)
            [:ok, %{insert_tran | :args => Tuple.to_list(insert_tran.args)}, "交易成功"]
        end
      false ->
        [:error, nil, "输入金额有误"]
    end
  end

  def generateId do
    {megaSecs, secs, _} = :erlang.now()
    randMegaSecs = :rand.uniform(megaSecs)
    randSecs = :rand.uniform(secs)
    # randMicroSecs = :random.uniform(microSecs)
    randSec = :os.system_time(:seconds)
    Enum.sort([randSec, randSecs, randMegaSecs]) |> Enum.map(fn x -> to_string(x) end) |> Enum.join("") |> String.to_integer
  end

  def generateDateTime do
    {date, time} = :calendar.local_time()
    date = date |> Tuple.to_list |> Enum.map(fn x -> if(x < 10)do "0#{x}" else "#{x}" end end) |> Enum.join("/")
    time = time |> Tuple.to_list |> Enum.map(fn x -> if(x < 10)do "0#{x}" else "#{x}" end end) |> Enum.join(":")
    "#{date} #{time}"
  end

  defp regex(s) do
    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end
end
