defmodule Edit.CdaTest do
  use Edit.DataCase

  alias Edit.Client.Cda
  @valid_attrs %{content: "sss", name: "sss", username: "sss"}
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
