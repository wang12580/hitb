defmodule Library.CdhService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Library.Cdh, as: HitbCdh
  alias Block.Library.Cdh, as: BlockCdh
  alias Hitb.Page
  alias Library.RuleService

  def cdh_list() do
    Repo.all(HitbCdh)
    |>Enum.map(fn x ->
        Map.drop(x, [:__meta__, :__struct__])
      end)
  end

  def channel_cdh_list() do
    Repo.all(HitbCdh)
    |>Enum.reduce(%{}, fn x, acc ->
        content = x.content|>String.split(" ")|>Enum.reject(fn x -> x == nil end)
        value = Map.get(acc, x.name)
        case value do
          nil -> Map.put(acc, x.name, [content])
          _ -> Map.put(acc, x.name, [content | value])
        end
      end)
  end

  def cdh(page, rows, server_type, sort_type, sort_value) do
    rows = if(is_integer(rows))do rows else String.to_integer(rows) end
    skip = Page.skip(page, rows)
    query = if(server_type == "server")do from(w in HitbCdh) else from(w in BlockCdh) end
    count = query |> select([w], count(w.id)) |> Repo.all |> List.first
    sort_value2 = RuleService.en(sort_value)|>String.to_atom
    result = order_by(query, [w], asc: field(w, ^sort_value2))
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
    %{library: result, list: %{time: [], org: [], version: []}, count: count, page_list: page_list, page: page_num, sort_type: sort_type, sort_value: sort_value}
  end

end
