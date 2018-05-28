defmodule HitbserverWeb.ChatRecordControllerTest do
  use HitbserverWeb.ConnCase

  alias Hitb.Server.ChatRecord
  alias Hitb.Repo
  @valid_attrs %{date: "some date", record_string: "some record_string", room: "some room", record_array: ["Ssss"]}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chat_record_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end
  
  test "shows chosen resource", %{conn: conn} do
    chat_record = Repo.insert! %ChatRecord{}
    conn = get conn, chat_record_path(conn, :show, chat_record)
    assert json_response(conn, 200)["data"] == %{"id" => chat_record.id,
      "room" => chat_record.room,
      "date" => chat_record.date,
      "record_string" => chat_record.record_string}
  end
  
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, chat_record_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, chat_record_path(conn, :create), chat_record: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ChatRecord, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chat_record_path(conn, :create), chat_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
  
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    chat_record = Repo.insert! %ChatRecord{}
    conn = put conn, chat_record_path(conn, :update, chat_record), chat_record: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ChatRecord, @valid_attrs)
  end
  
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chat_record = Repo.insert! %ChatRecord{}
    conn = put conn, chat_record_path(conn, :update, chat_record), chat_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
  
  test "deletes chosen resource", %{conn: conn} do
    chat_record = Repo.insert! %ChatRecord{}
    conn = delete conn, chat_record_path(conn, :delete, chat_record)
    assert response(conn, 204)
    refute Repo.get(ChatRecord, chat_record.id)
  end
end
