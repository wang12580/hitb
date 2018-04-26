defmodule Library.RuleMdcTest do
  use Library.DataCase

  alias Library.RuleMdc

  @valid_attrs %{code: "sss", name: "sss", mdc: "s", icd9_a: ["ss"], icd9_aa: ["ss"], icd10_a: ["ss"], icd10_aa: ["ss"], org: "Ss", year: "sss", version: "sss", plat: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RuleMdc.changeset(%RuleMdc{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RuleMdc.changeset(%RuleMdc{}, @invalid_attrs)
    refute changeset.valid?
  end
end
