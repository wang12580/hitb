defmodule Hitb.Library.Mdc do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Library.Mdc

  schema "mdc" do
    field :code, :string
    field :name, :string
    field :mdc, :string
    # field :icd9_aa, {:array, :string}
    field :is_p, :boolean, default: false
    field :gender, :string
    field :year, :string
    timestamps()
  end

  def changeset(%Mdc{} = mdc, attrs) do
    mdc
    |> cast(attrs, [:code, :name, :mdc, :gender])
    |> validate_required([:code, :name, :mdc, :gender])
  end
end
