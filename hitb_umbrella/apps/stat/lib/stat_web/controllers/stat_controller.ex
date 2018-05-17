defmodule StatWeb.StatController do
  use StatWeb, :controller
  plug StatWeb.Access
  alias Stat.Key
  alias Stat.Query
  alias Stat.Chart


  def stat_json(conn, _params) do
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username] = conn_merge(conn.params)
    page = String.to_integer(page)
    #获取分析结果
    [stat, list, tool, page_list, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    # stat = Stat.Rand.rand(stat)
    json conn, %{stat: stat, page: page, tool: tool, list: [[list]], page_list: page_list, page_type: page_type, order: order, order_type: order_type}
  end

  def contrast(conn, %{"username" => username}) do
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username] = conn_merge(conn.params)
    #获取分析结果
    [all_list, list, tool, page_list, _, _, _, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    list_key = hd(all_list)
    all_list = all_list|>List.delete_at(0)
    # 拆解url路径和参数
    #拿到缓存中所有数据
    statx = Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username)
    staty = Hitbserver.ets_get(:stat_drg, "comy" <> "_" <> username)
    #取当前key
    staty =
      cond do
        is_list(staty) and staty != [] ->
          list = ["org", "time"] ++ staty
          list1 = Enum.reject(list, fn x -> x == "" end)|>Enum.map(fn x -> Key.cnkey(to_string(x)) end)
        staty == nil or staty == [] -> cnkey
      end
    statx =
      case statx do
        nil -> all_list
        [] -> all_list
        _ -> List.insert_at(statx, 0, hd(all_list))
      end
    stat = statx
    header = hd(stat)
    index = Enum.map(staty, fn x -> Enum.find_index(header, fn x2 -> x == x2 end) end)|>:lists.usort
    stat = Enum.map(stat, fn x ->
      Enum.map(index, fn i -> Enum.at(x, i) end)
    end)
    #按照字段取值
    #存储在自定义之前最后一次url
    url = "page=#{page}&type=#{type}&org=#{org}&time=#{time}&drg=#{drg}&order=#{order}&page_type=#{page_type}&order_type=#{order_type}"
    Hitbserver.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, order, order_type, page_type, org, time])
    json conn, %{stat: stat, list_key: list_key, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type, url: url}
  end

  #对比缓存读取和删除
  def contrast_operate(conn, %{"username" => username, "field" => field, "com_type" => com_type})do
    [page, page_type, type, tool_type, org, time, drg, order, order_type] =
      case conn.params["url"] do
        [] -> ["1", "base", "org", "total", "", "", "", "org", "asc"]
        _ -> conn.params["url"]
      end
    #获取分析结果
    [stat, _, _, _,  _,_, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    cond do
      com_type in ["add_x", "del_x"] ->
        #拿到缓存中所有数据
        cache = unless(Hitbserver.ets_get(:stat_drg, "comx_" <> username))do [] else Hitbserver.ets_get(:stat_drg, "comx_" <> username) end
        #求真实id
        id = field
        # |>String.to_integer
        #求当前id记录
        stat =
          case length(String.split(id, "_")) do
            2 -> Enum.reject(stat, fn x -> "#{Enum.at(x, 0)}_#{Enum.at(x, 1)}" != id end)
            3 -> Enum.reject(stat, fn x -> "#{Enum.at(x, 0)}_#{Enum.at(x, 1)}_#{Enum.at(x, 2)}" != id end)
            _ -> []
          end
        #根据情况处理缓存
        case com_type do
          "add_x" ->
            Hitbserver.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
          "del_x" ->
            Hitbserver.ets_insert(:stat_drg, "comx_" <> username, Enum.reject(cache, fn x -> "#{Enum.at(x, 0)}_#{Enum.at(x, 1)}" == id end))
        end
      com_type in ["add_y", "del_y"] ->
        #拿到缓存中所有数据
        cache = unless(Hitbserver.ets_get(:stat_drg, "comy_" <> username))do [] else Hitbserver.ets_get(:stat_drg, "comy_" <> username) end
        yid =
          case com_type do
            "add_y" ->
              cond do
                type in ["mdc", "adrg", "drg"] ->
                  ["drg2"] ++ :lists.usort(cache ++ [field])
                true ->
                  :lists.usort(cache ++ [field])
              end
            "del_y" ->
              :lists.usort(cache -- [field])
          end
        #处理缓存
        Hitbserver.ets_insert(:stat_drg, "comy_" <> username, yid)
      true -> []
    end
    Hitbserver.ets_insert(:stat_drg, "comurl_" <> username, [page, type, tool_type, org, time, drg, order, order_type, page_type])
    json conn, %{result: true}
  end

  #获取list
  def contrast_list(conn, %{"username" => username})do
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username] = conn_merge(conn.params)
    #拆解url路径和参数
    [page, _, _, _, _, _, order, order_type, page_type] =
      case Hitbserver.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["1", "", "", "", "", "", "org", "desc", "base"]
        _ -> Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
      end
    #存储url
    Hitbserver.ets_insert(:stat_drg, "comurl_" <> username, [page, type, tool_type, org, time, drg, order, order_type, page_type])
    #取数据
    [_, list, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    com_list =
      case Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username) do
        nil -> []
        _ -> Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username)|>Enum.map(fn x -> List.first(x) end)
      end
    list = Enum.reduce(com_list, list, fn x, acc -> acc -- [x] end)
    json conn, %{list: list}
  end

  def contrast_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    params = Map.merge(%{"chart_type" => "", "chart_key" => ""}, conn.params)
    %{"chart_key" => chart_key} = params
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitbserver.ets_get(:stat_drg, "comurl_" <> username)do
        nil-> ["", "org", "", "", "", "drg", "", "", "base"]
          _ -> Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
      end
    #取key
    staty = Hitbserver.ets_get(:stat_drg, "comy" <> "_" <> username)

    key = if(is_list(staty) and staty != [])do ["org", "time"] ++ staty else Key.key(username, drg, type, tool_type, page_type) end
    # 当列选择，饼图显示
    key =
      cond do
        chart_type == "pie" -> ["org","time", chart_key]
        chart_type == "scatter" -> ["org","time"] ++ String.split(chart_key, "-")
        true -> key
      end
    #取缓存
    [all_list, list, tool, page_list, _, _, _, cnkey, _] = Query.getstat(username, 1, type, tool_type, "", "", drg, "org", "asc", page_type, 13, "stat")
    all_list = all_list|>List.delete_at(0)
    statx = Hitbserver.ets_get(:stat_drg, "comx_" <> username)
    cnkey = Enum.reject(key, fn x -> x == "" end)|>Enum.map(fn x -> Key.cnkey(to_string(x)) end)
    # cnkey = Enum.reject(key, fn x -> x == "" end)
    # |>Enum.map(fn x -> Key.cnkey(to_string(x)) end)
    #按照字段取值
    statx =
      case statx do
        nil -> all_list
        [] -> all_list
        _ -> List.insert_at(statx, 0, hd(all_list))
      end
    header = hd(statx)
    index = Enum.map(cnkey, fn x -> Enum.find_index(header, fn x2 -> x == x2 end) end)|>:lists.usort
    statx = Enum.map(statx, fn x ->
      Enum.map(index, fn i -> Enum.at(x, i) end)
    end)
    # statx = if (statx) do statx else [] end
    stat = statx |> Enum.reject(fn x -> x == cnkey or x == key end)
      |>Enum.map(fn x ->
          map = Enum.reduce(0..length(x)-1, %{stat: x, key: key, map: %{}}, fn x2, acc ->
            if(acc.key != [])do
              val = List.first(acc.stat)
              key = String.to_atom(List.first(acc.key))
              %{acc | :stat => List.delete_at(acc.stat, x2-x2), :key => List.delete_at(acc.key, x2-x2), :map => Map.put(acc.map, key, val)}
            else
              acc
            end
          end)|>Map.get(:map)
        end)
    #最终要对比值
    result = Chart.chart(stat, chart_type)
    json conn, result
  end

  def contrast_info(conn, %{"username" => username})do
    #取对比分析
    [statx, staty] =
      case Hitbserver.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> [[], []]
        _ ->
          statx = Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username)
          staty = Hitbserver.ets_get(:stat_drg, "comy" <> "_" <> username)
          [unless(statx)do [] else statx end, unless(staty)do [] else staty end]
      end
    [page, type, tool_type, drg, order, order_type, page_type, org, time] =
      case Hitbserver.ets_get(:stat_drg, "defined_url_" <> username) do
        nil -> ["1", "org", "total", "", "org", "asc", "base", "", ""]
        _ -> Hitbserver.ets_get(:stat_drg, "defined_url_" <> username)
      end

    header = Stat.Key.key(username, drg, type, tool_type, page_type)
    comtabx = Enum.map(statx, fn x ->
                case is_bitstring(Enum.at(x, 2)) or Enum.at(x, 2) == "-" do
                  false -> "#{Enum.at(x, 0)}_#{Enum.at(x, 1)}"
                  true -> "#{Enum.at(x, 0)}_#{Enum.at(x, 1)}_#{Enum.at(x, 2)}"
                end
              end)
    comtaby = Enum.reject(staty, fn x -> x == "" end)|>Enum.map(fn x -> Key.cnkey(to_string(x)) end)
    json conn, %{x: comtabx, y: comtaby}
  end

  def contrast_clear(conn, %{"username" => username})do
    Hitbserver.ets_insert(:stat_drg, "comx_" <> username, [])
    Hitbserver.ets_insert(:stat_drg, "comy_" <> username, [])
    json conn, %{result: true}
  end

  def download_stat(conn, %{"username" => username})do
    #取对比分析
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username] = conn_merge(conn.params)
    [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "download")
    #按照字段取值
    str = stat
      |>List.delete_at(0)
      |>Enum.reduce("", fn x, acc ->
          str = Enum.join(x, ",")
          acc <> str <> "\n"
        end)
    path = Hitbserver.File.write(System.user_home() <> "/download/", "stat.csv", str)
    json conn, %{path: path}
  end

  def stat_info(conn, %{"username" => username}) do
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitbserver.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["", "org", "", "", "", "drg", "", "", "base"]
        _ -> Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
      end
    #获取keys
    key = ["info_type"] ++ Key.key(username, drg, type, tool_type, page_type)
    stat = Stat.Query.info(username, 13)
    stat_key = Enum.map(stat, fn x -> Map.keys(x) end)|>List.flatten|>:lists.usort
    key = Enum.reject(key, fn x -> String.to_atom(x) not in stat_key end)
    suggest =
      Enum.map(List.delete_at(stat, 0), fn x ->
        type =
          case x.info_type do
            "环比记录" -> "环比"
            "同比记录" -> "同比"
          end
        #判断体
        Enum.map(Map.keys(x), fn k ->
          i = Map.get(x, k)
          if(is_float(i))do
            j = Map.get(hd(stat), k)
            cond do
              i <= 0.0 -> nil
              true ->
                cond do
                  (j-i)/i == 0.0 -> "#{Key.cnkey(to_string(k))}#{type}无变化"
                  (j-i)/i < 0.0 -> "#{Key.cnkey(to_string(k))}#{type}降低#{to_string(Float.round((j-i)/i*100*-1, 2))}%"
                  (j-i)/i > 0.0 -> "#{Key.cnkey(to_string(k))}#{type}增长#{to_string(Float.round((j-i)/i*100, 2))}%"
                end
            end
          end
        end)
        |>Enum.reject(fn x -> x == nil end)
        |>Enum.join("，")
      end)
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end)
    stat = Enum.reduce(stat, [cnkey], fn x, acc -> acc ++ [Enum.map(key, fn k -> Map.get(x, String.to_atom(k)) end)] end)
    json conn, %{stat: stat, suggest: suggest, stat_key: key}
  end

  #详情页图表获取
  def stat_info_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitbserver.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["", "org", "", "", "", "drg", "", "", "base"]
        _ ->  Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
      end
    %{"chart_key" => chart_key} = Map.merge(%{"chart_type" => "", "chart_key" => ""}, conn.params)
    stat =
    case chart_key do
      "" -> Stat.Query.info(username, 13)
      _ -> []
    end
    result = Stat.Chart.chart(stat, chart_type)
    json conn, result
  end


  #对比页新增对比
  def stat_add(conn, %{"url" => url, "username" => username})do
    [page, type, tool_type, org, time, drg, order, order_type, page_type] = url
    #获取分析结果
    [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    stat = stat|>List.delete_at(0)|>List.delete_at(0)
    #拿到缓存中所有数据
    cache = Hitbserver.ets_get(:stat_drg, "comx_" <> username)
    cache = if (cache) do cache else [] end
    Hitbserver.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
    json conn, %{result: true}
  end

  #调取条件初始化
  defp conn_merge(params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, params)
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username]
  end
end
