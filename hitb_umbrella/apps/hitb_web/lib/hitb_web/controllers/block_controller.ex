defmodule HitbWeb.BlockController do
  use HitbWeb, :controller
  alias Block
  alias Repos
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def add_block(conn, payload) do
    block = Block.BlockService.create_next_block(payload["data"])
    Block.BlockService.add_block(block)
    json(conn, %{})
  end

  def get_all_blocks(conn, _) do
    all_blocks = Repos.BlockRepository.get_all_blocks()
    json(conn,  %{blocks: all_blocks})
  end

  def getBlock(conn, _) do
    json(conn, %{})
  end

  def getFullBlock(conn, _) do
    json(conn, %{})
  end

  def getBlocks(conn, _) do
    json(conn, %{})
  end

  def getHeight(conn, _) do
    json(conn, %{})
  end

  def getFee(conn, _) do
    json(conn, %{})
  end

  def getMilestone(conn, _) do
    json(conn, %{})
  end

  def getReward(conn, _) do
    json(conn, %{})
  end

  def getSupply(conn, _) do
    json(conn, %{})
  end

  def getStatus(conn, _) do
    json(conn, %{})
  end
end

