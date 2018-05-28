defmodule Block.TransactionServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.TransactionService
  alias Block.AccountService

  @transaction %{publicKey: "fQCGuNfIkJ8FHlcOJeYZHOSKmUnjJ4KjjEnn4anb4", amount: 100, recipientId: "sss", message: "sss", secondPassword: "ssssss", fee: 1}

  @sender %{username: "dssss", u_username: "", isDelegate: 0, u_isDelegate: 0, secondSignature: 0, u_secondSignature: 0, address: AccountService.generateAddress("dssss"), publicKey: AccountService.generatePublickey("dssss"), secondPublicKey: nil, balance: 10, u_balance: 0, vote: 0, rate: 0, delegates: "", u_delegates: "", multisignatures: "", u_multisignatures: "", multimin: 1, u_multimin: 1, multilifetime: 1, u_multilifetime: 1, blockId: "1", nameexist: true, u_nameexist: true, producedblocks: 1, missedblocks: 1, fees: 0, rewards: 1, lockHeight: 1}

  test "test hello" do
    assert TransactionService.hello() == :transaction
  end

  test "test newTransaction" do
    assert TransactionService.newTransaction(@transaction) == [:error, nil, ""]
  end

  test "test pay" do
    # assert TransactionService.pay(@sender, "recipient" @transaction) == [:error, nil, ""]
  end

  test "test generateId" do
    assert TransactionService.generateId() != nil
  end

  test "test generateDateTime" do
    assert TransactionService.generateDateTime() != nil
  end

end
