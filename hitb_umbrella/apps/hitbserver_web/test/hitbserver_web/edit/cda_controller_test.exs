defmodule HitbserverWeb.CdaControllerTest do
  use HitbserverWeb.ConnCase
  alias Hitb.Edit.Cda
  alias Hitb.Repo
  @valid_attrs %Cda{content: "sss", name: "sss", username: "sss", is_show: false, is_change: false}

  # test "GET /cda_user", %{conn: conn} do
  #   conn = get conn, "/edit/cda_user/?server_type='server'"
  #   assert json_response(conn, 200)["info"] == "读取成功"
  # end
  test "GET /cda_file", %{conn: conn} do
    conn = get conn, "/edit/cda_file/?username='server'＆server_type"
    assert json_response(conn, 200)["info"] == "读取成功"
  end

  test "GET /cda", %{conn: conn} do
    conn = get conn, "/edit/cda?filename='sss'&username='sss'"
    assert json_response(conn, 200)["info"] == ["文件读取失败,无此文件"]
  end
  test "POST /cda", %{conn: conn} do
    cda = Repo.insert!(@valid_attrs)
    conn = post conn, "/edit/cda", id: cda.id, content: "content", file_name: "file_name", username: "username", doctype: "doctype", mouldtype: "mouldtype", header: %{"a" =>"a", "b"=>"n"}, save_type: "更新"
    assert json_response(conn, 200)["info"] == "保存成功"
  end

end
