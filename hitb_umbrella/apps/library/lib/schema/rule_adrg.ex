defmodule Library.RuleAdrg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_adrg" do
    field :code, :string
    field :name, :string
    field :drgs_1, {:array, :string}
    field :icd10_a, {:array, :string}
    field :icd10_aa, {:array, :string}
    field :icd10_acc, {:array, :string}
    field :icd10_b, {:array, :string}
    field :icd10_bb, {:array, :string}
    field :icd10_bcc, {:array, :string}
    field :icd9_a, {:array, :string}
    field :icd9_aa, {:array, :string}
    field :icd9_acc, {:array, :string}
    field :icd9_b, {:array, :string}
    field :icd9_bb, {:array, :string}
    field :icd9_bcc, {:array, :string}
    field :mdc, :string
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
    |> cast(params, [:code, :name, :drgs_1, :icd10_a, :icd10_aa, :icd10_acc, :icd10_b, :icd10_bb, :icd10_bcc, :icd9_a, :icd9_aa, :icd9_acc, :icd9_b, :icd9_bb, :icd9_bcc, :mdc, :org, :year, :version, :plat])
    |> validate_required([])
  end
end
