# defmodule HitbserverWeb.Wt4ControllerTest do
#   use HitbserverWeb.ConnCase
#
#
#   test "GET /wt4", %{conn: conn} do
#     conn = get conn, "/library/wt4/"
#     assert json_response(conn, 200)["data"] == []
#   end
#
#   test "GET /stat_wt4", %{conn: conn} do
#     conn = get conn, "/library/stat_wt4?time=&org=&drg="
#     assert json_response(conn, 200)["wt4"] == [["病案ID", "主要诊断", "其他诊断", "手术/操作", "住院天数", "病种", "费用", "性别", "年龄"]]
#   end
#
#
# end
