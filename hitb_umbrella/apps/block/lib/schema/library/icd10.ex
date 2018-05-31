defmodule Block.Library.Icd10 do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Library.Icd10

  schema "icd10" do
    field :code, :string
    field :codes, {:array, :string}
    field :name, :string
    field :icdcc, :string
    field :icdc, :string
    field :icdc_az, :string
    field :adrg, {:array, :string}
    field :drg, {:array, :string}
    field :cc, :boolean, default: false
    field :nocc_1, {:array, :string}
    field :nocc_a, {:array, :string}
    field :nocc_aa, {:array, :string}
    field :year, :string
    field :mcc, :boolean, default: false
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  def changeset(%Icd10{} = icd10, attrs) do
    icd10
    |> cast(attrs, [:code, :name, :icdcc, :icdc, :icdc_az, :adrg, :drg, :cc, :nocc_1, :nocc_a, :nocc_aa, :mcc, :codes, :previous_hash, :hash])
    # |> validate_required([:code, :name, :icdcc, :icdc, :icdc_az, :adrg, :drg, :cc, :nocc_1, :nocc_a, :nocc_aa, :mcc])
    |> validate_required([:codes, :name, :adrg, :previous_hash, :hash])
  end
end
