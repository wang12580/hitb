defmodule HitbserverWeb.StatCdaControllerTest do
  use HitbserverWeb.ConnCase

  test "POST /cda_consult", %{conn: conn} do
    conn = post conn, "/stat/cda_consult", item: ""
    assert json_response(conn, 200) == %{"cda" => []}
  end
end
