defmodule Repos.BlockRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  def insert_block(block) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write({:block_chain,
        block.index,
        block.previous_hash,
        block.timestamp,
        block.data,
        block.hash,
        block.generateAdress})
        :ets.insert(:latest_block, {:latest, block})
    end)
    :ok
  end

  def get_block(index) do
    #查询
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.match_object({:block_chain, String.to_integer(index), :_, :_, :_, :_})
    end)
    result
      |> Enum.map(fn x -> deserialize_block_from_record(x) end) |> hd
  end

  def get_block_by_hash(hash) do
    :mnesia.add_table_index(:block_chain, :hash)
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.index_read(:block_chain, hash, :hash)
    end)
    case result do
      [] -> []
      _ ->
        result
          |> Enum.map(fn x -> deserialize_block_from_record(x) end) |> hd
    end
  end

  def get_all_blocks() do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [deserialize_block_from_record(record) | acc]
      end, [], :block_chain)
    end)
    #按照index排序
    result
      |> Enum.sort(fn(a, b) -> a.index < b.index end)
  end

  def replace_chain(block_chain, latest_block) do
    :mnesia.transaction(fn ->
      block_chain
      |> Enum.each(fn(block) ->
        insert_block(block)
      end)
    end)
    :ets.insert(:latest_block, {:latest, latest_block})
  end

  def get_latest_block() do
    block = get_all_blocks()
    |> Enum.reduce(%{index: -1}, fn(block, acc) ->
      if (block.index > acc.index) do
        block
      else
        acc
      end
    end)
    :ets.insert(:latest_block, {:latest, block})
    block
  end

  def deserialize_block_from_record(record) do
    %Repos.Block{
      index:         elem(record, 1),
      previous_hash: elem(record, 2),
      timestamp:     elem(record, 3),
      data:          elem(record, 4),
      hash:          elem(record, 5),
      generateAdress:      elem(record, 6)
    }
  end
end
