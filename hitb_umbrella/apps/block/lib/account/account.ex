defmodule Block.Account do
  @moduledoc """
  Documentation for Account.
  """
  def hello do
    :account
  end

  def getAddressByPublicKey(publicKey) do
    account = Repos.AccountRepository.get_account_by_publicKey(publicKey)
    case account do
      [] -> nil
      _ -> account.address
    end
  end

  def getAccountByPublicKey(publicKey) do
    account = Repos.AccountRepository.get_account_by_publicKey(publicKey)
    case account do
      [] -> []
      _ -> account
    end
  end

  def getAddressByAddress(address) do
    account = Repos.AccountRepository.get_account_by_address(address)
    case account do
      [] -> nil
      _ -> account
    end
  end


  def vote do

  end

  def accounts do

  end

  def getAccount(username) do
    Repos.AccountRepository.get_account(username)
  end

  def delAccount(by, value) do
    _account =
      case by do
         "byUsername" -> deserialize_record_from_account(getAccount(value))
         "byPublicKey" -> deserialize_record_from_account(getAccountByPublicKey(value))
         "byAddress" -> deserialize_record_from_account(getAddressByAddress(value))
      end
    # case :mnesia.transaction(fn -> :mnesia.delete_object(account) end) do
    #   {:ok, _} -> :ok
    #   {:atomic, _} -> :error
    # end
  end

  def newAccount(account) do
    accounts = Repos.AccountRepository.get_all_accounts
    usernames = accounts |> Enum.map(fn x -> x.username end)
    if account.username in usernames do
      false
    else
      address = generateAddress(account.username)
      publicKey = generatePublickey(account.username)
      index = Repos.AccountRepository.get_all_accounts |> Enum.map(fn x -> x.index end) |> List.last
      index =
        case index do
          nil -> 0
          _ -> index + 1
        end
      latest_block = Block.BlockService.get_latest_block()
      %{index: index, username: account.username, u_username: "", isDelegate: 0, u_isDelegate: 0, secondSignature: 0, u_secondSignature: 0, address: address, publicKey: publicKey, secondPublicKey: nil, balance: account.balance, u_balance: 0, vote: 0, rate: 0, delegates: "", u_delegates: "", multisignatures: "", u_multisignatures: "", multimin: 1, u_multimin: 1, multilifetime: 1, u_multilifetime: 1, blockId: to_string(latest_block.index), nameexist: true, u_nameexist: true, producedblocks: 1, missedblocks: 1, fees: 0, rewards: 1, lockHeight: to_string(latest_block.index)}
    end
  end

  def getBalance(username) do
    account = Repos.AccountRepository.get_account(username)
    case account do
      [] -> 0.0
      _ -> account.balance
    end
  end

  def getuBalance(username) do
    account = Repos.AccountRepository.get_account(username)
    case account do
      [] -> 0.0
      _ -> account.u_balance
    end
  end

  def getPublickey(username) do
    account = Repos.AccountRepository.get_account(username)
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
    case Repos.AccountRepository.update_secondPublicKey(account) do
      {_, :ok} ->
        latest_block = Block.BlockService.get_latest_block()
        tran = %{
          id: Block.Transaction.generateId,
          height: latest_block.index,
          blockId: to_string(latest_block.index),
          type: 5,
          timestamp: :os.system_time(:seconds),
          datetime: Block.Transaction.generateDateTime,
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
        Repos.TransactionRepository.insert_transaction(tran)
        Repos.AccountRepository.insert_account(Map.merge(account, %{balance: account.balance - 5}))
        [true, tran.id]
      _ ->
        [false, []]
    end
  end

  defp deserialize_record_from_account(account) do
    case account do
      [] -> []
      _ ->
        {:account,
        account.index,
        account.username,
        account.u_username,
        account.isDelegate,
        account.secondSignature,
        account.u_secondSignature,
        account.address,
        account.publicKey,
        account.secondPublicKey,
        account.balance,
        account.u_balance,
        account.vote,
        account.rate,
        account.delegates,
        account.u_delegates,
        account.multisignatures,
        account.u_multisignatures,
        account.multimin,
        account.u_multimin,
        account.multilifetime,
        account.u_multilifetime,
        account.blockId,
        account.nameexist,
        account.u_nameexist,
        account.producedblocks,
        account.missedblocks,
        account.fees,
        account.rewards,
        account.lockHeight}
    end
  end

  defp regex(s) do
    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end
end
