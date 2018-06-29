defmodule HitbserverWeb.HelpControllerTest do
  use HitbserverWeb.ConnCase

  test "GET /helpinsert", %{conn: conn} do
    conn = get conn, "/edit/helpinsert/?name='222222222'&content='2222222'"
    assert json_response(conn, 200)["success"] == true
  end
  test "GET /help_list", %{conn: conn} do
    conn = get conn, "/edit/helplist"
    assert json_response(conn, 200)["success"] == true
  end

end
