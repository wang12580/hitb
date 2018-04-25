defmodule Stat.StatWt4Test do
  use Stat.DataCase

  alias Stat.StatWt4

  @valid_attrs %{time: "sss", org: "sss", day_avg: 0.0, fee_avg: 0.0, death_rate: 0.0, num_sum: 1, stat_num_sum: 0, remove_num_sum: 0, n_num_sum: 0, n_mdc_num_sum: 0, drg_rate: 0.0, department_num: 0, doctor_num: 0, time_type: "sss", org_type: "0.0", int_time: 0}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = StatWt4.changeset(%StatWt4{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StatWt4.changeset(%StatWt4{}, @invalid_attrs)
    refute changeset.valid?
  end
end
