defmodule Hitb.Library.Repo.Migrations.CreateWt4 do
  use Ecto.Migration

  def change do
    create table(:wt4) do
      add :payment_methods, :float
      add :case_id, :string
      add :age, :integer
      add :bed_expense, :float
      add :bed_tend_expense, :float
      add :western_medicine_expense, :float
      add :chinese_medicine_expense1, :float
      add :chinese_medicine_expense2, :float
      add :radiate_expense, :float
      add :check_expense, :float
      add :oxygen_expense, :float
      add :transfusion_expense, :float
      add :examine_expense, :float
      add :operation_expense, :float
      add :deliver_expense, :float
      add :horus_expense, :float
      add :other_expense, :float
      add :date_inhospital, :string
      add :acctual_days, :integer
      add :director_doctor, :string
      add :selfpayment_expense, :float
      add :check_normal_expense, :float
      add :cure_clinical_expense, :float
      add :cure_intrude_expense, :float
      add :cure_special_expense, :float
      add :cure_recover_expense, :float
      add :cure_chinese_expense, :float
      add :cure_normal_expense, :float
      add :cure_mind_expense, :float
      add :auxiliary_expense, :float
      add :stuff_cure_expense, :float
      add :stuff_intrude_expense, :float
      add :stuff_surgery_expense, :float
      add :stuff_check_expense, :float
      add :register_expense, :float
      add :antiseptic_medicine_expense, :float
      add :product_albumin_expense, :float
      add :product_globulin_expense, :float
      add :product_blood_expense, :float
      add :product_cell_expense, :float
      add :check_nucleus_expense, :float
      add :cure_nucleus_expense, :float
      add :ultrasound_expense, :float
      add :pathology_expense, :float
      add :cure_tend_expense, :float
      add :sf0100, :integer
      add :sf0102, :integer
      add :sf0104, :integer
      add :sf0108, :integer
      add :disease_code1, :string
      add :goout_diagnose_name, :string
      add :b_wt4_v1_id, :integer
      add :disease_code, :string # 主要诊断编码
      add :expense_gl, :float #管理费用
      add :expense_hl, :float # 护理费用
      add :expense_yj, :float # 医技费用 无
      add :expense_yl, :float # 医疗费用
      add :expense_yp, :float # 药品费用
      add :expense_yp_hc, :float # 药品与耗材费用 无
      add :gender, :string # 性别
      add :pay_type, :float # 支付方式（自付、医保） 无
      # add :sf0100, :integer
      # add :sf0102, :integer
      # add :sf0104, :integer
      # add :sf0108, :integer # 出院转归
      # add :death, :float # 是否死亡
      add :total_expense, :float # 总费用
      add :heal_expense, :float # 医保费用
      add :self_expense, :float #个人费用
      add :diags_code, {:array, :string} #主要诊断编码
      add :opers_code, {:array, :string} #其他诊断编码
      add :year_time, :string #年
      add :half_year, :string #半年
      add :season_time, :string #季度
      add :month_time, :string #月度
      add :org, :string # 机构原名
      add :department, :string # 科室原名
      add :cherf_department, :string # 医师
      add :drg, :string #DRG
      add :adrg, :string #ADRG
      add :mdc, :string #MDC
      add :zl, :integer #诊疗病历数
      add :jc, :integer #检查病历数
      add :wlzl, :integer #临床物理治疗病历数
      add :jrzl, :integer #介入治疗病历数
      add :tszl, :integer #特殊治疗病历数
      add :kfzl, :integer #康复治疗病历数
      add :zyzl, :integer #中医治疗病历数
      add :ybzl, :integer #一般治疗病历数
      add :jszl, :integer #精神治疗病历数
      add :js, :integer #接生病历数
      add :hsjc, :integer #核素检查病历数
      add :hszl, :integer #核素治疗病历数
      add :cszl, :integer #超声治疗病历数
      add :fszl, :integer #放射治疗病历数
      add :hy, :integer #化验病历数
      add :bl, :integer #病理病历数
      add :jhfz, :integer #监护及辅助病历数
      add :sx, :integer #输血病历数
      add :sy, :integer #输氧使用病历数
      add :hlzl, :integer #护理治疗病历数
      add :hl, :integer #护理病历数
      add :yzcy, :integer #医嘱出院病历数
      add :yzzy, :integer #医嘱转院病历数
      add :mzzy, :integer #门诊住院病历数
      add :jzzy, :integer #急诊住院病历数
      add :zygt, :integer #住院天数>60病历数
      timestamps()
    end

  end
end
