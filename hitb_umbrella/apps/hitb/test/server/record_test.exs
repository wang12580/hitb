defmodule Hitb.Server.RecordTest do
  use Hitb.DataCase

  alias Hitb.Server.Record

  @valid_attrs %{mode: "10", type: "sss", username: "sss", old_value: "sss",
  value: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Record.changeset(%Record{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Record.changeset(%Record{}, @invalid_attrs)
    refute changeset.valid?
  end
end
