defmodule Stat.MyRepo do
  use StatWeb, :controller
  alias Stat.Key

  #自定义取数据库
  def getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, rows_num, stat_type) do
    #获取各种keys
    key = Key.key(username, drg, type, tool_type, page_type) #英文key
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end) #中文key
    thkey = Enum.map(key, fn x -> %{cnkey: Key.cnkey(x), key: x} end) #表头key
    #取缓存stat
    stat = Hitbserver.ets_get(:stat, [page, type, org, time, drg, order, order_type, key, rows_num, Hitbserver.Time.sdata_date()])
    order = String.to_atom(order)
    #如果有下载任务,进行下载查询
    {list, count, _, stat, tool} =
      cond do
        stat_type == "download" or stat == nil ->
          list =
            cond do
              type == "org" ->
                from(p in Stat.StatOrg)|>where([p], p.org_type == "org")|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
              type == "heal" ->
                from(p in Stat.StatOrgHeal)|>department_where(org)|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
              type == "department" ->
                from(p in Stat.StatOrg)|>department_where(org)|>where([p], p.org_type == "department")|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
              type in ["mdc", "adrg", "drg"] -> []
              type == "case" ->
                cond do
                  String.contains? org, "_" ->
                    query_org = hd(String.split(org, "_")) <> "_%"
                    from(p in Stat.StatWt4)|>where([p], like(p.org, ^query_org))|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
                  true ->
                    from(p in Stat.StatWt4)|>where([p], p.org_type == "org")|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
                end
              type in ["year_time", "month_time", "season_time", "half_year", "time", "drg2"] ->
                case type do
                  "time" -> from(p in Stat.StatOrg)|>select([p], fragment("distinct ?", p.time))|>Repo.all|>Enum.sort
                  "drg2" -> []
                  _ -> from(p in Stat.StatOrg)|>where([p], p.time_type == ^type)|>select([p], fragment("distinct ?", p.time))|>Repo.all|>Enum.sort
                end
            end
          query =
            cond do
              type in ["mdc", "adrg", "drg"] ->
                query = from(p in Stat.StatDrg)
                  |>mywhere(type, org, time)
                  |>where([p], p.etype == ^type)
                list = select(query, [p], fragment("distinct ?", p.drg2))|>Repo.all|>Enum.sort
                if(type == "mdc")do
                  list = Enum.map(list, fn x -> "MDC" <> x end)
                  drg = String.slice(drg, 3, 1)
                end
                query
                |>drgwhere(type, drg)
              type == "heal" ->
                myfrom(drg)
                |>mywhere(type, org, time)
              type == "case" ->
                from(p in Stat.StatWt4)
                |>mywhere(type, org, time)
              true ->
                from(p in Stat.StatOrg)
                |>mywhere(type, org, time)
            end
          #求总数
          num = select(query, [p], count(p.id))
          count = hd(Repo.all(num, [timeout: 1500000]))
          #求skip
          skip = Hitbserver.Page.skip(page, rows_num)
          #取本页结果
          query =
            case order_type do
              "asc" -> order_by(query, [p], [asc: field(p, ^order)])
              "desc" -> order_by(query, [p], [desc: field(p, ^order)])
            end
          query = if(stat_type == "download")do query else limit(query, [p], ^rows_num)|>offset([p], ^skip) end
          stat = Repo.all(query)
            |>Enum.map(fn x ->
                key
                |>Enum.map(fn x ->
                    if(is_bitstring(x))do String.to_atom(x) else x end
                  end)
                |>Enum.map(fn k ->
                    v = Map.get(x, k)
                    cond do
                      is_nil(v) -> Stat.Rand.rand(k, nil)
                      is_float(v) ->  Float.round(v, 4)
                      is_integer(v) ->  Stat.Rand.rand(k, nil)
                      true -> v
                    end
                  end)
            end)
          stat = [key, cnkey] ++ stat
          if(stat_type != "download")do Hitbserver.ets_insert(:stat, [page, type, org, time, drg, to_string(order), to_string(order_type), key, rows_num, Hitbserver.Time.sdata_date()], {list, count, skip, stat}) end
          tool = []
          {list, count, skip, stat, tool}
        true ->
          Tuple.append(stat, [])
      end
    #求分页列表
    {page_num, page_list, count_page} = Hitbserver.Page.page_list(page, count, rows_num)
    #按照字段取值
    #如果有下载任务,进行下载查询
    # stat = if(stat_type == "download")do stat else [] end
    # 返回结果(分析结果, 列表, 页面工具, 页码列表, 当前页码, 字段, 中文字段, 表头字段)
    {stat, list, tool, page_list, page_num, count_page, key, cnkey, thkey}
  end

  #表判断
  defp myfrom(drg) do
    case drg do
      "" -> from(p in Stat.StatOrgHeal)
      _ ->  from(p in Stat.StatDrgHeal)
    end
  end

  #科室排除查询
  defp department_where(w, org) do
    cond do
      org == "" -> w
      true ->
        org = if(String.contains? org, "_")do hd(String.split(org, "_")) <> "_%" else org <> "_%" end
        where(w, [p], like(p.org, ^org))
    end
  end

  #drg排除查询
  defp drgwhere(w, type, code) do
    case code do
      "" -> w
      _ ->
        code = if(String.contains? code, "-")do String.split(code, "-")|>hd else code end
        case type do
          "heal" ->
            code = code <> "%"
            where(w, [p], like(p.drg, ^code))
           _ -> where(w, [p], p.drg == ^code and p.etype == ^type)
        end
    end
  end

  #排除查询
  defp mywhere(w, type, org, time) do
    w =
      case org do
        "" ->
          cond do
            type in ["org", "department"] -> where(w, [p], p.org_type == ^type)
            true -> where(w, [p], p.org_type == "org")
          end
        _ ->
          case type do
            "org" ->
              case String.contains? org, "_" do
                true -> where(w, [p], p.org_type == "org")
                false -> where(w, [p], p.org_type == "org" and p.org == ^org)
              end
            "department" ->
              query_org = if(String.contains? org, "_")do org else org <> "_%" end
              where(w, [p], p.org_type == "department" and like(p.org, ^query_org))
            _ ->
              case String.contains? org, "_" do
                true -> where(w, [p], p.org_type == "department" and like(p.org, ^org))
                false -> where(w, [p], p.org_type == "org" and p.org == ^org)
              end
          end
      end
    case time do
      "" ->
        cond do
          type in ["year_time", "half_year", "season_time", "month_time"] ->
            where(w, [p], p.time_type == ^type)
          true ->
            w
        end
      _ ->
        case type in ["year_time", "half_year", "season_time", "month_time"] do
          true ->  where(w, [p], p.time == ^time and p.time_type == ^type)
          false -> where(w, [p], p.time == ^time)
        end
    end
  end
end
