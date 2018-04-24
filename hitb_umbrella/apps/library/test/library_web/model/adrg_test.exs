defmodule Library.AdrgTest do
  use Library.DataCase

  alias Library.Adrg

  @valid_attrs %{code: "sss", name: "sss", drgs_1: ["s"], icd10a1: ["s"], icd10a2: ["s"], icd9a1: ["s"], icd9a2: ["s"], icd10d1: ["s"], icd10d2: ["s"], icd9d1: ["s"], icd9d2: ["s"], opers_code: ["s"], sf0100: ["s"], sf0102: ["s"], mdc: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Adrg.changeset(%Adrg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Adrg.changeset(%Adrg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
