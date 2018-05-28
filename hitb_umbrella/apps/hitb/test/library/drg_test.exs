defmodule Hitb.Library.DrgTest do
  use Hitb.DataCase

  alias Hitb.Library.Drg

  @valid_attrs %{code: "sss", name: "sss", mdc: "sss", adrg: "sss", age: ["sss"], sf0108: ["sss"], diags_code: ["sss"], day: ["sss"], mcc: true, cc: true, rate: 0.55, year: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Drg.changeset(%Drg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Drg.changeset(%Drg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
