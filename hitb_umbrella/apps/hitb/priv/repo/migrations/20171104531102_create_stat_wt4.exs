defmodule Hitb.Stat.Repo.Migrations.CreateStatWt4 do
  use Ecto.Migration

  def change do
    create table(:stat_wt4) do
      add :time, :string #时间
      add :org, :string #机构名称
      add :day_avg, :float #平均住院日
      add :fee_avg, :float #平均费用
      add :death_rate, :float #死亡率
      # add :true_org, :string
      add :num_sum, :integer #病历数
      add :stat_num_sum, :integer #分析病例数=全部-9999-0000-8888
      add :remove_num_sum, :integer #排除病例数=9999+8888
      add :n_num_sum, :integer #未入组病例数=0000
      add :n_mdc_num_sum, :integer #未入mdc病例数=0000+9999+8888
      add :drg_rate, :float #入组率 = (1-(未入组病历数)/(病例总数-排除病例数))*100
      add :department_num, :integer #科室数
      add :doctor_num, :integer #医师数
      add :org_type, :string #机构维度
      add :time_type, :string #时间维度
      add :int_time, :integer #时间排序
      timestamps()
    end
  end
end
