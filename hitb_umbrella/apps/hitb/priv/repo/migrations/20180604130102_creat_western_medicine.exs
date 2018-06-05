defmodule Hitb.Library.Repo.Migrations.WesternMedicine do
    use Ecto.Migration

    def change do
      create table(:western_medicine) do
        add :first_level, :string #一级分类
        add :second_level, :string #二级分类
        add :third_level, :string #三级分类
        # add :icd9_aa, {:array, :string}
        add :zh_name, :string #中文名称
        add :en_name, :string # 英文名称
        add :dosage_form, :string #剂型
        add :reimbursement_restrictions, :string #报销限制内容

        timestamps()
      end

    end
  end
