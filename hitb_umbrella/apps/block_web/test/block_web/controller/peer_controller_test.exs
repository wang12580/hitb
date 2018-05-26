defmodule BlockWeb.PeerControllerTest do
  use BlockWeb.ConnCase

  # @valid_attrs %{}

  # test "POST /peer", %{conn: conn} do
  #   conn = post conn, "/api/peer", peer_data: %{ host: "127.0.0.1", port: "4000" }
  #   assert json_response(conn, 200)["result"] == ["127.0.0.1:4000节点连接成功"]
  # end
  # test "POST /peers", %{conn: conn} do
  #   conn = get conn, "/api/peers"
  #   assert json_response(conn, 200)["peers"] != []
  # end
  test "POST /getPeers", %{conn: conn} do
    conn = get conn, "/api/getPeers"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getPeer", %{conn: conn} do
    conn = get conn, "/api/getPeer"
    assert json_response(conn, 200) == %{}
  end

  test "POST /version", %{conn: conn} do
    conn = get conn, "/api/peerVersion"
    assert json_response(conn, 200) == %{}
  end
end
