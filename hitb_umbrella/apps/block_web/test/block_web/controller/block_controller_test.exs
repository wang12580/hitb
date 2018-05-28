defmodule BlockWeb.BlockControllerTest do
  use BlockWeb.ConnCase

  # @valid_attrs %{}

  # test "POST /blocks", %{conn: conn} do
  #   conn = get conn, "/block/api/blocks"
  #   assert json_response(conn, 200)["blocks"] != []
  # end
  # test "GET /getBlock", %{conn: conn} do
  #   conn = get conn, "/block/api/getBlock", index: "0"
  #   assert json_response(conn, 200)["blocks"] != []
  # end

  # test "POST /getBlockByHash", %{conn: conn} do
  #   conn = get conn, "/block/api/getBlockByHash", hash: "sssss"
  #   assert json_response(conn, 200)["blocks"] != []
  # end
  test "POST /getFullBlock", %{conn: conn} do
    conn = get conn, "/block/api/getFullBlock"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getBlocks", %{conn: conn} do
    conn = get conn, "/block/api/getBlocks"
    assert json_response(conn, 200) == %{}
  end
  # test "POST /getHeight", %{conn: conn} do
  #   conn = get conn, "/block/api/getHeight"
  #   assert json_response(conn, 200)["height"] == 0
  # end
  test "POST /getFee", %{conn: conn} do
      conn = get conn, "/block/api/getFee"
    # IO.inspect assert json_response(conn, 200)
    assert json_response(conn, 200) == %{}
  end
  test "POST /getMilestone", %{conn: conn} do
      conn = get conn, "/block/api/getMilestone"
    # IO.inspect assert json_response(conn, 200)
    assert json_response(conn, 200) == %{}
  end

  test "POST /getReward", %{conn: conn} do
      conn = get conn, "/block/api/getReward"
    # IO.inspect assert json_response(conn, 200)
    assert json_response(conn, 200) == %{}
  end

  test "POST /getSupply", %{conn: conn} do
      conn = get conn, "/block/api/getSupply"
    # IO.inspect assert json_response(conn, 200)
    assert json_response(conn, 200) == %{}
  end

  test "POST /getStatus", %{conn: conn} do
      conn = get conn, "/block/api/getStatus"
    # IO.inspect assert json_response(conn, 200)
    assert json_response(conn, 200) == %{}
  end

end
