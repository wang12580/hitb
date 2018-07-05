defmodule Hitb.Stat.StatCda do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Stat.StatCda


  schema "stat_cda" do
    field :items, :string
    field :num, :integer
    field :patient_id, {:array, :string}
    timestamps()
  end

  @doc false
  def changeset(%StatCda{} = stat_cda, attrs) do
    stat_cda
    |> cast(attrs, [:items, :num, :patient_id])
    |> validate_required([:items, :num, :patient_id])
    |> unique_constraint(:items)
  end
end
