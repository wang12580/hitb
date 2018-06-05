defmodule Hitb.Library.EnglishMedicine do
    use Ecto.Schema
    import Ecto.Changeset
    alias Hitb.Library.EnglishMedicine
  
    schema "english_medicine" do
      field :first_level, :string #一级分类
      field :second_level, :string #二级分类
      field :third_level, :string #三级分类
      # add :icd9_aa, {:array, :string}
      field :zh_name, :string #中文名称
      field :en_name, :string # 英文名称
      field :dosage_form, :string #剂型
      field :reimbursement_restrictions, :string #报销限制内容
  
      timestamps()
    end
  
  
    def changeset(%EnglishMedicine{} = english_medicine, attrs) do
      english_medicine
      |> cast(attrs, [:first_level, :second_level, :third_level, :zh_name, :en_name, :dosage_form, :reimbursement_restrictions])
      |> validate_required([:first_level, :second_level, :third_level, :zh_name, :en_name, :dosage_form, :reimbursement_restrictions])
    end
  end