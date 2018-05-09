defmodule StatWeb.PageControllerTest do
  use StatWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/stat"
    assert html_response(conn, 200) =~ "Stat"
  end
end
