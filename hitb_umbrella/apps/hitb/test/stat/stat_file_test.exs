defmodule Hitb.Stat.StatFileTest do
  use Hitb.DataCase

  alias Hitb.Stat.StatFile
  
  @valid_attrs %{first_menu: "sss", second_menu: "sss", file_name: "sss", page_type: "222", insert_user: "33333", update_user: "32222", header: "2222"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = StatFile.changeset(%StatFile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StatFile.changeset(%StatFile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
