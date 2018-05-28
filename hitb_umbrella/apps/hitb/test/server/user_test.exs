defmodule Hitb.Server.UserTest do
  use Hitb.DataCase

  alias Hitb.Server.User

  @valid_attrs %{age: 10, email: "sss", hashpw: "sss", name: "sss",
  org: "sss", tel: "sss", username: "sss",
  type: 0, key: ["sss", "ww", "xxx"]}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
