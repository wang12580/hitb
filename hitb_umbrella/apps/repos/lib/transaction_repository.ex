defmodule Repos.TransactionRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  def insert_transaction(transaction) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write({:transaction,
        transaction.id,
        transaction.height,
        transaction.blockId,
        transaction.type,
        transaction.timestamp,
        transaction.senderPublicKey,
        transaction.requesterPublicKey,
        transaction.senderId,
        transaction.recipientId,
        transaction.amount,
        transaction.fee,
        transaction.signature,
        transaction.signSignature,
        transaction.asset,
        transaction.args,
        transaction.message})
    end)
    :ok
  end

  # def get_block(index) do
  #   #查询
  #   {:atomic, result} = :mnesia.transaction(fn ->
  #     :mnesia.match_object({:block_chain, String.to_integer(index), :_, :_, :_, :_})
  #   end)
  #   result
  #     |> Enum.map(fn x -> deserialize_block_from_record(x) end) |> hd
  # end
  def get_transactions_by_id(id) do
    #查询
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.match_object({:transaction, String.to_integer(id), :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_})
    end)
    case result do
      [] ->
        result|> Enum.map(fn x -> deserialize_transaction_from_record(x) end) |> hd
      _ ->
        nil
    end
  end


  def get_all_transactions() do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [deserialize_transaction_from_record(record) | acc]
      end, [], :transaction)
    end)
    #按照id排序
    result
      |> Enum.sort(fn(a, b) -> a.id < b.id end)
  end

  # def replace_chain(block_chain, latest_block) do
  #   :mnesia.transaction(fn ->
  #     block_chain
  #     |> Enum.each(fn(block) ->
  #       insert_block(block)
  #     end)
  #   end)
  #   :ets.insert(:latest_block, {:latest, latest_block})
  # end

  # def get_latest_block() do
  #   block = get_all_blocks()
  #   |> Enum.reduce(%{index: -1}, fn(block, acc) ->
  #     if (block.index > acc.index) do
  #       block
  #     else
  #       acc
  #     end
  #   end)
  #   :ets.insert(:latest_block, {:latest, block})
  #   block
  # end

  def deserialize_transaction_from_record(record) do
    %Repos.Transaction{
      id:                 elem(record, 1),
      height:             elem(record, 2),
      blockId:            elem(record, 3),
      type:               elem(record, 4),
      timestamp:          elem(record, 5),
      senderPublicKey:    elem(record, 6),
      requesterPublicKey: elem(record, 7),
      senderId:           elem(record, 8),
      recipientId:        elem(record, 9),
      amount:             elem(record, 10),
      fee:                elem(record, 11),
      signature:          elem(record, 12),
      signSignature:      elem(record, 13),
      asset:              elem(record, 14),
      args:               Tuple.to_list(elem(record, 15)),
      message:            elem(record, 16)
    }
  end
end
