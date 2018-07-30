defmodule Library.RuleServiceTest do
  use Hitb.DataCase, async: true
  alias Library.RuleService

  test "test rule" do
    assert RuleService.rule(1, "year", "mdc", "BJ", "", "", 15) == %{dissect: "", page_list: [], page_num: 1, result: [], tab_type: "mdc", type: "year", version: "BJ", year: "", list: %{org: ["全部"], time: ["全部"], version: ["全部"]}}
  end

  test "test rule_file" do
    assert RuleService.rule_file('server') == []
  end

  test "test rule_client" do
    assert RuleService.rule_client(1, "year", "mdc", "BJ", "", "", 1, "server", "asc", "code") == %{count: 0, library: [], list: %{org: ["全部"], time: ["全部"], version: ["全部"]}, page: 1, page_list: [], sort_type: "asc", sort_value: "code"}
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
  test "test clinet" do
    assert RuleService.clinet(1, "year", "mdc", "BJ", "", "", 15, "server", "asc", "code") == [[], %{org: ["全部"], time: ["全部"], version: ["全部"]}, 0, [], 1]
  end


end
