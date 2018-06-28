defmodule Block.AccountServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.AccountService
  # alias Block.BlockService

  @account %{username: "sssss", u_username: "", isDelegate: 0, u_isDelegate: 0, secondSignature: 0, u_secondSignature: 0, address: AccountService.generateAddress("sssss"), publicKey: AccountService.generatePublickey("sssss"), secondPublicKey: nil, balance: 10, u_balance: 0, vote: 0, rate: 0, delegates: "", u_delegates: "", multisignatures: "", u_multisignatures: "", multimin: 1, u_multimin: 1, multilifetime: 1, u_multilifetime: 1, blockId: "1", nameexist: true, u_nameexist: true, producedblocks: 1, missedblocks: 1, fees: 0, rewards: 1, lockHeight: 1}

  test "greets hello" do
    assert AccountService.hello() == :account
  end

  test "test newAccount" do
    assert AccountService.newAccount(@account).username == @account.username
  end

  test "test getAddressByPublicKey" do
    AccountService.newAccount(@account)
    assert AccountService.getAddressByPublicKey(@account.publicKey) == @account.address
  end

  test "test getAccountByPublicKey" do
    AccountService.newAccount(@account)
    assert AccountService.getAccountByPublicKey(@account.publicKey).address == @account.address
  end

  test "test getAccount" do
    AccountService.newAccount(@account)
    assert AccountService.getAccount(@account.username).address == @account.address
  end

  # test "test delAccount1" do
  #   AccountService.newAccount(@account)
  #   AccountService.delAccount("byUsername", @account.username)
  #   assert AccountService.getAccount(@account.username) == nil
  # end
  #
  # test "test delAccount2" do
  #   AccountService.newAccount(@account)
  #   AccountService.delAccount("byPublicKey", @account.publicKey)
  #   assert AccountService.getAccount(@account.username) == nil
  # end

  # test "test delAccount3" do
  #   AccountService.newAccount(@account)
  #   AccountService.delAccount("byAddress", @account.address)
  #   assert AccountService.getAccount(@account.username) == nil
  # end

  test "test getuBalance" do
    AccountService.newAccount(@account)
    assert AccountService.getuBalance(@account.username) == @account.balance
  end

  test "test getPublickey" do
    AccountService.newAccount(@account)
    assert AccountService.getPublickey(@account.username) == @account.publicKey
  end

  test "test generatePublickey" do
    assert AccountService.generatePublickey(@account.username) == @account.publicKey
  end

  test "test generateAddress" do
    assert AccountService.generateAddress(@account.username) == @account.address
  end

end
