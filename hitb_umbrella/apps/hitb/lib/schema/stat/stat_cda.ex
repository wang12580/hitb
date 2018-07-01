defmodule Hitb.Stat.StatCda do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Stat.StatCda


  schema "stat_cda" do
    field :patient_id, :string
    field :name, :string
    field :gender, :string
    field :disease_code, :string
    field :disease_name, :string
    field :expense, :string
    field :time_in, :string
    field :time_out, :string
    field :create_user, :string
    field :create_time, :string
    field :update_time, :string
    timestamps()
  end

  @doc false
  def changeset(%StatCda{} = stat_cda, attrs) do
    stat_cda
    |> cast(attrs, [:patient_id, :name, :gender, :disease_code, :disease_name, :expense, :time_in, :time_out, :create_user, :create_time, :update_time])
    |> validate_required([:patient_id, :create_user, :create_time, :update_time])
  end
end
