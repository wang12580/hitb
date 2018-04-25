defmodule Library.LibWt4Test do
  use Library.DataCase

  alias Library.LibWt4

  @valid_attrs %{code: "sss", name: "sss", year: "sss", type: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = LibWt4.changeset(%LibWt4{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LibWt4.changeset(%LibWt4{}, @invalid_attrs)
    refute changeset.valid?
  end
end
