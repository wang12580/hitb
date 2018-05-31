defmodule Block.Stat.Repo.Migrations.CreateStatDrg do
  use Ecto.Migration

  def change do
    create table(:stat_drg) do
      add :time, :string #时间
      add :org, :string #机构
      add :true_org, :string #机构
      add :drg, :string #DRG
      add :drg2, :string #DRG
      add :name, :string #名称
      add :num_sum, :integer #病历数
      add :death_num, :integer #死亡人数
      add :death_rate, :float #死亡率
      add :death_rate_log, :float #死亡率对数
      add :icd10_num, :integer #icd10病历数
      add :day_avg, :float #平均住院日
      add :fee_avg, :float
      add :weight_count, :float
      add :fee_index, :float
      add :day_index, :float
      add :cmi, :float
      add :death_age_avg, :float #平均死亡年龄
      add :weight, :float #权重
      add :death_level, :string #死亡风险等级
      add :time_type, :string #时间维度
      add :org_type, :string #机构维度
      add :etype, :string #病种维度
      add :mdc_code, :string #mdc编码
      add :int_time, :integer #时间排序
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end

  end
end
