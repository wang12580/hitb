defmodule Hitb.Stat.Repo.Migrations.CreateClientSaveStat do
  use Ecto.Migration

  def change do
    create table(:client_save_stat) do
      add :username, :string #创建用户
      add :filename, :string #文件名
      add :data, :string #数据
      timestamps()
    end
  end
end
