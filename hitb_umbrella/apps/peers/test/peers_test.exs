defmodule PeersTest do
  use ExUnit.Case
  doctest Peers

  test "greets the world" do
    assert Peers.hello() == :world
  end
end
