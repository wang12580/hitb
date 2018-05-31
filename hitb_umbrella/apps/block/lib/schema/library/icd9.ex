defmodule Block.Library.Icd9 do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Library.Icd9

  schema "icd9" do
    field :code, :string
    field :codes, {:array, :string}
    field :name, :string
    field :icdcc, :string
    field :icdc, :string
    field :adrg, {:array, :string}
    field :drg, {:array, :string}
    field :p_type, :integer
    field :is_qy, :boolean, default: false
    field :year, :string
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  def changeset(%Icd9{} = icd9, attrs) do
    icd9
    |> cast(attrs, [:code, :name, :icdcc, :icdc, :adrg, :drg, :p_type, :is_qy, :codes, :previous_hash, :hash])
    |> validate_required([:code, :name, :icdcc, :icdc, :adrg, :drg, :p_type, :is_qy, :previous_hash, :hash])
  end
end
