defmodule Hitb.Library.RuleAdrgTest do
  use Hitb.DataCase

  alias Hitb.Library.RuleAdrg

  @valid_attrs %{code: "sss", name: "sss", drgs_1: ["sss"], icd10_a: ["sss"], icd10_aa: ["sss"], icd10_acc: ["sss"], icd10_b: ["sss"], icd10_bb: ["sss"], icd10_bcc: ["sss"], icd9_a: ["sss"],
  icd9_aa: ["sss"], icd9_acc: ["sss"], icd9_b: ["sss"], icd9_bb: ["sss"], icd9_bcc: ["sss"], mdc: "ss", org: "ss", year: "ss", version: "sss", plat: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RuleAdrg.changeset(%RuleAdrg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RuleAdrg.changeset(%RuleAdrg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
