defmodule Repos.AccountRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  def insert_account(account) do
    IO.inspect {:account,
      index:             account.index, #索引
      username:          account.username, #用户名
      u_username:        account.u_username,
      isDelegate:        account.isDelegate, #是否委托人
      u_isDelegate:      account.u_isDelegate,
      secondSignature:   account.secondSignature,
      u_secondSignature: account.u_secondSignature,
      address:           account.address,
      publicKey:         account.publicKey,
      secondPublicKey:   account.secondPublicKey,
      balance:           account.balance,
      u_balance:         account.u_balance,
      vote:              account.vote,
      rate:              account.rate,
      delegates:         account.delegates,
      u_delegates:       account.u_delegates,
      multisignatures:   account.multisignatures,
      u_multisignatures: account.u_multisignatures,
      multimin:          account.multimin,
      u_multimin:        account.u_multimin,
      multilifetime:     account.multilifetime,
      u_multilifetime:   account.u_multilifetime,
      blockId:           account.blockId,
      nameexist:         account.nameexist,
      u_nameexist:       account.u_nameexist,
      producedblocks:    account.producedblocks,
      missedblocks:      account.missedblocks,
      fees:              account.fees,
      rewards:           account.rewards,
      lockHeight:        account.lockHeight}
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write({:account,
        account.index, #索引
        account.username, #用户名
        account.u_username,
        account.isDelegate, #是否委托人
        account.u_isDelegate,
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
        account.lockHeight})
        # :ets.insert(:account, {:latest, block})
    end)
    :ok
  end

  def get_all_accounts() do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [deserialize_account_from_record(record) | acc]
      end, [], :account)
    end)
    {:atomic, result2} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [record | acc]
      end, [], :account)
    end)
    #按照index排序
    result
      |> Enum.sort(fn(a, b) -> a.index < b.index end)
  end

  def delete_all_account() do
    :mnesia.clear_table(:account)
  end

  def deserialize_account_from_record(record) do
    %Repos.Account{
      index:              elem(record, 1), #索引
      username:           elem(record, 2), #用户名
      u_username:         elem(record, 3),
      isDelegate:         elem(record, 4), #是否委托人
      u_isDelegate:       elem(record, 5),
      secondSignature:    elem(record, 6),
      u_secondSignature:  elem(record, 7),
      address:            elem(record, 8),
      publicKey:          elem(record, 9),
      secondPublicKey:    elem(record, 10),
      balance:            elem(record, 11),
      u_balance:          elem(record, 12),
      vote:               elem(record, 13),
      rate:               elem(record, 14),
      delegates:          elem(record, 15),
      u_delegates:        elem(record, 16),
      multisignatures:    elem(record, 17),
      u_multisignatures:  elem(record, 18),
      multimin:           elem(record, 19),
      u_multimin:         elem(record, 20),
      multilifetime:      elem(record, 21),
      u_multilifetime:    elem(record, 22),
      blockId:            elem(record, 23),
      nameexist:          elem(record, 24),
      u_nameexist:        elem(record, 25),
      producedblocks:     elem(record, 26),
      missedblocks:       elem(record, 27),
      fees:               elem(record, 28),
      rewards:            elem(record, 29),
      lockHeight:         elem(record, 30)
    }
  end
end
