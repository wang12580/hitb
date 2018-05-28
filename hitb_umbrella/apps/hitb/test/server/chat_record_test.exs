defmodule Hitb.ServerWeb.ChatRecordTest do
  use Hitb.DataCase

  alias Hitb.Server.ChatRecord

  @valid_attrs %{date: "some date", record_string: "some record_string", room: "some room", record_array: ["sssss"]}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = ChatRecord.changeset(%ChatRecord{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChatRecord.changeset(%ChatRecord{}, @invalid_attrs)
    refute changeset.valid?
  end
end
