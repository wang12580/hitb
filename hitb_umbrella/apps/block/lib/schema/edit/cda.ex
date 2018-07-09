defmodule Block.Edit.Cda do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Edit.Cda


  schema "cda" do
    field :content, :string
    field :name, :string
    field :username, :string
    field :patient_id, :string
    field :is_change, :boolean, default: false
    field :is_show, :boolean, default: false
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  @doc false
  def changeset(%Cda{} = cda, attrs) do
    cda
    |> cast(attrs, [:username, :name, :content, :is_change, :is_show, :previous_hash, :hash, :patient_id])
    |> validate_required([:username, :name, :content, :is_change, :is_show, :hash, :patient_id])
    |> unique_constraint(:patient_id)
  end
end
