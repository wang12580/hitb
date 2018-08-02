defmodule Hitb.Library.RulePharmacyTest do
  use Hitb.DataCase

  alias Hitb.Library.RulePharmacy
  @valid_attrs %{pharmacy: "sss", icd10_a: ["sss"], symptom: ["sss"]}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RulePharmacy.changeset(%RulePharmacy{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RulePharmacy.changeset(%RulePharmacy{}, @invalid_attrs)
    refute changeset.valid?
  end
end
