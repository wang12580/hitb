defmodule Account do
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

  def vote do

  end

  def accounts do

  end

  def getAccount(username) do
    Repos.AccountRepository.get_account(username)
  end

  def newAccount(account) do
    address = :crypto.hash(:sha256, "#{account.username}")
      |> Base.encode64
    publicKey = :crypto.hash(:sha256, "publicKey#{account.username}")
      |> Base.encode64
    latest_block = Block.BlockService.get_latest_block()
    account = %{index: 1, username: account.username, u_username: "", isDelegate: 0, u_isDelegate: 0, secondSignature: 0, u_secondSignature: 0, address: address, publicKey: publicKey, secondPublicKey: "1", balance: 100000, u_balance: 0, vote: 0, rate: 0, delegates: "", u_delegates: "", multisignatures: "", u_multisignatures: "", multimin: 1, u_multimin: 1, multilifetime: 1, u_multilifetime: 1, blockId: to_string(latest_block.index), nameexist: true, u_nameexist: true, producedblocks: 1, missedblocks: 1, fees: 0, rewards: 1, lockHeight: to_string(latest_block.index)}
    Repos.AccountRepository.insert_account(account)
  end

  def getBalance do

  end

  def getPublickey(username) do
    account = Repos.AccountRepository.get_account(username)
    case account do
      [] -> nil
      _ -> account.publicKey
    end
  end

  def generatePublickey do

  end

  def getDelegates do

  end

  def getDelegatesFee do

  end

  def addDelegates do

  end
end
