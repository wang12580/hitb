defmodule Hospitals.Repo.Migrations.CreateClientStat do
  use Ecto.Migration

  def change do
    create table(:client_stat) do
      add :username, :string #创建用户
      add :filename, :string #文件名
      add :data, :string #数据
      timestamps()
    end
  end
end
