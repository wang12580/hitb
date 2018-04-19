defmodule Library.DrgRate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Library.DrgRate

  schema "drg_rate" do
    field :drg, :string
    field :name, :string
    field :rate, :float
    field :type, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(%DrgRate{} = drg_rate, attrs) do
    drg_rate
    |> cast(attrs, [:drg, :name, :rate, :type])
    |> validate_required([:drg, :name, :rate, :type])
  end

end
