defmodule Hitb.Edit.ClinetHelp do
    use Ecto.Schema
    import Ecto.Changeset
    alias Hitb.Edit.ClinetHelp


    schema "clinet_help" do
      field :name, :string
      field :content, :string
      timestamps()
    end

    @doc false
    def changeset(%ClinetHelp{} = clinet_help, attrs) do
      clinet_help
      |> cast(attrs, [:name, :content])
      |> validate_required([:name])
    end
  end
