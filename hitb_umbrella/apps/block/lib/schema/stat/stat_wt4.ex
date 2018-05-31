defmodule Block.Stat.StatWt4 do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Stat.StatWt4


  schema "stat_wt4" do
    field :time, :string #时间
    field :org, :string #机构名称
    field :day_avg, :float #平均住院日
    field :fee_avg, :float #平均费用
    field :death_rate, :float #死亡率
    # field :true_org, :string
    field :num_sum, :integer #病历数
    field :stat_num_sum, :integer #分析病例数=全部-9999-0000-8888
    field :remove_num_sum, :integer #排除病例数=9999+8888
    field :n_num_sum, :integer #未入组病例数=0000
    field :n_mdc_num_sum, :integer #未入mdc病例数=0000+9999+8888
    field :drg_rate, :float #入组率 = (1-(未入组病历数)/(病例总数-排除病例数))*100
    field :department_num, :integer #科室数
    field :doctor_num, :integer #医师数
    field :org_type, :string #机构维度
    field :time_type, :string #时间维度
    field :int_time, :integer #时间排序
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:time, :org, :num_sum, :stat_num_sum, :remove_num_sum, :n_num_sum, :n_mdc_num_sum, :drg_rate, :department_num, :doctor_num, :time_type, :org_type, :day_avg, :fee_avg, :death_rate, :int_time, :previous_hash, :hash])
    |> validate_required([:time, :org, :previous_hash, :hash])
  end
end
