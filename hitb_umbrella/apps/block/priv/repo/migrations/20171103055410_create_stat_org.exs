defmodule Block.Stat.Repo.Migrations.CreateStatOrg do
  use Ecto.Migration

  def change do
    create table(:stat_org) do
      add :time, :string #时间
      add :org, :string #机构名称
      add :true_org, :string
      add :num_sum, :integer #分析病历数
      add :death_num, :integer #死亡人数
      add :death_rate, :float # 死亡率
      add :death_rate_log, :float #死亡率对数
      add :icd10_num, :integer #icd10病历数
      add :day_avg, :float #平均住院日
      add :fee_avg, :float #平均费用
      add :death_age_avg, :float #平均死亡年龄
      add :weight, :float #权重
      add :int_time, :integer #时间排序
      add :weight_count, :float #总权重
      add :fee_index, :float #费用消耗指数
      add :day_index, :float #时间消耗指数
      add :cmi, :float #CMI
      add :org_type, :string
      add :time_type, :string
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end
  end
end
