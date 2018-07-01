
defmodule HitbserverWeb.MouldControllerTest do
  use HitbserverWeb.ConnCase

  test "GET /mould_list", %{conn: conn} do
    conn = get conn, "/edit/mouldlist/?username='222222222'"
    assert json_response(conn, 200)["success"] == true
  end
  test "GET /mould_file", %{conn: conn} do
    conn = get conn, "/edit/mouldfile/?username='222222222'&name='22222'"
    assert json_response(conn, 200)["success"] == true
  end
  test "GET /help_file", %{conn: conn} do
    conn = get conn, "/edit/helpfile/?name='222222222'"
    assert json_response(conn, 200)["success"] == true
  end

end
