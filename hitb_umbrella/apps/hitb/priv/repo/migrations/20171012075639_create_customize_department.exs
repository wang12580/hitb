defmodule Hitb.Server.Repo.Migrations.CreateCustomizeDepartment do
  use Ecto.Migration

  def change do
    create table(:customize_department) do
      add :org, :string #所在机构
      add :c_user, :string #创建用户
      add :cherf_department, :string #科室主任
      add :class, :string #所属科室类
      add :department, :string #所属科室
      add :is_imp, :boolean, default: false, null: false #是否重点
      add :is_spe, :boolean, default: false, null: false #是否特色
      add :is_ban, :boolean, default: false, null: false #是否停用
      add :professor, :string #副主任
      add :wt_code, :string #内部科室编码
      add :wt_name, :string #内部科室名称
      timestamps()
    end

  end
end
