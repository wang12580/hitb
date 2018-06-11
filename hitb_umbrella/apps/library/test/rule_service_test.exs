defmodule Library.RuleServiceTest do
  use Hitb.DataCase, async: true
  alias Library.RuleService

  test "test rule" do
    assert RuleService.rule(1, "year", "mdc", "BJ", "", "", 15) == %{dissect: "", list: [], page_list: [], page_num: 1, result: [], tab_type: "mdc", type: :year, version: "BJ", year: ""}
  end

  test "test rule_file" do
    assert RuleService.rule_file('server') == []
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
