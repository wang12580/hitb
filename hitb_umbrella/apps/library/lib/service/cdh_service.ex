defmodule Library.CdhService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Library.Cdh
  alias Hitb.Page

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

  def cdh(page, rows, server_type) do
    rows = if(is_integer(rows))do rows else String.to_integer(rows) end
    skip = Page.skip(page, rows)
    query = from(w in Cdh)
    count = query |> select([w], count(w.id)) |> Repo.all |> List.first
    result = query
      |> limit([w], ^rows)
      |> offset([w], ^skip)
      |> Repo.all
    result =
      case length(result) do
        0 -> []
        _ ->
          [[], ["键", "值"]] ++ Enum.map(result, fn x -> [:key, :value]|>Enum.map(fn key -> Map.get(x, key) end) end)
      end
    [page_num, page_list, _count_page] = Page.page_list(page, count, rows)
    %{library: result, list: [], count: count, page_list: page_list, page: page_num}
  end

  defp cn(key) do
    case to_string(key) do
      "key" -> "KEY"
      "value" -> "VALUE"
      "hash" -> "哈希值"
      "previous_hash" -> "上一条哈希值"
      _ -> to_string(key)
    end
  end

end
