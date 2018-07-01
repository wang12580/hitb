defmodule HitbserverWeb.PageControllerTest do
  use HitbserverWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302) =~ " <a href=\"/hospitals/login\">"
  end
end
