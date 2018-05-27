defmodule Stat.ChartTest do
  use Hitb.DataCase, async: true
  alias Stat.Chart

  @stat [%{day_avg: 3.3537, day_index: 1.0, org: "测试医院1", time: "2016年10月"}, %{day_avg: 3.4386, day_index: 2.0, org: "测试医院1", time: "2016年8月"}]

  test "test radar chart" do
    assert Chart.chart(@stat, "radar") == %{chart_key: ["测试医院1 2016年10月", "测试医院1 2016年8月"], data: [ %{name: "测试医院1 2016年10月", value: [3.3537, 1.0]}, %{name: "测试医院1 2016年8月", value: [3.4386, 2.0]} ], indicator: [%{max: 3.4386, name: "平均住院天数"}, %{max: 2.0, name: "时间消耗指数"}]}
  end

  test "test bar chart" do
    assert Chart.chart(@stat, "bar") == %{chart_key: ["测试医院1 2016年10月", "测试医院1 2016年8月"], series: [%{data: [3.3537, 1.0], name: "测试医院1 2016年10月", type: "bar"}, %{data: [3.4386, 2.0], name: "测试医院1 2016年8月", type: "bar"}], xAxis: %{data: ["平均住院天数", "时间消耗指数"], type: "category"}}
  end

  test "test scatter chart" do
    assert Chart.chart(@stat, "scatter") == %{data: [[3.3537, 1.0], [3.4386, 2.0]], xSeries: 3.3537, xkey: "平均住院天数", ySeries: 1.0, ykey: "时间消耗指数"}
  end

  test "test pie chart" do
    assert Chart.chart(@stat, "pie") == %{data: ["测试医院1 2016年10月", "测试医院1 2016年8月"], name: "平均住院天数", series: [%{name: "测试医院1 2016年10月", value: 3.3537}, %{name: "测试医院1 2016年8月", value: 3.4386}]}
  end

end
