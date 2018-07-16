defmodule Block.StatService do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Stat.StatOrg
  alias Block.Stat.StatFile
  # alias Block.Stat

  def get_stat() do
    Repo.all(from p in StatOrg, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_stats() do
    Repo.all(from p in StatOrg)
  end

  def get_stat_num() do
    Repo.all(from p in StatOrg, select: count(p.id))|>List.first
  end

  def get_stat_file(file_name) do
    Repo.get_by(StatFile, file_name: "#{file_name}")
  end

  def create_stat_file(attr) do
    %StatFile{}
    |>StatFile.changeset(attr)
    |>Repo.insert
  end

  def create_stat_org(attr) do
    %StatOrg{}
    |>StatOrg.changeset(attr)
    |>Repo.insert
  end

end
