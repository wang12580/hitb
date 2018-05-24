defmodule Stat.StatOrgHeal do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Stat.StatOrgHeal


  schema "stat_org_heal" do
    field :time, :string #时间
    field :org, :string #机构
    field :true_org, :string #机构
    field :num_sum, :integer #病历数
    field :death_rate, :float #死亡率
    field :day_avg, :float #平均住院日
    field :fee_avg, :float #平均费用
    field :heal_fee_avg, :float #平均医保费用
    field :self_fee_avg, :float #平均个人医保费用
    field :fee_gl, :float #管理费用
    field :fee_hl, :float #护理费用
    field :fee_yj, :float #医技费用 无
    field :fee_yl, :float  #医疗费用
    field :fee_yp, :float #药品费用
    field :pay_rate, :float #医保支付率
    field :selfpay_rate, :float #个人支付率
    field :time_type, :string #时间维度
    field :org_type, :string #机构维度
    field :int_time, :integer #时间排序
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:time, :org, :true_org, :num_sum, :death_rate, :day_avg, :fee_avg, :heal_fee_avg, :self_fee_avg, :fee_gl, :fee_hl, :fee_yj, :fee_yl, :fee_yp, :pay_rate, :selfpay_rate, :time_type, :org_type, :int_time])
    |> validate_required([:time, :org])
  end
end
