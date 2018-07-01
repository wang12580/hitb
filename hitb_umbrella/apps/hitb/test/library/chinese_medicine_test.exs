defmodule Hitb.Library.ChineseMedicineTest do
  use Hitb.DataCase

  alias Hitb.Library.ChineseMedicine

  @valid_attrs %{code: "sss", name: "sss", name_1: "sss", sexual_taste: "sss", toxicity: "sss", meridian: "sss", effect: "sss", indication: "sss", consumption: "sss", need_attention: "true", type: "true"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChineseMedicine.changeset(%ChineseMedicine{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChineseMedicine.changeset(%ChineseMedicine{}, @invalid_attrs)
    refute changeset.valid?
  end
end
