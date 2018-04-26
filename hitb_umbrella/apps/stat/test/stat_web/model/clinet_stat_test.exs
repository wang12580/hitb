defmodule Stat.ClientStatTest do
  use Stat.DataCase

  alias Stat.ClientStat

  @valid_attrs %{username: "sss", filename: "sss", data: "sss",}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = ClientStat.changeset(%ClientStat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ClientStat.changeset(%ClientStat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
