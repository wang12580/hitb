defmodule Hitb.Edit.CdhTest do
  use Hitb.DataCase

  alias Hitb.Edit.Cdh
  @valid_attrs %{content: "sss", name: "sss", type: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Cdh.changeset(%Cdh{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cdh.changeset(%Cdh{}, @invalid_attrs)
    refute changeset.valid?
  end
end
