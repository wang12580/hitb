# defmodule HitbserverWeb.OrgControllerTest do
#   use HitbserverWeb.ConnCase
#
#   alias Hitb.Repo
#   alias Hitb.Server.Org
#
#   @valid_attrs %{county: "0000", city: "123456", code: "77", name: "77", email: "222", is_show: true, is_ban: true, level: "0000", person_name: "0000", province: "000", tel: "000", type: "000", stat_org_name: 1}
#
#   test "POST /create", %{conn: conn} do
#     conn = post conn, org_path(conn, :create), org: @valid_attrs
#     assert json_response(conn, 201)["success"] == true
#   end
#   test "POST /show", %{conn: conn} do
#     Repo.insert!(Map.merge(%Org{}, @valid_attrs))
#     org = Repo.get_by(Org, city: @valid_attrs.city)
#     conn = get conn, org_path(conn, :show, org.id)
#     assert json_response(conn, 200)["success"] == true
#   end
#   test "POST /update", %{conn: conn} do
#     Repo.insert!(Map.merge(%Org{}, @valid_attrs))
#     org = Repo.get_by(Org, city: @valid_attrs.city)
#     conn = get conn, org_path(conn, :update, org.id, @valid_attrs)
#     assert json_response(conn, 200)["success"] == true
#   end
#   test "POST /delete", %{conn: conn} do
#     Repo.insert!(Map.merge(%Org{}, @valid_attrs))
#     org = Repo.get_by(Org, city: @valid_attrs.city)
#     conn = get conn, org_path(conn, :delete, org.id)
#     assert json_response(conn, 200)["success"] == true
#   end
# end
