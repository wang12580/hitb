defmodule StatWeb.ContrastController do
  use StatWeb, :controller
  plug StatWeb.Access
  alias Stat.Key
  alias Stat.Query
  alias Stat.Chart

  def contrast(conn, %{"username" => username}) do
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username] = conn_merge(conn.params)
    #获取页面key
    key = Key.key(username, drg, type, tool_type, page_type)
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end)
    #拿到缓存中所有数据
    [statx, staty] = [Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username),
                      Hitbserver.ets_get(:stat_drg, "comy" <> "_" <> username)]
    staty = if(staty)do staty else key end
    #生成分析结果
    # IO.inspect statx
    IO.inspect staty
    stat = [cnkey] ++ Stat.Convert.map2list(statx, staty)
    #存储url
    Hitbserver.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, order, order_type, page_type, org, time])
    #返回路径
    url = "page=#{page}&type=#{type}&org=#{org}&time=#{time}&drg=#{drg}&order=#{order}&page_type=#{page_type}&order_type=#{order_type}"
    json conn, %{stat: stat, key: key, cnkey: cnkey, page_type: page_type, order: order, order_type: order_type, url: url}
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
            2 -> Enum.reject(stat, fn x -> "#{x.org}_#{x.time}" != id end)
            3 -> Enum.reject(stat, fn x -> "#{x.org}_#{x.time}_#{x.drg}" != id end)
            _ -> []
          end
        #根据情况处理缓存
        case com_type do
          "add_x" ->
            Hitbserver.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
          "del_x" ->
            Hitbserver.ets_insert(:stat_drg, "comx_" <> username, Enum.reject(cache, fn x -> "#{x.org}_#{x.time}" == id end))
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
    #取得所有drg
    orgs =
      case Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username) do
        nil -> []
        _ -> Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username) |>Enum.map(fn x -> x.org end)
      end
    list = Enum.reject(list, fn x -> x in orgs end)
    json conn, %{list: list}
  end

  def contrast_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    %{"chart_key" => chart_key} = Map.merge(%{"chart_key" => ""}, conn.params)
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
        IO.inspect ["org","time"] ++ String.split(chart_key, "-")
        true -> key
      end
    #取缓存
    stat = Hitbserver.ets_get(:stat_drg, "comx_" <> username)|>Stat.Convert.map(key)
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
    key = Stat.Key.key(username, drg, type, tool_type, page_type)
    comtabx = Enum.map(statx, fn x ->
                case "drg" in key or "drg2" in key do
                  false -> "#{x.org}_#{x.time}"
                  true -> "#{x.org}_#{x.time}_#{x.drg}"
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

  #调取条件初始化
  defp conn_merge(params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, params)
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username]
  end

end
