defmodule Hitb.Library.WesternMedicineTest do
  use Hitb.DataCase
  alias Hitb.Library.WesternMedicine
  @valid_attrs %{first_level: "sss", second_level: "sss", third_level: "sss", zh_name: "sss", en_name: "ccc", dosage_form: "222", reimbursement_restrictions: "2222"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = WesternMedicine.changeset(%WesternMedicine{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = WesternMedicine.changeset(%WesternMedicine{}, @invalid_attrs)
    refute changeset.valid?
  end
end
