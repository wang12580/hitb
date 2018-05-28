defmodule Hitb.Edit.CdaTest do
  use Hitb.DataCase

  alias Hitb.Edit.Cda
  @valid_attrs %{content: "sss", name: "sss", username: "sss", is_show: false, is_change: false}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Cda.changeset(%Cda{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cda.changeset(%Cda{}, @invalid_attrs)
    refute changeset.valid?
  end
end
