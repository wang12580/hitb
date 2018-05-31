defmodule Block.AccountService do
  @moduledoc """
  Documentation for Account.
  """
  def hello do
    :account
  end

  def newAccount(account) do
    usernames = Block.AccountRepository.get_all_usernames
    if account.username in usernames do
      false
    else
      address = generateAddress(account.username)
      publicKey = generatePublickey(account.username)
      index = accounts |> Enum.map(fn x -> x.index end)
      [index, latest_block_index] =
        case index do
          nil -> [0, 0]
          [] -> [0, 0]
          _ -> [hd(index) + 1, Block.BlockService.get_latest_block().index]
        end
      account = %{index: index, username: account.username, u_username: "", isDelegate: 0, u_isDelegate: 0, secondSignature: 0, u_secondSignature: 0, address: address, publicKey: publicKey, secondPublicKey: nil, balance: account.balance, u_balance: 0, vote: 0, rate: 0, delegates: "", u_delegates: "", multisignatures: "", u_multisignatures: "", multimin: 1, u_multimin: 1, multilifetime: 1, u_multilifetime: 1, blockId: to_string(latest_block_index), nameexist: true, u_nameexist: true, producedblocks: 1, missedblocks: 1, fees: 0, rewards: 1, lockHeight: to_string(latest_block_index)}
      Block.AccountRepository.insert_account(account)
      account
    end
  end

  def getAddressByPublicKey(publicKey) do
    account = Block.AccountRepository.get_account_by_publicKey(publicKey)
    case account do
      nil -> nil
      [] -> nil
      _ -> account.address
    end
  end

  def getAccountByPublicKey(publicKey) do
    account = Block.AccountRepository.get_account_by_publicKey(publicKey)
    case account do
      nil -> nil
      [] -> nil
      _ -> Map.drop(account, [:__meta__, :__struct__])
    end
  end

  def getAddressByAddress(address) do
    account = Block.AccountRepository.get_account_by_address(address)
    case account do
      [] -> nil
      _ -> account.address
    end
  end

  def getAccountByAddress(address) do
    account = Block.AccountRepository.get_account_by_address(address)
    case account do
      [] -> nil
      _ -> Map.drop(account, [:__meta__, :__struct__])
    end
  end

  def vote do

  end

  def accounts do

  end

  def getAccount(username) do
    Block.AccountRepository.get_account(username)
  end

  def delAccount(by, value) do
    account =
      case by do
         "byUsername" -> getAccount(value)
         "byPublicKey" -> getAccountByPublicKey(value)
         "byAddress" -> getAddressByAddress(value)
      end
    # IO.inspect
    Block.AccountRepository.delete_account(account)
  end

  def getBalance(username) do
    account = Block.AccountRepository.get_account(username)
    case account do
      [] -> 0.0
      _ -> account.balance
    end
  end

  def getuBalance(username) do
    account = Block.AccountRepository.get_account(username)
    case account do
      [] -> 0.0
      _ -> account.balance
    end
  end

  def getPublickey(username) do
    account = Block.AccountRepository.get_account(username)
    case account do
      [] -> nil
      _ -> account.publicKey
    end
  end

  def generatePublickey(username) do
    :crypto.hash(:sha256, "publicKey#{username}")
      |> Base.encode64 |> regex
  end

  def generateAddress(username) do
    :crypto.hash(:sha256, "#{username}")
      |> Base.encode64 |> regex
  end

  def getDelegates do

  end

  def getDelegatesFee do

  end

  def addDelegates do

  end

  def addSignature(username, password) do
    secondPublicKey = :crypto.hash(:sha256, "#{password}")
      |> Base.encode64|> regex
    account = getAccount(username)
    account = %{account | :secondPublicKey => secondPublicKey}
    case Block.AccountRepository.update_secondPublicKey(account) do
      {_, :ok} ->
        latest_block = Block.BlockService.get_latest_block()
        tran = %{
          id: Block.TransactionService.generateId,
          height: latest_block.index,
          blockId: to_string(latest_block.index),
          type: 5,
          timestamp: :os.system_time(:seconds),
          datetime: Block.TransactionService.generateDateTime,
          senderPublicKey: account.publicKey,
          requesterPublicKey: "",
          senderId: account.index,
          recipientId: "",
          amount: 0,
          fee: 5,
          signature: "",
          signSignature: "",
          args: {},
          asset: %{},
          message: "设置二级密码"}
          Block.TransactionRepository.insert_transaction(tran)
          Block.AccountRepository.insert_account(Map.merge(account, %{balance: account.balance - 5}))
        [true, tran.id]
      _ ->
        [false, []]
    end
  end

  defp regex(s) do
    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end
end
