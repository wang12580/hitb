defmodule HitbWeb.BlockController do
  use HitbWeb, :controller
  alias Repos
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def add_block(conn, payload) do
    block = Repos.BlockService.create_next_block(payload["data"])
    Repos.BlockService.add_block(block)
    json(conn, %{})
  end

  def get_all_blocks(conn, _) do
    all_blocks = Repos.BlockChainRepository.get_all_blocks()
    json(conn,  %{blocks: all_blocks})
  end
end
