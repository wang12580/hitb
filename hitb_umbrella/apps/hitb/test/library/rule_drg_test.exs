defmodule Hitb.Library.RuleDrgTest do
  use Hitb.DataCase

  alias Hitb.Library.RuleDrg

  @valid_attrs %{code: "sss", name: "sss", mdc: "sss", adrg: "sss", org: "sss", year: "sss", version: "sss", plat: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = RuleDrg.changeset(%RuleDrg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RuleDrg.changeset(%RuleDrg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
