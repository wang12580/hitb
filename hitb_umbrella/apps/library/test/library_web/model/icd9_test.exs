defmodule Library.Icd9Test do
  use Library.DataCase

  alias Library.Icd9

  @valid_attrs %{code: "sss", codes: ["sss"], name: "sss", icdcc: "sss", icdc: "sss", adrg: ["sss"], drg: ["sss"], p_type: 1, is_qy: true,
  year: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Icd9.changeset(%Icd9{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Icd9.changeset(%Icd9{}, @invalid_attrs)
    refute changeset.valid?
  end
end
