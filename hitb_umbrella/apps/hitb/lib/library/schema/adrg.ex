defmodule Hitb.Library.Adrg do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Library.Adrg


  schema "adrg" do
    field :code, :string
    field :name, :string
    field :drgs_1, {:array, :string}
    field :icd10a1, {:array, :string} #主要规则
    field :icd10a2, {:array, :string} #其他规则
    field :icd9a1, {:array, :string} #主要规则
    field :icd9a2, {:array, :string} #其他规则
    field :icd10d1, {:array, :string} #主要规则
    field :icd10d2, {:array, :string} #其他规则
    field :icd9d1, {:array, :string} #主要规则
    field :icd9d2, {:array, :string} #其他规则
    field :opers_code, {:array, :string}
    field :sf0100, {:array, :string} #病历设置小于该数值
    field :sf0102, {:array, :string} #病历设置小于该数值
    field :mdc, :string
    timestamps()
  end

  def changeset(%Adrg{} = adrg, attrs) do
    adrg
    |> cast(attrs, [:code, :name, :drgs_1, :icd10a1, :icd10a2, :icd9a1, :icd9a2, :icd10d1, :icd10d2, :icd9d1, :icd9d2, :mdc, :opers_code, :sf0100, :sf0102])
    |> validate_required([:code, :name, :drgs_1, :mdc])
  end
end
