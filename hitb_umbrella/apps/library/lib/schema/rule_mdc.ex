defmodule Library.RuleMdc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_mdc" do
    field :code, :string
    field :name, :string
    field :mdc, :string
    field :icd9_a, {:array, :string}
    field :icd9_aa, {:array, :string}
    field :icd10_a, {:array, :string}
    field :icd10_aa, {:array, :string}
    field :org, :string
    field :year, :string
    field :version, :string
    field :plat, :string

    timestamps()
  end
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :name, :mdc, :icd9_a, :icd9_aa, :icd10_a, :icd10_aa, :org, :year, :version, :plat])
    |> validate_required([:code])
  end

end
