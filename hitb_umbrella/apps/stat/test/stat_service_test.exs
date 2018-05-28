defmodule Stat.StatServiceTest do
  use Hitb.DataCase, async: true
  alias Stat.StatService

  test "test stat_json" do
    assert StatService.stat_json("1", "base", "org", "total", "", "", "", "org", "asc", "") == %{order: "org", order_type: "asc", page_type: "base", stat: [["org", "time", "weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"], ["机构", "时间", "总权重", "诊断相关组数", "费用消耗指数", "时间消耗指数", "CMI", "平均住院费用", "平均住院天数", "病历数"]], list: [], page: "1", page_list: [], tool: []}
  end

  test "test download_stat" do
    assert StatService.download_stat("1", "base", "org", "total", "", "", "", "org", "asc", "") == "http://139.129.165.56/download/stat.csv"
  end

  test "test stat_info" do
    assert StatService.stat_info("org", "total", "", "base", "") == %{cnkey: ["机构", "时间", "总权重", "诊断相关组数","费用消耗指数", "时间消耗指数", "CMI","平均住院费用", "平均住院天数", "病历数"], key: ["org", "time", "weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"], stat: [], suggest: []}
  end

  test "test stat_info_chart" do
    assert StatService.stat_info_chart("org", "total", "", "base", "bar", "fee_index", "") == %{}
  end

  test "test stat_add" do
    assert StatService.stat_add(1, "org", "total", "", "", "", "org", "asc", "base", "") == true
  end
end
