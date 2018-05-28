defmodule Hitb.Stat.StatDrg do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stat_drg" do
    field :time, :string #时间
    field :org, :string #机构
    field :true_org, :string #机构
    field :drg, :string #DRG
    field :drg2, :string #DRG
    field :name, :string #名称
    field :num_sum, :integer #病历数
    field :death_num, :integer #死亡人数
    field :death_rate, :float #死亡率
    field :death_rate_log, :float #死亡率对数
    field :icd10_num, :integer #icd10病历数
    field :day_avg, :float #平均住院日
    field :fee_avg, :float
    field :weight_count, :float
    field :fee_index, :float
    field :day_index, :float
    field :cmi, :float
    field :death_age_avg, :float #平均死亡年龄
    field :weight, :float #权重
    field :death_level, :string #死亡风险等级
    field :time_type, :string #时间维度
    field :org_type, :string #机构维度
    field :etype, :string #病种维度
    field :mdc_code, :string #mdc编码
    field :int_time, :integer #时间排序
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:time, :org, :true_org, :drg, :drg2, :weight_count, :death_num, :death_rate, :icd10_num, :day_avg, :fee_avg, :fee_index, :day_index, :cmi, :death_age_avg, :weight, :death_level, :num_sum, :death_rate_log, :time_type, :org_type, :etype, :name, :mdc_code, :int_time])
    |> validate_required([:time, :org])
  end
end
