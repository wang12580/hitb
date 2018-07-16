defmodule Stat.ClientSaveServiceTest do
  use Hitb.DataCase, async: true
  alias Stat.ClientSaveService

  test "test stat_create" do
    assert ClientSaveService.stat_create("sssss", "ssss").success == true
  end

  test "test stat_client" do
    assert ClientSaveService.stat_client("1", "base", "org", "total", "", "", "", "org", "asc", "", 13, "server") == %{count: 0, drg_num: 2, num: 0, order: "org", order_type: "asc", org_num: 1, page: "1", page_list: [], page_type: "base", server_type: "server", stat: [["机构", "时间", "总权重", "诊断相关组数", "费用消耗指数", "时间消耗指数", "CMI", "平均住院费用", "平均住院天数", "病历数"]], time_num: 1, tool: [], type: "org", list: %{drg: ["-", "全部"], org: ["全部"], adrg: ["-", "全部"], department: ["全部"], half_year: ["全部"], mdc: ["-", "全部"], month_time: ["全部"], season_time: ["全部"], year_time: ["全部"]}}

  end

  test "test stat_file" do
    assert ClientSaveService.stat_file("", "dzc", "server") == %{data: [nil], menu: "一级菜单"}
  end

end
