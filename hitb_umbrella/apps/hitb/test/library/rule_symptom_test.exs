defmodule Hitb.Library.RuleSymptomTest do
  use Hitb.DataCase

  alias Hitb.Library.RuleSymptom
  @valid_attrs %{symptom: "sss", icd9_a: ["sss"], icd10_a: ["sss"], pharmacy: ["sss"]}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RuleSymptom.changeset(%RuleSymptom{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RuleSymptom.changeset(%RuleSymptom{}, @invalid_attrs)
    refute changeset.valid?
  end
end
