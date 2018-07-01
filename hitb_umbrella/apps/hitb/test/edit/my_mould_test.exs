defmodule Hitb.Edit.MyMouldTest do
  use Hitb.DataCase

  alias Hitb.Edit.MyMould
  @valid_attrs %{content: "sss", name: "sss", username: "sss", header: "kkkk", is_change: false, is_show: false}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = MyMould.changeset(%MyMould{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MyMould.changeset(%MyMould{}, @invalid_attrs)
    refute changeset.valid?
  end
end
