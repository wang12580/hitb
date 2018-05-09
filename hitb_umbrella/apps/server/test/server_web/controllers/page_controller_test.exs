defmodule ServerWeb.PageControllerTest do
  use ServerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/servers"
    assert html_response(conn, 200) =~ "Server!"
  end
end
