defmodule Hitb.Library.Wt4 do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wt4" do
    field :payment_methods, :float
    field :case_id, :string
    field :age, :integer
    field :bed_expense, :float
    field :bed_tend_expense, :float
    field :western_medicine_expense, :float
    field :chinese_medicine_expense1, :float
    field :chinese_medicine_expense2, :float
    field :radiate_expense, :float
    field :check_expense, :float
    field :oxygen_expense, :float
    field :transfusion_expense, :float
    field :examine_expense, :float
    field :operation_expense, :float
    field :deliver_expense, :float
    field :horus_expense, :float
    field :other_expense, :float
    field :date_inhospital, :string
    field :acctual_days, :integer
    field :director_doctor, :string
    field :selfpayment_expense, :float
    field :check_normal_expense, :float
    field :cure_clinical_expense, :float
    field :cure_intrude_expense, :float
    field :cure_special_expense, :float
    field :cure_recover_expense, :float
    field :cure_chinese_expense, :float
    field :cure_normal_expense, :float
    field :cure_mind_expense, :float
    field :auxiliary_expense, :float
    field :stuff_cure_expense, :float
    field :stuff_intrude_expense, :float
    field :stuff_surgery_expense, :float
    field :stuff_check_expense, :float
    field :register_expense, :float
    field :antiseptic_medicine_expense, :float
    field :product_albumin_expense, :float
    field :product_globulin_expense, :float
    field :product_blood_expense, :float
    field :product_cell_expense, :float
    field :check_nucleus_expense, :float
    field :cure_nucleus_expense, :float
    field :ultrasound_expense, :float
    field :pathology_expense, :float
    field :cure_tend_expense, :float
    field :sf0100, :integer
    field :sf0102, :integer
    field :sf0104, :integer
    field :sf0108, :integer
    field :disease_code1, :string
    field :goout_diagnose_name, :string
    field :b_wt4_v1_id, :integer
    field :disease_code, :string # 主要诊断编码
    field :expense_gl, :float #管理费用
    field :expense_hl, :float # 护理费用
    field :expense_yj, :float # 医技费用 无
    field :expense_yl, :float # 医疗费用
    field :expense_yp, :float # 药品费用
    field :expense_yp_hc, :float # 药品与耗材费用 无
    field :gender, :string # 性别
    field :pay_type, :float # 支付方式（自付、医保） 无
    # field :sf0100, :integer
    # field :sf0102, :integer
    # field :sf0104, :integer
    # field :sf0108, :integer # 出院转归
    # field :death, :float # 是否死亡
    field :total_expense, :float # 总费用
    field :heal_expense, :float # 医保费用
    field :self_expense, :float #个人费用
    field :diags_code, {:array, :string} #主要诊断编码
    field :opers_code, {:array, :string} #其他诊断编码
    field :year_time, :string #年
    field :half_year, :string #半年
    field :season_time, :string #季度
    field :month_time, :string #月度
    field :org, :string # 机构原名
    field :department, :string # 科室原名
    field :cherf_department, :string # 医师
    field :drg, :string #DRG
    field :adrg, :string #ADRG
    field :mdc, :string #MDC
    field :zl, :integer #诊疗病历数
    field :jc, :integer #检查病历数
    field :wlzl, :integer #临床物理治疗病历数
    field :jrzl, :integer #介入治疗病历数
    field :tszl, :integer #特殊治疗病历数
    field :kfzl, :integer #康复治疗病历数
    field :zyzl, :integer #中医治疗病历数
    field :ybzl, :integer #一般治疗病历数
    field :jszl, :integer #精神治疗病历数
    field :js, :integer #接生病历数
    field :hsjc, :integer #核素检查病历数
    field :hszl, :integer #核素治疗病历数
    field :cszl, :integer #超声治疗病历数
    field :fszl, :integer #放射治疗病历数
    field :hy, :integer #化验病历数
    field :bl, :integer #病理病历数
    field :jhfz, :integer #监护及辅助病历数
    field :sx, :integer #输血病历数
    field :sy, :integer #输氧使用病历数
    field :hlzl, :integer #护理治疗病历数
    field :hl, :integer #护理病历数
    field :yzcy, :integer #医嘱出院病历数
    field :yzzy, :integer #医嘱转院病历数
    field :mzzy, :integer #门诊住院病历数
    field :jzzy, :integer #急诊住院病历数
    field :zygt, :integer #住院天数>60病历数
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:payment_methods, :case_id, :gender, :age, :total_expense, :bed_expense, :bed_tend_expense, :western_medicine_expense, :chinese_medicine_expense1, :chinese_medicine_expense2, :radiate_expense, :check_expense, :oxygen_expense, :transfusion_expense, :examine_expense, :operation_expense, :deliver_expense, :horus_expense, :other_expense, :date_inhospital, :acctual_days, :director_doctor, :selfpayment_expense, :check_normal_expense, :cure_clinical_expense, :cure_intrude_expense, :cure_special_expense, :cure_recover_expense, :cure_chinese_expense, :cure_normal_expense, :cure_mind_expense, :auxiliary_expense, :stuff_cure_expense, :stuff_intrude_expense, :stuff_surgery_expense, :stuff_check_expense, :register_expense, :antiseptic_medicine_expense, :product_albumin_expense, :product_globulin_expense, :product_blood_expense, :product_cell_expense, :check_nucleus_expense, :cure_nucleus_expense, :ultrasound_expense, :pathology_expense, :cure_tend_expense, :disease_code1, :goout_diagnose_name, :b_wt4_v1_id, :disease_code, :expense_gl, :expense_hl, :expense_yj, :expense_yl, :expense_yp, :expense_yp_hc, :pay_type,  :heal_expense, :self_expense, :diags_code, :opers_code, :half_year, :season_time, :month_time, :org, :department, :cherf_department, :drg, :adrg, :mdc, :zl, :jc, :wlzl, :jrzl, :tszl, :kfzl, :zyzl, :ybzl, :jszl, :js, :hsjc, :hszl, :cszl, :fszl, :hy, :bl, :jhfz, :sx, :sy, :hlzl, :hl, :yzcy, :yzzy, :mzzy, :jzzy, :zygt, :sf0100, :sf0102, :sf0104, :sf0108])
    |> validate_required([:b_wt4_v1_id])
  end
end
