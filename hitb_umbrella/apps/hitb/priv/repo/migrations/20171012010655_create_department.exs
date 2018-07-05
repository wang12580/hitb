defmodule Hitb.Server.Repo.Migrations.CreateDepartment do
  use Ecto.Migration

  def change do
    create table(:department) do
      add :class_code, :string #内部科室编码
      add :class_name, :string #所属专科名称
      add :department_code, :string #科室编码
      add :department_name, :string #科室名称
      timestamps()
    end
    create unique_index(:department, [:class_code])

  end
end
