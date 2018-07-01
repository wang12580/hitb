defmodule Hitb.Stat.ClientStatTest do
  use Hitb.DataCase

  alias Hitb.Stat.ClientSaveStat

  @valid_attrs %{username: "sss", filename: "sss", data: "sss",}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = ClientSaveStat.changeset(%ClientSaveStat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ClientSaveStat.changeset(%ClientSaveStat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
