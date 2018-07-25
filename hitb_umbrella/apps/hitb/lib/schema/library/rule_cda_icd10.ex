defmodule Hitb.Library.RuleCdaIcd10 do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_cda_icd10" do
    field :code, :string
    field :name, :string
    field :symptom, {:array, :string}
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :name, :symptom])
    |> validate_required([:code])
  end

end
