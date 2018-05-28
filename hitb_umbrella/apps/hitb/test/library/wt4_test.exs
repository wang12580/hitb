defmodule Hitb.Library.Wt4Test do
  use Hitb.DataCase

  alias Hitb.Library.Wt4

  @valid_attrs %{tszl: 0, bed_expense: 270.0, expense_yp: 14036.59, deliver_expense: 0.0, antiseptic_medicine_expense: 1350.01, ultrasound_expense: 135.0, sy: 0, mzzy: 0, zygt: 0, cherf_department: "", product_globulin_expense: 0.0, other_expense: 0.0, stuff_check_expense: 0.0, stuff_cure_expense: 0.0, operation_expense: 1680.0, season_time: "2016年第四季度",
  oxygen_expense: 0.0, cure_tend_expense: 0.0, cure_clinical_expense: 0.0, bl: 0, product_blood_expense: 0.0, expense_hl: 75.0, drg: "IU25", ybzl: 1, cure_mind_expense: 0.0, self_expense: 1352.39, bed_tend_expense: 75.0, mdc: "I", western_medicine_expense: 0.0, sf0100: -1, adrg: "IU2", heal_expense: 17867.12,
  disease_code1: "M51.202", month_time: "2016年12月", acctual_days: 15, gender: "女", examine_expense: 75.0, expense_yp_hc: 0.0, cure_intrude_expense: 0.0, js: 0, age: 72, chinese_medicine_expense1: 2079.22, check_normal_expense: 20.0, check_expense: 163.5, cszl: 1, total_expense: 19219.51, jrzl: 0, diags_code: [],
  sf0102: -1, product_albumin_expense: 0.0, case_id: "000003325", director_doctor: "", goout_diagnose_name: "腰椎间盘突出", pathology_expense: 0.0, sx: 0, check_nucleus_expense: 0.0, pay_type: 3.1, wlzl: 0, chinese_medicine_expense2: 10607.36, hlzl: 0, auxiliary_expense: 0.0, expense_yj: 2019.32, cure_recover_expense: 0.0, selfpayment_expense: 1352.39,
  half_year: "2016年下半年", cure_chinese_expense: 0.0, transfusion_expense: 0.0, yzzy: 0, stuff_intrude_expense: 0.0, date_inhospital: "2016-12-15", opers_code: ["针刀治疗针刀治疗"], expense_yl: 4359.6, hszl: 0, zyzl: 0, jhfz: 0, hl: 1, cure_nucleus_expense: 0.0, jszl: 0, expense_gl: 270.0, register_expense: 0.0,
  sf0104: -1, sf0108: 1, year_time: "2016年", cure_normal_expense: 2584.6, cure_special_expense: 0.0, stuff_surgery_expense: 0.0, product_cell_expense: 0.0, hy: 1, zl: 1, horus_expense: 0.0, jc: 1, department: "测试医院24_测试科室44", disease_code: "腰椎间盘突出", radiate_expense: 40.82, hsjc: 0, kfzl: 0,
  jzzy: "", payment_methods: 3.1, org: "测试医院24", fszl: 1, yzcy: 1, b_wt4_v1_id: -7752431}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Wt4.changeset(%Wt4{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Wt4.changeset(%Wt4{}, @invalid_attrs)
    refute changeset.valid?
  end
end
