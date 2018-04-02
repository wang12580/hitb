defmodule Repos.TransactionRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  # def insert_block(block) do
  #   {:atomic, _} = :mnesia.transaction(fn ->
  #     :mnesia.write({:block_chain,
  #       block.index,
  #       block.previous_hash,
  #       block.timestamp,
  #       block.data,
  #       block.hash})
  #       :ets.insert(:latest_block, {:latest, block})
  #   end)
  #   :ok
  # end

  # def get_block(index) do
  #   #查询
  #   {:atomic, result} = :mnesia.transaction(fn ->
  #     :mnesia.match_object({:block_chain, String.to_integer(index), :_, :_, :_, :_})
  #   end)
  #   result
  #     |> Enum.map(fn x -> deserialize_block_from_record(x) end) |> hd
  # end

  def get_all_transactions() do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [deserialize_transaction_from_record(record) | acc]
      end, [], :transaction)
    end)
    # #按照index排序
    # result
    #   |> Enum.sort(fn(a, b) -> a.index < b.index end)
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
      args:               elem(record, 15),
      message:            elem(record, 16)
    }
  end
end
