defmodule Block.StatServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.StatService
  @stat_file %{first_menu: "sss", second_menu: "sss", file_name: "sss", page_type: "222", insert_user: "33333", update_user: "32222", header: "2222"}
  @stat_org %{time: "sss", org: "sss", true_org: "sss", num_sum: 0, death_num: 0, death_rate: 0.01, death_rate_log: 0.01, icd10_num: 0, day_avg: 0.01, fee_avg: 0.01, death_age_avg: 0.01, weight: 0.01, int_time: 0, weight_count: 0.01, fee_index: 0.01,
  day_index: 0.01, cmi: 0.01, org_type: "22", time_type: "111"}

  test "test get_stat" do
    assert StatService.get_stat()
  end

  test "test get_stats" do
    assert StatService.get_stats()
  end

  test "test get_cda_num" do
    assert StatService.get_stat_num()
  end

  test "test get_stat_file" do
    StatService.create_stat_file(@stat_file)
    assert StatService.get_stat_file("sss")
  end

  test "test create_stat_file" do
    assert StatService.create_stat_file(@stat_file)
  end

  test "test create_stat_org" do
    assert StatService.create_stat_org(@stat_org)
  end


end
