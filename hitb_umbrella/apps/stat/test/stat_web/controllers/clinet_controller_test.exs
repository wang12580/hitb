defmodule StatWeb.ClinetControllerTest do
  use StatWeb.ConnCase

  test "POST /stat/stat_create", %{conn: conn} do
    conn = post conn, "/stat/stat_create", data: "sss", username: "username"
    assert json_response(conn, 200)["success"] == true
  end

  test "GET /stat/stat_client", %{conn: conn} do
    conn = get conn, "/stat/stat_client"
    assert json_response(conn, 200)["count"] == 0
  end
  test "GET /stat/stat_file", %{conn: conn} do
    conn = get conn, "/stat/stat_file", username: 'sss'
    assert json_response(conn, 200)["menu"] == "一级菜单"
  end

end
