defmodule Library.Repo.Migrations.CreateWt4 do
  use Ecto.Migration

  def change do
    create table(:wt4) do
      add :acctual_days, :integer #住院天数
      add :age, :integer #年龄
      add :date_inhospital, :string # 入院日期（可以计算得出acctual_days）
      add :disease_code, :string # 主要诊断编码
      add :disease_name, :string # 主要诊断名称
      add :expense_gl, :float #管理费用
      add :expense_hl, :float # 护理费用
      add :expense_yj, :float # 医技费用 无
      add :expense_yl, :float # 医疗费用
      add :expense_yp, :float # 药品费用
      add :expense_yp_hc, :float # 药品与耗材费用 无
      add :gender, :string # 性别
      add :pay_type, :integer # 支付方式（自付、医保） 无
      add :sf0100, :integer
      add :sf0102, :integer
      add :sf0104, :integer
      add :sf0108, :integer # 出院转归
      add :total_expense, :float # 总费用
      add :diags_code, {:array, :string}
      add :opers_code, {:array, :string}
      #时间字段
      add :year_time, :string #年
      add :half_year, :string #半年
      add :season_time, :string #季度
      add :month_time, :string #月度
      #机构相关
      add :org, :string # 机构原名
      add :department, :string # 科室原名
      add :cherf_department, :string # 医师
      #机构补充
      add :org_code, :string #补充机构代码
      add :org_name, :string #补充机构名称
      add :stat_org_name, :string #补充计算机构名称
      add :department_code, :string #科室补充代码
      add :department_name, :string #科室补充名称
      #分组结果
      add :drg, :string #无
      add :adrg, :string #无
      add :mdc, :string #无
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
