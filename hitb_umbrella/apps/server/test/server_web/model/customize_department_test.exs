defmodule Server.CustomizeDepartmentTest do
  use Server.DataCase

  alias Server.CustomizeDepartment

  @valid_attrs %{org: "10", c_user: "sss", cherf_department: "sss", class: "sss",
  department: "ssss", is_imp: true, is_spe: true, is_ban: true, professor: "sss",
  wt_code: "sssss", wt_name: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = CustomizeDepartment.changeset(%CustomizeDepartment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CustomizeDepartment.changeset(%CustomizeDepartment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
