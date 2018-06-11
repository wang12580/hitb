defmodule Stat.ClientServiceTest do
  use Hitb.DataCase, async: true
  alias Stat.ClientService

  test "test stat_create" do
    assert ClientService.stat_create("sssss", "ssss").success == true
  end

  test "test stat_client" do
    assert ClientService.stat_client("1", "base", "org", "total", "", "", "", "org", "asc", "", 13, "server") == %{count: 0, drg_num: 0, list: [], num: 0, order: "org", order_type: "asc", org_num: 0, page: "1", page_list: [], page_type: "base", stat: [["机构", "时间", "总权重", "诊断相关组数", "费用消耗指数", "时间消耗指数", "CMI", "平均住院费用", "平均住院天数", "病历数"]], time_num: 0, tool: []}
  end

  test "test stat_file" do
    assert ClientService.stat_file("", "dzc", "server") == %{data: [nil], menu: "一级菜单"}
  end

end
