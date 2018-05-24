defmodule Server.ChatRecord do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Server.ChatRecord

  schema "chat_record" do
    field :room, :string
    field :date, :string
    field :record_string, :string
    field :record_array, {:array, :string}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:room, :date, :record_string, :record_array])
    |> validate_required([:room, :date, :record_string, :record_array])
  end
end
