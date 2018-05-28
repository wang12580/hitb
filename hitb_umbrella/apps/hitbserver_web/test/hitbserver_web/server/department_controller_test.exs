# defmodule HitbserverWeb.DepartmentControllerTest do
#   use HitbserverWeb.ConnCase
#   alias Hitb.Repo
#   alias Hitb.Server.Department
#
#   @valid_attrs %{class_code: "0000", class_name: "123456", department_code: "77", department_name: "77"}
#
#   test "POST /create", %{conn: conn} do
#     conn = post conn, department_path(conn, :create), department: @valid_attrs
#     assert json_response(conn, 201)["data"] != nil
#   end
#   test "POST /show", %{conn: conn} do
#     Repo.insert!(Map.merge(%Department{}, @valid_attrs))
#     department = Repo.get_by(Department, class_code: @valid_attrs.class_code)
#     conn = get conn, department_path(conn, :show, department.id)
#     assert json_response(conn, 200)["data"] != nil
#   end
#   test "POST /update", %{conn: conn} do
#     Repo.insert!(Map.merge(%Department{}, @valid_attrs))
#     department = Repo.get_by(Department, class_code: @valid_attrs.class_code)
#     conn = get conn, department_path(conn, :update, department.id, @valid_attrs)
#     assert json_response(conn, 200)["data"] != nil
#   end
#   test "POST /delete", %{conn: conn} do
#     Repo.insert!(Map.merge(%Department{}, @valid_attrs))
#     department = Repo.get_by(Department, class_code: @valid_attrs.class_code)
#     conn = get conn, department_path(conn, :delete, department.id)
#     assert json_response(conn, 200)["data"] != nil
#   end
# end
