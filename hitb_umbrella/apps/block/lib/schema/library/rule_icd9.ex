defmodule Block.Library.RuleIcd9 do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_icd9" do
    field :code, :string
    field :name, :string
    field :codes, {:array, :string}
    field :icdcc, :string
    field :icdc, :string
    field :dissect, :string
    field :adrg, {:array, :string}
    field :p_type, :integer
    field :property, :string
    field :option, :string
    field :org, :string
    field :year, :string
    field :version, :string
    field :plat, :string
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :name, :codes, :dissect, :icdcc, :icdc, :adrg, :p_type, :property, :option, :org, :year, :version, :plat, :previous_hash, :hash])
    |> validate_required([:code, :previous_hash, :hash])
  end

end
