defmodule Hitb.Edit.PatientTest do
  use Hitb.DataCase

  alias Hitb.Edit.Patient
  @valid_attrs %{gender: "sss", name: "sss", age: "sss", nationality: "sss", marriage: "222",  native_place: "222", occupation: "3333", username: "2222", patient_id: ["222", "222"]}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Patient.changeset(%Patient{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Patient.changeset(%Patient{}, @invalid_attrs)
    refute changeset.valid?
  end
end
