defmodule BlockWeb.AccountControllerTest do
  use BlockWeb.ConnCase

  # @valid_attrs %{}

  test "POST /open", %{conn: conn} do
    conn = post conn, "/api/open"
    assert json_response(conn, 200)["login"] == false
  end
  test "POST /open2", %{conn: conn} do
    conn = post conn, "/api/open2"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getBalance", %{conn: conn} do
    conn = get conn, "/api/getBalance"
    assert json_response(conn, 200)["balance"] == 0
  end
  test "POST /getPublicKey", %{conn: conn} do
    conn = get conn, "/api/getPublicKey"
    assert json_response(conn, 200)["publicKey"] == ""
  end
  test "POST /generatePublicKey", %{conn: conn} do
    conn = post conn, "/api/generatePublicKey", username: "sss"
    # IO.inspect assert json_response(conn, 200)
    assert json_response(conn, 200)["publicKey"] == "4jjQ6wx7Ezrosa1G5dzdkJWazSnjQWwIWYCgTEjPoM"
  end
  test "POST /delegates", %{conn: conn} do
    conn = get conn, "/api/delegates/fee"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getDelegateFee", %{conn: conn} do
    conn = put conn, "/api/delegates"
    assert json_response(conn, 200) == %{}
  end
  # test "POST /account", %{conn: conn} do
  #   conn = get conn, "/api/account", username: "sss"
  #   assert json_response(conn, 200)["account"] !=  nil
  # end
  # test "POST /getAccountByPublicKey", %{conn: conn} do
  #   conn = get conn, "/api/getAccountByPublicKey", publicKey: "1222222"
  #   assert json_response(conn, 200)["account"] == []
  # end
  # test "POST /getAccountByAddress", %{conn: conn} do
  #   conn = get conn, "/api/getAccountByAddress", address: "1222222"
  #   assert json_response(conn, 200)["account"] == []
  # end
  # test "POST /newAccount", %{conn: conn} do
  #   conn = get conn, "/api/newAccount", username: "sss"
  #   assert json_response(conn, 200) != nil
  # end
  # test "POST /addSignature", %{conn: conn} do
  #   conn = put conn, "/api/addSignature", username: "sss", password: "123456"
  #   assert json_response(conn, 200)['success'] == false
  # end
  # test "POST /getAccountsPublicKey", %{conn: conn} do
  #   conn = get conn, "/api/getAccountsPublicKey"
  #   assert json_response(conn, 200)['success'] == false
  # end

  # test "POST /open2", %{conn: conn} do
  #   Server.Repo.insert!(Map.merge(%Server.Record{}, @valid_attrs))
  #   record = Server.Repo.get_by(Server.Record, mode: @valid_attrs.mode)
  #   conn = get conn, record_path(conn, :show, record.id)
  #   assert json_response(conn, 200)["data"] != nil
  # end
end
