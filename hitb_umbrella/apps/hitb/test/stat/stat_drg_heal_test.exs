defmodule Hitb.Stat.StatDrgHealTest do
  use Hitb.DataCase

  alias Hitb.Stat.StatDrgHeal

  @valid_attrs %{time: "sss", org: "sss", drg2: "sss", true_org: "sss", drg: "sss", name: "sss", num_sum: 1, death_rate: 0.0, day_avg: 0.0, fee_avg: 0.0, heal_fee_avg: 0.0, self_fee_avg: 0.0, fee_gl: 0.0, fee_hl: 0.0, fee_yj: 0.0, fee_yl: 0.0, fee_yp: 0.0, pay_rate: 0.0, selfpay_rate: 0.0, time_type: "sss", org_type: "0.0", etype: "dddd", int_time: 0}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = StatDrgHeal.changeset(%StatDrgHeal{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StatDrgHeal.changeset(%StatDrgHeal{}, @invalid_attrs)
    refute changeset.valid?
  end
end
