defmodule Hitb.Stat.StatDrgTest do
  use Hitb.DataCase

  alias Hitb.Stat.StatDrg

  @valid_attrs %{time: "sssss", org: "sssss", true_org: "sssss", drg: "sssss", drg2: "sssss", name: "sssss", num_sum: 12, death_num: 12, death_rate: 12.00, death_rate_log: 12.00, icd10_num: 12, day_avg: 12.00, fee_avg: 12.00, weight_count: 12.00,
   fee_index: 12.00, day_index: 12.00, cmi: 12.00, death_age_avg: 12.00, weight: 12.00, death_level: "sssss", time_type: "sssss", org_type: "sssss", etype: "sssss", mdc_code: "sssss", int_time: 12}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = StatDrg.changeset(%StatDrg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StatDrg.changeset(%StatDrg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
