defmodule Edit.CdhService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.Cdh

  def cdh_list() do
    Repo.all(Cdh)
  end

  def channel_cdh_list() do
    Repo.all(Cdh)
    |>Enum.map(fn x ->
        content = x.content|>String.split(" ")
        key = List.first(content)
        value = List.delete_at(content, 0)
        Map.put(%{}, key, value)
      end)
  end
end
