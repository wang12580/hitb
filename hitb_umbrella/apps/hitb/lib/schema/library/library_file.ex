defmodule Hitb.Library.LibraryFile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Library.LibraryFile


  schema "library_file" do
    field :file_name, :string #文件名称
    field :insert_user, :string
    field :update_user, :string
    field :header, :string
    timestamps()
  end

  @doc false
  def changeset(%LibraryFile{} = library_file, attrs) do
    library_file
    |> cast(attrs, [:file_name, :insert_user, :update_user, :header])
    |> validate_required([:file_name])
  end
end
