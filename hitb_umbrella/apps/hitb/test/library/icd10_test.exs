defmodule Hitb.Library.Icd10Test do
  use Hitb.DataCase

  alias Hitb.Library.Icd10

  @valid_attrs %{code: "sss", codes: ["sss"], name: "sss", icdcc: "sss", icdc: "sss", icdc_az: "sss", adrg: ["sss"], drg: ["sss"], cc: true, nocc_1: ["sss"], nocc_a: ["sss"], nocc_aa: ["sss"], year: "sss", mcc: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Icd10.changeset(%Icd10{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Icd10.changeset(%Icd10{}, @invalid_attrs)
    refute changeset.valid?
  end
end
