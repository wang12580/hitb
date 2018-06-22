defmodule Edit.CdhService do
  # import Ecto
  # import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.Cdh

  def cdh_list() do
    Repo.all(Cdh)
  end

  def channel_cdh_list() do
    Repo.all(Cdh)
    |>Enum.reduce(%{}, fn x, acc ->
        content = x.content|>String.split(" ")|>Enum.reject(fn x -> x == nil end)
        value = Map.get(acc, x.name)
        case value do
          nil -> Map.put(acc, x.name, [content])
          _ -> Map.put(acc, x.name, [content | value])
        end
      end)
  end
end
