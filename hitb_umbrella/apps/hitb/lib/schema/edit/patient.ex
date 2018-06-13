defmodule Hitb.Edit.Patient do
    use Ecto.Schema
    import Ecto.Changeset
    alias Hitb.Edit.Patient
  
  
    schema "patient" do
      field :name, :string
      field :gender, :string
      field :age, :string
      field :nationality, :string
      field :marriage, :string
      field :native_place, :string
      field :occupation, :string
      field :username, :string
      field :patient_id, {:array, :string}
      timestamps()
    end
  
    @doc false
    def changeset(%Patient{} = patient, attrs) do
      patient
      |> cast(attrs, [:name, :gender, :age, :nationality, :marriage, :native_place, :occupation, :patient_id, :username])
      |> validate_required([ :username, :patient_id])
    end
  end
  