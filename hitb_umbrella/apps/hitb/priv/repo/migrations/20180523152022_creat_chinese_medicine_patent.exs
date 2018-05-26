defmodule Hitb.Library.Repo.Migrations.ChineseMedicinePatent do
  use Ecto.Migration

  def change do
    create table(:chinese_medicine_patent) do
      add :code, :string #药品分类代码
      add :medicine_type, :string #药品类型
      add :type, :string #药品分类
      add :medicine_code, :string #药品名称
      add :name, :string #名称
      add :name_1, :string #其他名称
      add :other_spec, :string #其他规格
      add :org_limit, :string#限门诊或住院使用
      add :department_limit, :string#限医疗机构等级
      add :user_limit, :string#人员限制
      add :other_limit, :string#其他限制

      timestamps()
    end

  end
end
