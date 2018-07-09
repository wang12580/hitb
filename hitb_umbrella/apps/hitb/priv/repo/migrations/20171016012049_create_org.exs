defmodule Hitb.Server.Repo.Migrations.CreateOrg do
  use Ecto.Migration

  def change do
    create table(:org) do
      add :county, :string #县
      add :city, :string #市
      add :code, :string #机构代码
      add :name, :string #机构名称
      add :email, :string #联系人邮箱
      add :is_show, :boolean, default: false, null: false #在wt4中是否显示
      add :is_ban, :boolean, default: false, null: false #是否弃用
      add :level, :string #机构等级
      add :person_name, :string #联系人
      add :province, :string #身份
      add :tel, :string #电话
      add :type, :string #机构类别
      add :stat_org_name, :integer #计算机构补充
      timestamps()
    end
    create unique_index(:org, [:code])
  end
end
