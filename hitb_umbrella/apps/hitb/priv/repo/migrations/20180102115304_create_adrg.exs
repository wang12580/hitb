defmodule Hitb.Library.Repo.Migrations.CreateAdrg do
  use Ecto.Migration

  def change do
    create table(:adrg) do
      add :code, :string
      add :name, :string
      add :drgs_1, {:array, :string}
      add :icd10a1, {:array, :string} #主要规则
      add :icd10a2, {:array, :string} #其他规则
      add :icd9a1, {:array, :string} #主要规则
      add :icd9a2, {:array, :string} #其他规则
      add :icd10d1, {:array, :string} #主要规则
      add :icd10d2, {:array, :string} #其他规则
      add :icd9d1, {:array, :string} #主要规则
      add :icd9d2, {:array, :string} #其他规则
      add :opers_code, {:array, :string}
      add :sf0100, {:array, :string} #病历设置小于该数值
      add :sf0102, {:array, :string} #病历设置小于该数值
      add :mdc, :string
      timestamps()
    end

  end
end
