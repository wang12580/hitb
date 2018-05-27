defmodule Stat.ContrastServiceTest do
  use Hitb.DataCase, async: true
  alias Stat.ContrastService

  test "test contrast" do
    assert ContrastService.contrast("1", "base", "org", "total", "", "", "", "org", "asc", "") == %{cnkey: ["机构", "时间", "总权重", "诊断相关组数", "费用消耗指数", "时间消耗指数", "CMI", "平均住院费用", "平均住院天数", "病历数"], key: ["org", "time", "weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"], order: "org", order_type: "asc", page_type: "base", stat: [["机构", "时间", "总权重", "诊断相关组数", "费用消耗指数", "时间消耗指数", "CMI", "平均住院费用", "平均住院天数", "病历数"]], url: "page=1&type=org&org=&time=&drg=&order=org&page_type=base&order_type=asc"}
  end

  test "test contrast_operate" do
    assert ContrastService.contrast_operate("1", "base", "org", "total", "", "", "", "org", "asc", "", "add_x", "萨达所").result == true
  end

  test "test contrast_list" do
    assert ContrastService.contrast_list("1", "org", "total", "", "", "", "", "org", "asc", "base") == []
  end

  test "test contrast_chart" do
    assert ContrastService.contrast_chart("pie", "", "fee_index", "org", "", "", "base") == %{}
  end

  test "test contrast_info" do
    # assert ContrastService.contrast_info("") == %{x: [], y: []}
  end

  test "test contrast_clear" do
    assert ContrastService.contrast_clear("") == true
  end

end
