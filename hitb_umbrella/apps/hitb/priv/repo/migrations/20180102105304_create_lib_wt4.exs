defmodule Hitb.Library.Repo.Migrations.CreateLibWt4 do
  use Ecto.Migration

  def change do
    create table(:lib_wt4) do
      add :code, :string #编码
      add :name, :string #名称
      add :year, :string #年份
      add :type, :string #类型
      timestamps()
    end

  end
end
