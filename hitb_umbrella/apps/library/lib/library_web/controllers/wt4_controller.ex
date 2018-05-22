defmodule LibraryWeb.Wt4Controller do
  use LibraryWeb, :controller
  import Ecto.Query, warn: false
  plug LibraryWeb.Access
  alias Library.Wt4

  action_fallback LibraryWeb.FallbackController

  def index(conn, _params) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    skip = Hitb.Page.skip(page, 15)
    result = from(w in Wt4)
      |> limit([w], 15)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
      |> Repo.all
    count = hd(Repo.all(from p in Wt4, select: count(p.id)))
    [page_num, page_list, _] = Hitb.Page.page_list(page, count, 15)
    render(conn, "index.json", %{wt4: result, page_num: page_num, page_list: page_list, num: count, org_num: 0, time_num: 0, drg_num: 0})
  end

  def stat_wt4(conn, %{"time" => time, "org" => org, "drg" => drg}) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    skip = Hitb.Page.skip(page, 15)
    query = from(w in Wt4) |> where([w], w.year_time == ^time or w.half_year == ^time or w.month_time == ^time or w.season_time == ^time)
    query = if(drg == "")do query else query |> where([w], w.drg == ^drg) end
    query = if(org == "")do query else query |> where([w], w.org == ^org) end
    count = query |> select([w], count(w.id)) |> Repo.all |> List.first
    result = query
      |> limit([w], 15)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
      |> Repo.all
      |> Enum.map(fn x -> Map.drop(x, [:id, :__meta__, :__struct__]) end)
    result = Enum.reduce(result, [["病案ID", "主要诊断", "其他诊断", "手术/操作", "住院天数", "病种", "费用", "性别", "年龄"]], fn x, acc ->
              acc ++ [Enum.map([:b_wt4_v1_id, :disease_code, :diags_code, :opers_code, :acctual_days, :drg, :total_expense, :gender, :age], fn k -> if(k in [:diags_code, :opers_code])do Enum.join(Map.get(x, k), "-") else Map.get(x, k) end end)]
             end)
    {page_num, page_list, page_count} = Library.Page.page_list(page, count, 15)
    json conn, %{wt4: result, page: page_num, page_list: page_list, count: page_count, num: count, org_num: 0, time_num: 0, drg_num: 0}
  end

end
