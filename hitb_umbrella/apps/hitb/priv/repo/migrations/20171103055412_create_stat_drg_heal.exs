defmodule Hitb.Stat.Repo.Migrations.CreateStatDrgHeal do
  use Ecto.Migration

  def change do
    create table(:stat_drg_heal) do
      add :time, :string #时间
      add :org, :string #机构
      add :drg2, :string
      add :true_org, :string #机构
      add :drg, :string #DRG
      add :name, :string #名称
      add :num_sum, :integer #病历数
      add :death_rate, :float #死亡率
      add :day_avg, :float #平均住院日
      add :fee_avg, :float #平均费用
      add :heal_fee_avg, :float #医保费用总计
      add :self_fee_avg, :float #个人费用总计
      add :fee_gl, :float #管理费用
      add :fee_hl, :float #护理费用
      add :fee_yj, :float #医技费用 无
      add :fee_yl, :float  #医疗费用
      add :fee_yp, :float #药品费用
      add :pay_rate, :float #支付率
      add :selfpay_rate, :float #个人支付率
      add :time_type, :string #时间维度
      add :org_type, :string #机构维度
      add :etype, :string #病种维度
      add :int_time, :integer #时间排序
      timestamps()
    end

  end
end
