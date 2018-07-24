defmodule HitbserverWeb.CompControllerTest do
  use HitbserverWeb.ConnCase

  test "GET /stat/target1", %{conn: conn} do
    conn = get conn, "/stat/target1", username: "123@hitb.com"
    assert json_response(conn, 200)["list"] == [nil]
    #   ["机构分析_基础分析", "机构绩效_机构效率", "机构绩效_机构工作量", "机构绩效_机构绩效", "财务指标_机构收入", "财务指标_医保控费",
    #  "医疗质量_重返率", "医疗质量_治愈效果",
    #  "医疗质量_手术质量", "医疗质量_负性事件",
    #  "统计分析_病案统计", "统计分析_输血统计",
    #  "统计分析_肿瘤统计", "统计分析_新生儿统计",
    #  "统计分析_手术统计"]
  end
  test "GET /stat/target", %{conn: conn} do
    conn = get conn, "/stat/target", file: "机构分析_基础分析"
    assert json_response(conn, 200)["dimension"] == ["时间", "机构", "病种"]
  end
end
