defmodule Library.MdcTest do
  use Library.DataCase

  alias Library.Mdc

  @valid_attrs %{code: "sss", name: "sss", mdc: "sss", is_p: true, gender: "sss", year: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Mdc.changeset(%Mdc{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Mdc.changeset(%Mdc{}, @invalid_attrs)
    refute changeset.valid?
  end
end
