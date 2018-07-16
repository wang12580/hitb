defmodule Block.EditService do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Edit.Cda
  alias Block.Edit.CdaFile

  def get_cda() do
    Repo.all(from p in Cda, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_cdas() do
    Repo.all(from p in Cda)
  end

  def get_cda_num() do
    Repo.all(from p in Cda, select: count(p.id))|>List.first
  end

  def get_cda_file(username, editName) do
    Repo.get_by(CdaFile, username: username, filename: editName)
  end

  def create_cda_file(attr) do
    %CdaFile{}
    |>CdaFile.changeset(attr)
    |>Repo.insert()
  end

  def create_cda(attr) do
    %Cda{}
    |>Cda.changeset(attr)
    |>Repo.insert()
  end

end
