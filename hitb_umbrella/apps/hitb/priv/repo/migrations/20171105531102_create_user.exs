defmodule Hitb.Server.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :age, :integer #年龄
      add :email, :string #电子邮箱
      add :hashpw, :string #密码
      add :name, :string #姓名
      add :org, :string #机构
      add :tel, :string #电话
      add :username, :string #用户名
      add :type, :integer #用户类型 1-管理员 2-普通用户
      add :block_address, :string #区块链hash值
      add :key, {:array, :string}
      add :is_show, :boolean, default: false
      timestamps()
    end
    create unique_index(:user, [:username])
  end
end
