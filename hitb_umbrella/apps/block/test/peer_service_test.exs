defmodule Block.PeerServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.PeerService

  test "test hello" do
    assert PeerService.hello() == :world
  end

  test "test getPublicIp" do
    assert PeerService.getPublicIp() == nil
  end

  test "test newPeer" do
    assert PeerService.newPeer("127.0.0.1", "4000") == :ok
  end

end
