defmodule Hitb.Edit.CdaFileTest do
  use Hitb.DataCase
  
  alias Hitb.Edit.CdaFile
  @valid_attrs %{username: "sss", filename: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = CdaFile.changeset(%CdaFile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CdaFile.changeset(%CdaFile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
