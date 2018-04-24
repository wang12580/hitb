defmodule Library.RuleIcd9Test do
  use Library.DataCase

  alias Library.RuleIcd9

  @valid_attrs %{code: "sss", name: "sss", codes: ["s"], icdcc: "sss", icdc: "sss", dissect: "sss", adrg: ["ss"], p_type: 1, property: "ss", option: "ds", org: "Ss", year: "sss", version: "sss", plat: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = RuleIcd9.changeset(%RuleIcd9{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RuleIcd9.changeset(%RuleIcd9{}, @invalid_attrs)
    refute changeset.valid?
  end
end
