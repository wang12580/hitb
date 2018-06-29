defmodule Hitb.Library.ChineseMedicinePatentTest do
  use Hitb.DataCase

  alias Hitb.Library.ChineseMedicinePatent

  @valid_attrs %{code: "sss", medicine_type: "sss", type: "sss", medicine_code: "sss", name: "sss", name_1: "sss", other_spec: "sss", org_limit: "sss", department_limit: "sss", user_limit: "sss", other_limit: "sss"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChineseMedicinePatent.changeset(%ChineseMedicinePatent{},@valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChineseMedicinePatent.changeset(%ChineseMedicinePatent{},@invalid_attrs)
    refute changeset.valid?
  end
end
