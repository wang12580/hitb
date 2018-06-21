defmodule Hitb.Edit.Cda do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Edit.Cda


  schema "cda" do
    field :content, :string
    field :name, :string
    field :patient_id, :string
    field :username, :string
    field :is_change, :boolean, default: false
    field :is_show, :boolean, default: false
    field :header, :string
    timestamps()
  end

  @doc false
  def changeset(%Cda{} = cda, attrs) do
    cda
    |> cast(attrs, [:username, :name, :content, :is_change, :is_show, :patient_id, :header])
    |> validate_required([:username, :name, :content, :is_change, :is_show])
  end
end
