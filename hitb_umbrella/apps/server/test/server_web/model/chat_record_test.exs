defmodule ServerWeb.ChatRecordTest do
  use Server.DataCase

  alias Server.ChatRecord

  @valid_attrs %{date: "some date", record_string: "some record_string", room: "some room"}
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
