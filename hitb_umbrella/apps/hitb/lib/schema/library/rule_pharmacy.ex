defmodule Hitb.Library.RulePharmacy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_pharmacy" do
    field :pharmacy, :string
    field :icd10_a, {:array, :string}
    field :symptom, {:array, :string}
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pharmacy, :icd10_a, :symptom])
    |> validate_required([:pharmacy, :icd10_a, :symptom])
  end

end
