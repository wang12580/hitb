defmodule Hitb.Stat.StatOrgTest do
  use Hitb.DataCase

  alias Hitb.Stat.StatOrg


  @valid_attrs %{time: "sss", org: "sss", true_org: "sss", num_sum: 0, death_num: 0, death_rate: 0.01, death_rate_log: 0.01, icd10_num: 0, day_avg: 0.01, fee_avg: 0.01, death_age_avg: 0.01, weight: 0.01, int_time: 0, weight_count: 0.01, fee_index: 0.01,
  day_index: 0.01, cmi: 0.01, org_type: "22", time_type: "111"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = StatOrg.changeset(%StatOrg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StatOrg.changeset(%StatOrg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
