defmodule Block.Stat.Repo.Migrations.CreateClientStat do
  use Ecto.Migration

  def change do
    create table(:client_stat) do
      add :username, :string #创建用户
      add :filename, :string #文件名
      add :data, :string, size: 100000 #数据
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end
  end
end
