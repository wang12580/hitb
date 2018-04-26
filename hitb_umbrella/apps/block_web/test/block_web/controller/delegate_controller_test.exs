defmodule BlockWeb.DelegateControllerTest do
  use BlockWeb.ConnCase

  @valid_attrs %{}

  test "POST /count", %{conn: conn} do
    conn = get conn, "/api/count"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getVoters", %{conn: conn} do
    conn = get conn, "/api/getVoters"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getDelegate", %{conn: conn} do
    conn = get conn, "/api/getDelegate"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getDelegates", %{conn: conn} do
    conn = get conn, "/api/getDelegates"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getDelegateFee", %{conn: conn} do
    conn = get conn, "/api/getDelegateFee"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getForgedByAccount", %{conn: conn} do
    conn = get conn, "/api/forging/getForgedByAccount"
    assert json_response(conn, 200) == %{}
  end
  test "POST /addDelegate", %{conn: conn} do
    conn = put conn, "/api/addDelegate"
    assert json_response(conn, 200) == %{}
  end
end
