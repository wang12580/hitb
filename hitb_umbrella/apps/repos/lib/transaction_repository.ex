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
        transaction.datetime,
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
    # :mnesia.add_table_index(:transaction, :id)
    :mnesia.add_table_index(:transaction, :senderPublicKey)
    :mnesia.add_table_index(:transaction, :recipientId)
    :ok
  end

  def get_transactions_by_id(id) do
    #查询
    {:atomic, result} = :mnesia.transaction(fn ->
      # :mnesia.index_read(:transaction, String.to_integer(id), :id)
      :mnesia.match_object({:transaction, String.to_integer(id), :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_})
    end)
    case result do
      [] -> nil
      _ -> result|> Enum.map(fn x -> deserialize_transaction_from_record(x) end) |> hd
    end
  end

  def get_transactions_by_publicKey(publicKey) do
    #查询
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.index_read(:transaction, publicKey, :senderPublicKey)
      # :mnesia.match_object({:transaction, String.to_integer(id), :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_, :_})
    end)
    case result do
      [] -> nil
      _ -> result|> Enum.map(fn x -> deserialize_transaction_from_record(x) end) |> hd
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
      |> Enum.sort(fn(a, b) -> a.datetime < b.datetime end)
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
      datetime:           elem(record, 6),
      senderPublicKey:    elem(record, 7),
      requesterPublicKey: elem(record, 8),
      senderId:           elem(record, 9),
      recipientId:        elem(record, 10),
      amount:             elem(record, 11),
      fee:                elem(record, 12),
      signature:          elem(record, 13),
      signSignature:      elem(record, 14),
      asset:              elem(record, 15),
      args:               Tuple.to_list(elem(record, 16)),
      message:            elem(record, 17)
    }
  end
end
