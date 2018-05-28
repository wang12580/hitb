# defmodule HitbserverWeb.StatControllerTest do
#   use HitbserverWeb.ConnCase
#
#   test "GET /stat/stat_json", %{conn: conn} do
#     conn = get conn, "/stat/stat_json", username: "sss"
#     assert json_response(conn, 200)["order"] == "org"
#   end
#   test "GET /stat/stat_info_chart", %{conn: conn} do
#     conn = get conn, "/stat/stat_info_chart", chart_type: "pie", username: "hitb"
#     assert json_response(conn, 200) == %{}
#   end
#   test "GET /stat/contrast", %{conn: conn} do
#     conn = get conn, "/stat/contrast", username: "sss"
#     assert json_response(conn, 200)["cnkey"] == ["机构", "时间", "总权重", "诊断相关组数", "费用消耗指数", "时间消耗指数", "CMI", "平均住院费用", "平均住院天数", "病历数"]
#   end
#   test "POST /stat/contrast", %{conn: conn} do
#     conn = post conn, "/stat/contrast", username: "username", field: "", url: [], com_type: "add_x"
#     assert json_response(conn, 200)["result"] == true
#   end
#   test "GET /stat/contrast_list", %{conn: conn} do
#     conn = get conn, "/stat/contrast_list", username: "sss"
#     assert json_response(conn, 200)["list"] == []
#   end
#   test "GET /stat/contrast_chart", %{conn: conn} do
#     conn = get conn, "/stat/contrast_chart", chart_type: "pie", username: "sss"
#     assert json_response(conn, 200) == %{}
#   end
#   test "GET /stat/contrast_info", %{conn: conn} do
#     conn = get conn, "/stat/contrast_info", username: "sss"
#     assert json_response(conn, 200)["x"] == []
#   end
#   test "GET /stat/download_stat", %{conn: conn} do
#     conn = get conn, "/stat/download_stat", username: "sss"
#     assert json_response(conn, 200)["path"] == "http://139.129.165.56/download/stat.csv"
#   end
#   test "GET /stat/stat_info", %{conn: conn} do
#     conn = get conn, "/stat/stat_info", username: "sss"
#     # IO.inspect assert json_response(conn, 200)
#     assert json_response(conn, 200)["stat"] == []
#   end
#   # test "POST /stat/com_add", %{conn: conn} do
#   #   conn = post conn, "/stat/com_add", url: ["org", "", "", "", ""], username: "sss"
#   #   # "type=&tool_type=&org=&time=&drg=", username: "sss"
#   #   IO.inspect assert json_response(conn, 200)
#   #   assert json_response(conn, 200)["result"] == true
#   # end
#
#   # test "GET /stat/contrast_clear", %{conn: conn} do
#   #   conn = get conn, "/stat/contrast_clear", username: "sss"
#   #   # IO.inspect assert json_response(conn, 200)
#   # #   assert json_response(conn, 200)["result"] == true
#   # end
# end
