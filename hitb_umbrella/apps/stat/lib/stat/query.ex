defmodule Stat.Query do
  use StatWeb, :controller
  alias Stat.Key
  alias Stat.Convert

  #自定义取数据库
  def getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, rows_num, stat_type) do
    #获取各种keys
    key = Key.key(username, drg, type, tool_type, page_type) #英文key
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end) #中文key
    thkey = Enum.map(key, fn x -> %{cnkey: Key.cnkey(x), key: x} end) #表头key
    #取缓存stat
    cache_key = [page, type, org, time, drg, order, order_type, key, rows_num, Hitb.Time.sdata_date()]
    #分析获得
    [list, count, skip, stat] =
      cond do
        stat_type == "download" ->
          order = String.to_atom(order)
          #获取query
          query = query(page, type, tool_type, org, time, drg, order, order_type, page_type, rows_num)
          stat =
            case order_type do
              "asc" -> order_by(query, [p], [asc: field(p, ^order)])|>Repo.all
              "desc" -> order_by(query, [p], [desc: field(p, ^order)])|>Repo.all
            end
          [[], 0, 15, stat]
        Hitb.ets_get(:stat, cache_key) == nil ->
          order = String.to_atom(order)
          #获取左侧list
          list = list(type, org, time)
          #获取query
          query = query(page, type, tool_type, org, time, drg, order, order_type, page_type, rows_num)
          #取总数
          count = select(query, [p], count(p.id))|>Repo.all([timeout: 1500000])|>List.last
          #求本页stat
          skip = Hitb.Page.skip(page, rows_num)
          stat =
            case order_type do
              "asc" -> order_by(query, [p], [asc: field(p, ^order)])|>limit([p], ^rows_num)|>offset([p], ^skip)|>Repo.all
              "desc" -> order_by(query, [p], [desc: field(p, ^order)])|>limit([p], ^rows_num)|>offset([p], ^skip)|>Repo.all
            end
          #缓存
          Hitb.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, to_string(order), order_type, page_type, org, time])
          Hitb.ets_insert(:stat, cache_key, [list, count, skip, stat])
          [list, count, skip, stat]
        true ->
          Hitb.ets_get(:stat, cache_key)
      end
    # #求分页列表
    [page_num, page_list, count_page] = Hitb.Page.page_list(page, count, rows_num)
    # #按照字段取值
    # #如果有下载任务,进行下载查询
    # # stat = if(stat_type == "download")do stat else [] end
    # # 返回结果(分析结果, 列表, 页面工具, 页码列表, 当前页码, 字段, 中文字段, 表头字段)
    [stat, list, [], page_list, page_num, count_page, key, cnkey, thkey]
    # {[],[],[],[],1,0,[],[],[]}
  end

  def info(username, rows_num) do
    [page, type, tool_type, drg, order, order_type, page_type, org, time] = Hitb.ets_get(:stat_drg, "defined_url_" <> username)
    case Hitb.ets_get(:stat_drg, "comx_" <> username) do
      nil -> [[], []]
      _ ->
        stat = Hitb.ets_get(:stat_drg, "comx_" <> username)|>List.last
        mm_time = Convert.mm_time(stat.time)
        yy_time = Convert.yy_time(stat.time)
        #取缓存stat
        key = Key.key(username, drg, type, tool_type, page_type)
        #记录转换
        stat =
          [Map.merge(%{info_type: "当前记录"}, stat),
          Map.merge(%{info_type: "环比记录"}, Repo.get_by(Map.get(stat, :__struct__), time: mm_time, org: stat.org)),
          Map.merge(%{info_type: "同比记录"}, Repo.get_by(Map.get(stat, :__struct__), time: yy_time, org: stat.org))]
        #去除多余的key
        stat
        |>Enum.map(fn x ->
            Enum.map(["info_type"]++key, fn y -> String.to_atom(y) end)
            |>Enum.reduce(%{}, fn y, acc ->
                cond do
                  Map.get(x, y) == nil -> acc
                  is_float(Map.get(x, y)) -> Map.put(acc, y, Float.round(Map.get(x, y), 4))
                  true -> Map.put(acc, y, Map.get(x, y))
                end
            end)
          end)
    end
  end

  #左侧list
  defp list(type, org, time) do
    cond do
      type == "org" ->
        from(p in Stat.StatOrg)|>where([p], p.org_type == "org")|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
      type == "heal" ->
        from(p in Stat.StatOrgHeal)|>department_where(org)|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
      type == "department" ->
        from(p in Stat.StatOrg)|>department_where(org)|>where([p], p.org_type == "department")|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
      type in ["mdc", "adrg", "drg"] ->
        from(p in Stat.StatDrg)|>mywhere(type, org, time)|>where([p], p.etype == ^type)|>select([p], fragment("distinct ?", p.drg2))|>Repo.all|>Enum.sort
      type == "case" and String.contains? org, "_" ->
        query_org = hd(String.split(org, "_")) <> "_%"
        from(p in Stat.StatWt4)|>where([p], like(p.org, ^query_org))|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
      type == "case" ->
        from(p in Stat.StatWt4)|>where([p], p.org_type == "org")|>select([p], fragment("distinct ?", p.org))|>Repo.all|>Enum.sort
      type == "time" ->
        from(p in Stat.StatOrg)|>select([p], fragment("distinct ?", p.time))|>Repo.all|>Enum.sort
      type == "drg2" ->
        []
      type in ["year_time", "month_time", "season_time", "half_year"] ->
        from(p in Stat.StatOrg)|>where([p], p.time_type == ^type)|>select([p], fragment("distinct ?", p.time))|>Repo.all|>Enum.sort
    end
  end

  #生成查询语句
  defp query(page, type, tool_type, org, time, drg, order, order_type, page_type, rows_num) do
    cond do
      type in ["mdc", "adrg", "drg"] ->
        drg = if(type == "mdc")do String.slice(drg, 3, 1) else drg end
        query = from(p in Stat.StatDrg)|>mywhere(type, org, time)|>where([p], p.etype == ^type)|>drgwhere(type, drg)
      type == "heal" ->
        myfrom(drg)|>mywhere(type, org, time)
      type == "case" ->
        from(p in Stat.StatWt4)|>mywhere(type, org, time)
      true ->
        from(p in Stat.StatOrg)|>mywhere(type, org, time)
    end
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
