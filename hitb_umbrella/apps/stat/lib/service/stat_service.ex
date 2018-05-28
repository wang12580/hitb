defmodule Stat.StatService do
  alias Stat.Key
  alias Stat.Query

  def stat_json(page, page_type, type, tool_type, org, time, drg, order, order_type, username) do
    #获取分析结果
    [stat, list, tool, page_list, _, _, key, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    #转换为双层数组
    stat = [key, cnkey] ++ Stat.Convert.map2list(stat, key)
    %{stat: stat, page: page, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type}
  end

  def download_stat(page, page_type, type, tool_type, org, time, drg, order, order_type, username)do
    #取对比分析
    [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "download")
    #按照字段取值
    str = stat
      |>List.delete_at(0)
      |>Enum.reduce("", fn x, acc ->
          str = Enum.join(x, ",")
          acc <> str <> "\n"
        end)
    Hitb.File.write(System.user_home() <> "/download/", "stat.csv", str)
  end

  def stat_info(type, tool_type, drg, page_type, username) do
    #获取keys
    key = Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)
    key = if(is_list(key) and key != [])do ["info_type", "org", "time"] ++ key else Key.key(username, drg, type, tool_type, page_type) end
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end)
    #获取分析
    stat = Stat.Query.info(username, 13)
    suggest =
      if (stat != [[], []]) do
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
      else
        []
      end
    #按照key取值
    stat =
      case stat do
        [[], []] -> []
        _ -> [cnkey] ++ Stat.Convert.map2list(stat, key)
      end
    %{stat: stat, suggest: suggest, key: key, cnkey: cnkey}
  end

  #详情页图表获取
  def stat_info_chart(type, tool_type, drg, page_type, chart_type, chart_key, username)do
    #获取key
    key =
      if(chart_key != "")do
        ["org", "time", chart_key]
      else
        key = Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)
        ["org", "time"] ++ if(is_list(key) and key != [])do key else Key.key(username, drg, type, tool_type, page_type) end
      end
    #获取分析结果
    Stat.Chart.chart(Stat.Convert.map(Stat.Query.info(username, 13), key), chart_type)
  end

  #对比页新增对比
  def stat_add(page, type, tool_type, org, time, drg, order, order_type, page_type, username)do
    #获取分析结果
    [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    stat = stat|>List.delete_at(0)|>List.delete_at(0)
    #拿到缓存中所有数据
    cache = Hitb.ets_get(:stat_drg, "comx_" <> username)
    cache = if (cache) do cache else [] end
    Hitb.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
  end
end
