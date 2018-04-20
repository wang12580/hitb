defmodule Edit.ClientTest do
  use Edit.DataCase

  alias Edit.Client

  describe "cda" do
    alias Edit.Client.Cda

    @valid_attrs %{content: "some content", name: "some name", username: "some username"}
    @update_attrs %{content: "some updated content", name: "some updated name", username: "some updated username"}
    @invalid_attrs %{content: nil, name: nil, username: nil}

    def cda_fixture(attrs \\ %{}) do
      {:ok, cda} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Client.create_cda()

      cda
    end

    test "list_cda/0 returns all cda" do
      cda = cda_fixture()
      assert Client.list_cda() == [cda]
    end

    test "get_cda!/1 returns the cda with given id" do
      cda = cda_fixture()
      assert Client.get_cda!(cda.id) == cda
    end

    test "create_cda/1 with valid data creates a cda" do
      assert {:ok, %Cda{} = cda} = Client.create_cda(@valid_attrs)
      assert cda.content == "some content"
      assert cda.name == "some name"
      assert cda.username == "some username"
    end

    test "create_cda/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Client.create_cda(@invalid_attrs)
    end

    test "update_cda/2 with valid data updates the cda" do
      cda = cda_fixture()
      assert {:ok, cda} = Client.update_cda(cda, @update_attrs)
      assert %Cda{} = cda
      assert cda.content == "some updated content"
      assert cda.name == "some updated name"
      assert cda.username == "some updated username"
    end

    test "update_cda/2 with invalid data returns error changeset" do
      cda = cda_fixture()
      assert {:error, %Ecto.Changeset{}} = Client.update_cda(cda, @invalid_attrs)
      assert cda == Client.get_cda!(cda.id)
    end

    test "delete_cda/1 deletes the cda" do
      cda = cda_fixture()
      assert {:ok, %Cda{}} = Client.delete_cda(cda)
      assert_raise Ecto.NoResultsError, fn -> Client.get_cda!(cda.id) end
    end

    test "change_cda/1 returns a cda changeset" do
      cda = cda_fixture()
      assert %Ecto.Changeset{} = Client.change_cda(cda)
    end
  end
end
