defmodule Library.DrgRateTest do
  use Library.DataCase

  alias Library.DrgRate

  @valid_attrs %{drg: "sss", name: "sss", rate: 0.55, type: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DrgRate.changeset(%DrgRate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DrgRate.changeset(%DrgRate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
