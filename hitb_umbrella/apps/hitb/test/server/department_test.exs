defmodule Hitb.Server.DepartmentTest do
  use Hitb.DataCase

  alias Hitb.Server.Department

  @valid_attrs %{class_code: "000", class_name: "sss", department_code: "sss", department_name: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Department.changeset(%Department{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Department.changeset(%Department{}, @invalid_attrs)
    refute changeset.valid?
  end
end
