defmodule Hitb.Stat.StatFile do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stat_file" do
    field :first_menu, :string
    field :second_menu, :string
    field :file_name, :string
    field :page_type, :string    
    field :insert_user, :string 
    field :update_user, :string 
    field :header, :string 
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_menu, :second_menu, :file_name, :page_type, :insert_user, :update_user, :header])
    |> validate_required([:first_menu, :second_menu, :file_name, :page_type])
  end
end
