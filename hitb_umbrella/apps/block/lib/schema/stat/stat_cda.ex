defmodule Block.Stat.StatCda do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Stat.StatCda


  schema "stat_cda" do
    field :items, :string
    field :num, :integer
    field :previous_hash, :string
    field :hash, :string
    field :patient_id, {:array, :string}
    timestamps()
  end

  @doc false
  def changeset(%StatCda{} = stat_cda, attrs) do
    stat_cda
    |> cast(attrs, [:items, :num, :patient_id, :previous_hash, :hash])
    |> validate_required([:items, :num, :patient_id, :previous_hash, :hash])
    |> unique_constraint(:items)
  end
end
