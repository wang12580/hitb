defmodule Block.LibraryServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.LibraryService
  # @cda_file %{username: "sss", filename: "sss", hash: "ssss", previous_hash: "ssss"}
  # @cda %{content: "sss", name: "sss", username: "sss", is_show: false, is_change: false}

  test "test get_cdh" do
    assert LibraryService.get_cdh()
  end

  test "test get_ruleadrg" do
    assert LibraryService.get_ruleadrg()
  end

  test "test get_ruledrg" do
    assert LibraryService.get_ruledrg()
  end

  test "test get_ruleicd9" do
    assert LibraryService.get_ruleicd9()
  end

  test "test get_ruleicd10" do
    assert LibraryService.get_ruleicd10()
  end

  test "test get_chinese_medicine" do
    assert LibraryService.get_chinese_medicine()
  end

  test "test get_chinese_medicine_patent" do
    assert LibraryService.get_chinese_medicine_patent()
  end

  test "test get_lib_wt4" do
    assert LibraryService.get_lib_wt4("Ssss")
  end

  test "test get_rulemdcs" do
    assert LibraryService.get_rulemdcs()
  end

  test "test get_ruleadrgs" do
    assert LibraryService.get_ruleadrgs()
  end

  test "test get_ruledrgs" do
    assert LibraryService.get_ruledrgs()
  end

  test "test get_ruleicd9s" do
    assert LibraryService.get_ruleicd9s()
  end

  test "test get_ruleicd10s" do
    assert LibraryService.get_ruleicd10s()
  end

  test "test get_chinese_medicines" do
    assert LibraryService.get_chinese_medicines()
  end

  test "test get_chinese_medicine_patents" do
    assert LibraryService.get_chinese_medicine_patents()
  end

  test "test get_lib_wt4s" do
    assert LibraryService.get_lib_wt4s()
  end

  test "test get_last_lib_wt4" do
    assert LibraryService.get_last_lib_wt4()
  end

  test "test get_rulemdc_num" do
    assert LibraryService.get_rulemdc_num()
  end

  test "test get_ruleadrg_num" do
    assert LibraryService.get_ruleadrg_num()
  end

  test "test get_ruledrg_num" do
    assert LibraryService.get_ruledrg_num()
  end

  test "test get_ruleicd9_num" do
    assert LibraryService.get_ruleicd9_num()
  end



  test "test get_ruleicd10_num" do
    assert LibraryService.get_ruleicd10_num()
  end

  test "test get_chinese_medicine_num" do
    assert LibraryService.get_chinese_medicine_num()
  end

  test "test get_chinese_medicine_patent_num" do
    assert LibraryService.get_chinese_medicine_patent_num()
  end

  test "test get_lib_wt4_num" do
    assert LibraryService.get_lib_wt4_num()
  end

end
