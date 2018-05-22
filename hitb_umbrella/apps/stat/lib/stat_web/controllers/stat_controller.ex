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
    [stat, list, tool, page_list, _, _, key, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    #转换为双层数组
    stat = [key, cnkey] ++ Stat.Convert.map2list(stat, key)
    json conn, %{stat: stat, page: page, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type}
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
    path = Hitb.File.write(System.user_home() <> "/download/", "stat.csv", str)
    json conn, %{path: path}
  end

  def stat_info(conn, %{"username" => username}) do
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["", "org", "", "", "", "drg", "", "", "base"]
        _ -> Hitb.ets_get(:stat_drg, "comurl_" <> username)
      end
    #获取keys
    key = Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)
    key = if(is_list(key) and key != [])do ["info_type", "org", "time"] ++ key else Key.key(username, drg, type, tool_type, page_type) end
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end)
    #获取分析
    stat = Stat.Query.info(username, 13)
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
    #按照key取值
    stat = [cnkey] ++ Stat.Convert.map2list(stat, key)
    json conn, %{stat: stat, suggest: suggest, key: key, cnkey: cnkey}
  end

  #详情页图表获取
  def stat_info_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["", "org", "", "", "", "drg", "", "", "base"]
        _ ->  Hitb.ets_get(:stat_drg, "comurl_" <> username)
      end
    %{"chart_key" => chart_key} = Map.merge(%{"chart_type" => "", "chart_key" => ""}, conn.params)
    #获取key
    key =
      if(chart_key != "")do
        ["org", "time", chart_key]
      else
        key = Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)
        ["org", "time"] ++ if(is_list(key) and key != [])do key else Key.key(username, drg, type, tool_type, page_type) end
      end
    #获取分析结果
    result = Stat.Chart.chart(Stat.Convert.map(Stat.Query.info(username, 13), key), chart_type)
    json conn, result
  end

  #对比页新增对比
  def stat_add(conn, %{"url" => url, "username" => username})do
    [page, type, tool_type, org, time, drg, order, order_type, page_type] = url
    #获取分析结果
    [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    stat = stat|>List.delete_at(0)|>List.delete_at(0)
    #拿到缓存中所有数据
    cache = Hitb.ets_get(:stat_drg, "comx_" <> username)
    cache = if (cache) do cache else [] end
    Hitb.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
    json conn, %{result: true}
  end

  #调取条件初始化
  defp conn_merge(params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, params)
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username]
  end
end
