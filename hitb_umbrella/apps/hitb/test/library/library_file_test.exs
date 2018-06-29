defmodule Hitb.Library.LibraryFileTest do
  use Hitb.DataCase

  alias Hitb.Library.LibraryFile
  @valid_attrs %{file_name: "sss", insert_user: "sss", update_user: "sss", header: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = LibraryFile.changeset(%LibraryFile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LibraryFile.changeset(%LibraryFile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
