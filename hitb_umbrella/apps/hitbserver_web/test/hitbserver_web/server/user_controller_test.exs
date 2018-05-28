defmodule HitbserverWeb.UserControllerTest do
  use HitbserverWeb.ConnCase

  alias Hitb.Repo
  alias Hitb.Server.User

  @valid_attrs %{username: "hitb", password: "123456", tel: "77", org: "77", name: "777", email: "77", age: 777}

  test "POST /servers/login", %{conn: conn} do
    conn = post conn, "/servers/login", user: %{username: "hitb", password: "123456" }
    assert json_response(conn, 200)["login"] == false
  end
  test "POST /create", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{username: "hitb", password: "123456", tel: "77", org: "77", name: "777", email: "77", age: "777"}
    assert json_response(conn, 201)["success"] == true
  end
  test "POST /show", %{conn: conn} do
    Repo.insert!(Map.merge(%User{}, @valid_attrs))
    user = Repo.get_by(User, username: @valid_attrs.username)
    conn = get conn, user_path(conn, :show, user.id)
    assert json_response(conn, 200)["success"] == true
  end
  test "POST /update", %{conn: conn} do
    Repo.insert!(Map.merge(%User{}, @valid_attrs))
    user = Repo.get_by(User, username: @valid_attrs.username)
    conn = get conn, user_path(conn, :update, user.id, @valid_attrs)
    assert json_response(conn, 200)["success"] == true
  end
  test "POST /delete", %{conn: conn} do
    Repo.insert!(Map.merge(%User{}, @valid_attrs))
    user = Repo.get_by(User, username: @valid_attrs.username)
    conn = get conn, user_path(conn, :delete, user.id)
    assert json_response(conn, 200)["success"] == true
  end
end
