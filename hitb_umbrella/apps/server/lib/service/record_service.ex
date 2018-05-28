defmodule Server.RecordService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Server.Record

  def list_record(page, num) do
    skip = Hitb.Page.skip(page, 15)
    query = from(w in Record)
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> Repo.all
    count = hd(Repo.all(from p in Record, select: count(p.id)))
    [count, query]
  end

  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  def get_record!(id), do: Repo.get!(Record, id)

  def delete_record(id) do
    record = get_record!(id)
    Repo.delete(record)
  end

end
