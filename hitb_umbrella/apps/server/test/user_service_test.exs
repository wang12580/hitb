defmodule Server.UserServiceTest do
  use Hitb.DataCase, async: true
  alias Server.UserService
  alias Hitb.Repo
  alias Hitb.Server.User

  @user %{"age" => 1, "email" => "2018@test.com.cn", "password" => "sss", "name" => "sss", "org" => "sss", "tel" => "sss", "username" => "sss", "type" => 1, "key" => ["ss"], "is_show" => true}

  test "test list_user" do
    assert UserService.list_user(1, 15)|>List.first != 0
  end

  # test "test create_user" do
  #   {:error, user} = UserService.create_user(@user)
  #   assert user.changes.username == @user["username"]
  # end

  test "test get_user!" do
    {:error, changeset} = UserService.create_user(@user)
    {:ok, user} = Repo.insert(changeset)
    assert UserService.get_user!(user.id).age == @user["age"]
  end

  test "test delete_user" do
    {:error, changeset} = UserService.create_user(@user)
    {:ok, user} = Repo.insert(changeset)
    UserService.delete_user(user.id)
    assert UserService.list_user(1, 15)|>List.first == 1
  end

end
