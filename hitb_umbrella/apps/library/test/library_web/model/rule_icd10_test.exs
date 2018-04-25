defmodule Library.RuleIcd10Test do
  use Library.DataCase

  alias Library.RuleIcd10

  @valid_attrs %{code: "sss", name: "sss", codes: ["s"], icdcc: "sss", dissect: "sss", icdc: "sss", icdc_az: "ss", adrg: ["ss"], mdc: ["ss"], cc: true, nocc_1: ["ss"], nocc_a: ["ss"], nocc_aa: ["ss"],  mcc: true, org: "Ss", year: "sss", version: "sss", plat: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RuleIcd10.changeset(%RuleIcd10{}, @valid_attrs)
    assert changeset.valid?
  end
  
  test "changeset with invalid attributes" do
    changeset = RuleIcd10.changeset(%RuleIcd10{}, @invalid_attrs)
    refute changeset.valid?
  end
end
