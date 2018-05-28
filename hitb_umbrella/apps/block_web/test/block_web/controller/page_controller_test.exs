defmodule BlockWeb.PageControllerTest do
  use BlockWeb.ConnCase

  # @valid_attrs %{}

  test "POST /status", %{conn: conn} do
    conn = get conn, "/api/status"
    assert json_response(conn, 200) == %{}
  end
  # test "POST /statusSync", %{conn: conn} do
  #   conn = get conn, "/api/statusSync"
  #   assert json_response(conn, 200) == %{}
  # end
  # test "POST /systemInfo", %{conn: conn} do
  #   conn = get conn, "/api/systemInfo"
  #   assert json_response(conn, 200) == %{}
  # end
end
