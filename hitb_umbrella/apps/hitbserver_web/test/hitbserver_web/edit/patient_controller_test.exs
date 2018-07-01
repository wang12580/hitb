
defmodule HitbserverWeb.PatinetControllerTest do
  use HitbserverWeb.ConnCase

  test "POST /patientlist", %{conn: conn} do
    conn = post conn, "/edit/patientlist/", info: %{"a" =>"a", "b"=>"n"}, username: "username"
    assert json_response(conn, 200)["success"] == true
  end

end
