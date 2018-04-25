defmodule Library.RuleDrg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rule_drg" do
    field :code, :string
    field :name, :string
    field :mdc, :string
    field :adrg, :string
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
    |> cast(params, [:code, :name, :mdc, :adrg, :org, :year, :version, :plat])
    |> validate_required([:code])
  end

end
