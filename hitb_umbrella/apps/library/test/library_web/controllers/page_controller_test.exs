defmodule LibraryWeb.PageControllerTest do
  use LibraryWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/library/"
    assert html_response(conn, 200) =~ "Hello Library!"
  end

  test "GET /rule", %{conn: conn} do
    conn = get conn, "/library/rule/"
    assert json_response(conn, 200)["version"] == "BJ"
    assert json_response(conn, 200)["type"] == "year"
  end

  test "GET /rule_file", %{conn: conn} do
    conn = get conn, "/library/rule_file/"
    assert json_response(conn, 200)["data"] != []
  end

  test "GET /rule_client", %{conn: conn} do
    conn = get conn, "/library/rule_client/"
    assert json_response(conn, 200)["data"] != []
  end

  test "GET /contrast", %{conn: conn} do
    conn = get conn, "/library/contrast?table=mdc&id=1"
    assert json_response(conn, 200)["table"] == "mdc"
  end

  test "GET /details", %{conn: conn} do
    conn = get conn, "/library/details?code=A&table=mdc&version=BJ"
    assert json_response(conn, 200)["table"] == "mdc"
  end

  test "GET /search", %{conn: conn} do
    conn = get conn, "/library/search?table=mdc&code=A"
    assert json_response(conn, 200)["table"] == []
  end


end
