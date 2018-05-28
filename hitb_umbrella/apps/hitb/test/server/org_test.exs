defmodule Hitb.Server.OrgTest do
  use Hitb.DataCase

  alias Hitb.Server.Org

  @valid_attrs %{county: "sss", city: "sss", name: "sss", code: "sss",
  email: "sss", is_show: true, is_ban: true, level: "sss", person_name: "sss",
  province: "sss", tel: "sss", type: "ssss", stat_org_name: 0}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = Org.changeset(%Org{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Org.changeset(%Org{}, @invalid_attrs)
    refute changeset.valid?
  end
end
