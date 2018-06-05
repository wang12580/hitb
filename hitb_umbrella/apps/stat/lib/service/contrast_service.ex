defmodule Stat.ContrastService do
  # import Ecto.Query
  alias Stat.Key
  alias Stat.Query
  alias Stat.Chart
  alias Stat.Convert

  def contrast(page, page_type, type, tool_type, org, time, drg, order, order_type, username) do
    #获取页面key
    key = Key.key(username, drg, type, tool_type, page_type)
    cnkey = Enum.map(key, fn x -> Key.cnkey(x) end)
    #拿到缓存中所有数据
    [statx, staty] = [Hitb.ets_get(:stat_drg, "comx" <> "_" <> username),
                      Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)]
    statx = if(statx == nil)do [] else statx end
    staty = if(staty)do staty else key end
    #生成分析结果
    stat = [cnkey] ++ Convert.map2list(statx, staty)
    #存储url
    Hitb.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, order, order_type, page_type, org, time])
    #返回路径
    url = "page=#{page}&type=#{type}&org=#{org}&time=#{time}&drg=#{drg}&order=#{order}&page_type=#{page_type}&order_type=#{order_type}"
    %{stat: stat, key: key, cnkey: cnkey, page_type: page_type, order: order, order_type: order_type, url: url}
  end

  #对比缓存读取和删除
  def contrast_operate(page, page_type, type, tool_type, org, time, drg, order, order_type, username, com_type, field)do
    #获取分析结果
    [stat, _, _, _,  _,_, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat", "server")
    cond do
      com_type in ["add_x", "del_x"] ->
        #拿到缓存中所有数据
        cache = unless(Hitb.ets_get(:stat_drg, "comx_" <> username))do [] else Hitb.ets_get(:stat_drg, "comx_" <> username) end
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
            Hitb.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
          "del_x" ->
            Hitb.ets_insert(:stat_drg, "comx_" <> username, Enum.reject(cache, fn x -> "#{x.org}_#{x.time}" == id end))
        end
      com_type in ["add_y", "del_y"] ->
        #拿到缓存中所有数据
        cache = unless(Hitb.ets_get(:stat_drg, "comy_" <> username))do [] else Hitb.ets_get(:stat_drg, "comy_" <> username) end
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
        Hitb.ets_insert(:stat_drg, "comy_" <> username, yid)
      true -> []
    end
    Hitb.ets_insert(:stat_drg, "comurl_" <> username, [page, type, tool_type, org, time, drg, order, order_type, page_type])
    %{result: true}
  end

  #获取list
  def contrast_list(page, type, tool_type, org, time, drg, username, order, order_type, page_type)do
    #存储url
    Hitb.ets_insert(:stat_drg, "comurl_" <> username, [page, type, tool_type, org, time, drg, order, order_type, page_type])
    #取数据
    [_, list, _, _, _, _, _, _, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat", "server")
    #取得所有drg
    orgs =
      case Hitb.ets_get(:stat_drg, "comx" <> "_" <> username) do
        nil -> []
        _ -> Hitb.ets_get(:stat_drg, "comx" <> "_" <> username) |>Enum.map(fn x -> x.org end)
      end
    Enum.reject(list, fn x -> x in orgs end)
  end

  def contrast_chart(chart_type, username, chart_key, type, tool_type, drg, page_type) do
    #取key
    staty = Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)
    key = if(is_list(staty) and staty != [])do ["org", "time"] ++ staty else Key.key(username, drg, type, tool_type, page_type) end
    # 当列选择，饼图显示
    key =
      cond do
        chart_type == "pie" -> ["org","time", chart_key]
        chart_type == "scatter" -> ["org","time"] ++ String.split(chart_key, "-")
        true -> key
      end
    #取缓存
    comx = Hitb.ets_get(:stat_drg, "comx_" <> username)
    comx = if(comx)do comx else [] end
    stat = comx|>Convert.map(key)
    #最终要对比值
    Chart.chart(stat, chart_type)
  end

  def contrast_info(username)do
    #取对比分析
    [statx, staty] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> [[], []]
        _ ->
          statx = Hitb.ets_get(:stat_drg, "comx" <> "_" <> username)
          staty = Hitb.ets_get(:stat_drg, "comy" <> "_" <> username)
          [unless(statx)do [] else statx end, unless(staty)do [] else staty end]
      end
    [_page, type, tool_type, drg, _order, _order_type, page_type, _org, _time] =
      case Hitb.ets_get(:stat_drg, "defined_url_" <> username) do
        nil -> ["1", "org", "total", "", "org", "asc", "base", "", ""]
        _ -> Hitb.ets_get(:stat_drg, "defined_url_" <> username)
      end
    key = Stat.Key.key(username, drg, type, tool_type, page_type)
    comtabx = Enum.map(statx, fn x ->
                case "drg" in key or "drg2" in key do
                  false -> "#{x.org}_#{x.time}"
                  true -> "#{x.org}_#{x.time}_#{x.drg}"
                end
              end)
    comtaby = Enum.reject(staty, fn x -> x == "" end)|>Enum.map(fn x -> Key.cnkey(to_string(x)) end)
    %{x: comtabx, y: comtaby}
  end

  def contrast_clear(username)do
    Hitb.ets_insert(:stat_drg, "comx_" <> username, [])
    Hitb.ets_insert(:stat_drg, "comy_" <> username, [])
  end

end
