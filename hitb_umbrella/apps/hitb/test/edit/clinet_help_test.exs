defmodule Hitb.Edit.ClinetHelpTest do
  use Hitb.DataCase

  alias Hitb.Edit.ClinetHelp
  @valid_attrs %{content: "sss", name: "sss"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = ClinetHelp.changeset(%ClinetHelp{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ClinetHelp.changeset(%ClinetHelp{}, @invalid_attrs)
    refute changeset.valid?
  end
end
