defmodule Library.RuleServiceTest do
  use Hitb.DataCase, async: true
  alias Library.RuleService

  test "test rule" do
    assert RuleService.rule(1, "year", "mdc", "BJ", "", "", 15) == %{dissect: "", list: [], page_list: [], page_num: 1, result: [], tab_type: "mdc", type: :year, version: "BJ", year: ""}
  end

  test "test rule_file" do
    assert RuleService.rule_file('server') == ["mdc.csv", "adrg.csv", "drg.csv", "icd9.csv", "icd10.csv", "基本信息.csv", "街道乡镇代码.csv", "民族.csv", "区县编码.csv", "手术血型.csv", "出入院编码.csv", "肿瘤编码.csv", "科别代码.csv", "病理诊断编码.csv", "医保诊断依据.csv", "中药.csv", "中成药.csv"]
  end

  test "test rule_client" do
    assert RuleService.rule_client(1, "year", "mdc", "BJ", "", "", 1, "server") == %{count: 0, library: [], list: [], page: 1, page_list: []}
  end

  test "test contrast" do
    assert RuleService.contrast("icd9", "123-456") == %{contrast: [], result: [], table: "icd9"}
  end

  test "test details" do
    assert RuleService.details("MDCA", "mdc", "BJ") == %{result: [], table: "mdc", result1: nil}
  end

  test "test search" do
    assert RuleService.search(1, "mdc", "MDCA") == %{table: [], page_list: [], page_num: 1}
  end

end
