defmodule Hitb.Library.CdhTest do
  use Hitb.DataCase

  alias Hitb.Library.Cdh
  @valid_attrs %{key: "sss", value: "sss"}
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
