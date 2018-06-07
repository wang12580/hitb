defmodule Hitb.Stat.StatFile do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stat_file" do
    field :first_menu, :string
    field :second_menu, :string
    field :file_name, :string
    field :page_type, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_menu, :second_menu, :file_name, :page_type])
    |> validate_required([:first_menu, :second_menu, :file_name, :page_type])
  end
end
