defmodule Block.BlockService do
  require Logger
  @moduledoc """
  Operations for blocks
  TODO: refactor :ets work into its own module
  """

  def synchronize_blockchain([_|_] = remote_block_chain) do
    # find latest block in this chain
    remote_latest_block = remote_block_chain
      |> Enum.reduce(%{index: 0}, fn(block, acc) ->
        if (block.index > acc.index) do
          block
        else
          acc
        end
      end)

    local_latest_block = get_latest_block()
    if (remote_latest_block.index > local_latest_block.index) do
      if (remote_latest_block.previousHash == local_latest_block.hash) do
        add_block(remote_latest_block)
      else
        Block.BlockRepository.replace_chain(remote_block_chain, remote_latest_block)
      end
    end
  end


  # creates a new block based on the latest one
  def create_next_block(data, secret) do
    latest_block = get_latest_block()
    latest_block = if(latest_block)do latest_block else %{index: 0, hash: ""} end
    index        = latest_block.index + 1
    timestamp    = :os.system_time(:seconds)
    hash         = generate_block_hash(index, latest_block.hash, timestamp, data)
    %{
      index:          index,
      previous_hash:  latest_block.hash,
      timestamp:      timestamp,
      data:           data,
      hash:           hash,
      generateAdress: :crypto.hash(:sha256, "#{secret}")|> Base.encode64|> regex
    }
  end

  def is_block_valid(new_block, previous_block) do
    if new_block.index - 1 != previous_block.index
    || new_block.previous_hash != previous_block.hash
    || generate_hash_from_block(new_block) != new_block.hash do
        Logger.debug("Invalid block new_block: #{inspect new_block} prev_block: #{inspect previous_block}")
        false
    else
        true
    end
  end

  def add_block(block) do
    latest_block = get_latest_block()
    latest_block = if(latest_block)do latest_block else %{index: 0, hash: ""} end
    if is_block_valid(block, latest_block) do
      Block.BlockRepository.insert_block(block)
    end
  end

  def get_latest_block() do
    case :ets.lookup(:latest_block, :latest) do
      [] ->
        Block.BlockRepository.get_latest_block()
    list ->
      list |> hd |> elem(1)
    end
  end

  defp generate_hash_from_block(block) do
    generate_block_hash(block.index, block.previous_hash, block.timestamp, block.data)
  end

  defp generate_block_hash(index, previous_hash, timestamp, data) do
    :crypto.hash(:sha256, "#{index}#{previous_hash}#{timestamp}#{data}")
    |> Base.encode64 |> regex
  end

  defp regex(s) do
    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end
end
