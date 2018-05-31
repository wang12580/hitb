defmodule Block.Stat.StatOrg do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Stat.StatOrg


  schema "stat_org" do
    field :time, :string #时间
    field :org, :string #机构名称
    field :true_org, :string
    field :num_sum, :integer #分析病历数
    field :death_num, :integer #死亡人数
    field :death_rate, :float # 死亡率
    field :death_rate_log, :float #死亡率对数
    field :icd10_num, :integer #icd10病历数
    field :day_avg, :float #平均住院日
    field :fee_avg, :float #平均费用
    field :death_age_avg, :float #平均死亡年龄
    field :weight, :float #权重
    field :int_time, :integer #时间排序
    field :weight_count, :float #总权重
    field :fee_index, :float #费用消耗指数
    field :day_index, :float #时间消耗指数
    field :cmi, :float #CMI
    field :org_type, :string
    field :time_type, :string
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:time, :org, :weight_count, :death_num, :death_rate, :icd10_num, :day_avg, :fee_avg, :fee_index, :day_index, :cmi, :death_age_avg, :weight, :int_time, :num_sum, :death_rate_log, :org_type, :time_type, :true_org, :previous_hash, :hash])
    |> validate_required([:previous_hash, :hash])
  end
end
