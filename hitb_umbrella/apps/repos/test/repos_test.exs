defmodule ReposTest do
  use ExUnit.Case
  doctest Repos

  test "greets the world" do
    assert Repos.hello() == :world
  end
end
