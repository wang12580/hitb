defmodule Hitb.Server.Repo.Migrations.CreateRecord do
  use Ecto.Migration

  def change do
    create table(:record) do
      add :mode, :string #操作
      add :type, :string #所在页面
      add :username, :string #帐号
      add :old_value, :string #旧值
      add :value, :string #新值

      timestamps()
    end

  end
end
