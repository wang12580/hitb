defmodule Hitb.Library.Repo.Migrations.StatCda do
    use Ecto.Migration

    def change do
      create table(:stat_cda) do
        add :patient_id, :string
        add :name, :string
        add :gender, :string
        add :disease_code, :string
        add :disease_name, :string
        add :expense, :string
        add :time_in, :string
        add :time_out, :string
        add :create_user, :string
        add :create_time, :string
        add :update_time, :string
        timestamps()
      end

    end
  end
