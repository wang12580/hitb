# defmodule HitbserverWeb.RecordControllerTest do
#   use HitbserverWeb.ConnCase
#
#   alias Hitb.Repo
#   alias Hitb.Server.Record
#
#   @valid_attrs %{mode: "0000", type: "123456", username: "77", old_value: "77", value: "true"}
#
#   test "POST /create", %{conn: conn} do
#     conn = post conn, record_path(conn, :create), record: @valid_attrs
#     assert json_response(conn, 201)["data"] != nil
#   end
#   test "POST /show", %{conn: conn} do
#     Repo.insert!(Map.merge(%Record{}, @valid_attrs))
#     record = Repo.get_by(Record, mode: @valid_attrs.mode)
#     conn = get conn, record_path(conn, :show, record.id)
#     assert json_response(conn, 200)["data"] != nil
#   end
#   # test "POST /update", %{conn: conn} do
#   #   Repo.insert!(Map.merge(%Server.CustomizeDepartment{}, @valid_attrs))
#   #   customizeDepartment = Repo.get_by(Server.CustomizeDepartment, wt_code: @valid_attrs.wt_code)
#   #   conn = get conn, customize_department_path(conn, :update, customizeDepartment.id, @valid_attrs)
#   #   assert json_response(conn, 200)["data"] != nil
#   # end
#   test "POST /delete", %{conn: conn} do
#     Repo.insert!(Map.merge(%Record{}, @valid_attrs))
#     record = Repo.get_by(Record, mode: @valid_attrs.mode)
#     conn = get conn, record_path(conn, :delete, record.id)
#     assert json_response(conn, 200)["data"] != nil
#   end
# end
