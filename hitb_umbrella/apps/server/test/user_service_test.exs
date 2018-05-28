defmodule Server.UserServiceTest do
  use Hitb.DataCase, async: true
  alias Server.UserService

  @user %{"age" => 1, "email" => "2018", "password" => "sss", "name" => "sss", "org" => "sss", "tel" => "sss", "username" => "sss", "type" => 1, "key" => ["ss"], "is_show" => true}

  test "test list_user" do
    assert UserService.list_user(1, 15) == [0, []]
  end

  test "test create_user" do
    {:ok, user} = UserService.create_user(@user)
    assert user.id
  end

  test "test get_user!" do
    {:ok, user} = UserService.create_user(@user)
    assert UserService.get_user!(user.id).age == @user["age"]
  end

  test "test delete_user" do
    {:ok, user} = UserService.create_user(@user)
    UserService.delete_user(user.id)
    assert UserService.list_user(1, 15) == [0, []]
  end

end
