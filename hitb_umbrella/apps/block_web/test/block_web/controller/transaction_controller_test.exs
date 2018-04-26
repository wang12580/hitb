defmodule BlockWeb.TransactionsControllerTest do
  use BlockWeb.ConnCase

  @valid_attrs %{}

  test "POST /getTransactions", %{conn: conn} do
    conn = get conn, "/api/getTransactions"
    assert json_response(conn, 200)["data"] != []
  end

  test "POST /getTransaction", %{conn: conn} do
    conn = get conn, "/api/getTransaction", id: "0"
    assert json_response(conn, 200)["data"] != []
  end

  test "POST /getUnconfirmedTransaction", %{conn: conn} do
    conn = get conn, "/api/unconfirmed/get"
    assert json_response(conn, 200) == %{}
  end
  test "POST /getUnconfirmedTransactions", %{conn: conn} do
    conn = get conn, "/api/unconfirmed"
    assert json_response(conn, 200) == %{}
  end
  test "POST /addTransactions", %{conn: conn} do
    conn = put conn, "/api/addTransactions", publicKey: "000", amount: "100", recipientId: "000", message: "000"
    assert json_response(conn, 200)["success"] == false
  end

  test "POST /getTransactionsByBlockHeight", %{conn: conn} do
    conn = get conn, "/api/getTransactionsByBlockHeight", height: 0
    assert json_response(conn, 200)["data"] != []
  end
  test "POST /getTransactionsByBlockHash", %{conn: conn} do
    conn = get conn, "/api/getTransactionsByBlockHash", hash: "1231123"
    assert json_response(conn, 200)["data"] == []
  end
  test "POST /getStorage", %{conn: conn} do
    conn = get conn, "/api/getStorage"
    assert json_response(conn, 200) == %{}
  end
  test "POST /putStorage", %{conn: conn} do
    conn = put conn, "/api/putStorage"
    assert json_response(conn, 200) == %{}
  end
end
