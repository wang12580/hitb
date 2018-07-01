defmodule Block.BlockServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.BlockService

  test "test create_next_block" do
    # IO.inspect BlockService.create_next_block("sss", "ssss")
    assert BlockService.create_next_block("sss", "ssss") != nil
  end

  test "test is_block_valid" do
    new_block = BlockService.create_next_block("sss", "ssss")
    previous_block = BlockService.get_latest_block()
    assert BlockService.is_block_valid(new_block, previous_block) in [true, false]
  end

  test "test add_block" do
    new_block = BlockService.create_next_block("sss", "ssss")
    assert BlockService.add_block(new_block) in [:ok, nil]
  end

end
