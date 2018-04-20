defmodule StatWeb.StatController do
  use StatWeb, :controller
  plug StatWeb.Access
  alias Stat.Key
  alias Stat.MyRepo
  alias Stat.Chart


  def stat_json(conn, _params) do
    user = %{username: ""}
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)
    #获取分析结果
    {stat, list, tool, page_list, _, _, _, _, _} = MyRepo.getstat(user.username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    #存储在自定义之前最后一次url
    Hitbserver.ets_insert(:stat_drg, "defined_url_" <> user.username, "page=" <> to_string(page) <> "&type=" <> type <> "&tool_type=" <> tool_type <> "&time=" <> "&drg=" <> drg <> "&order=" <> order <> "&order_type=" <> order_type <> "&page_type=" <> page_type <> "&org=" <> org)
    stat = Stat.Rand.rand(stat)
    json conn, %{stat: stat, page: page, tool: tool, list: [[list]], page_list: page_list, page_type: page_type, order: order, order_type: order_type}
  end

  #详情页图表获取
  def stat_info_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    {_, type, tool_type, _, _, drg, _, _, page_type} = Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
    params = Map.merge(%{"chart_type" => "", "chart_key" => ""}, conn.params)
    %{"chart_key" => chart_key} = params
    #获取keys
    keys = ["info_type"] ++ Key.key(username, drg, type, tool_type, page_type)
    keys = if (chart_type == "pie") do ["org", "time", chart_key] else keys end
    {stats, _} = stat_info_p(username, keys)
    #处理数据结构
    #按照字段取值
    stats = stats
      |>Enum.map(fn x ->
          Enum.reduce(0..length(x)-1, %{stat: x, key: keys, map: %{}}, fn x2, acc ->
            val = List.first(acc.stat)
            key = String.to_atom(List.first(acc.key))
            val =
              cond do
                key in [:info_type, :org, :time, :drg] -> val
                is_nil(val) -> "-"
                true -> String.to_float(val)
              end
            %{acc | :stat => List.delete_at(acc.stat, x2-x2), :key => List.delete_at(acc.key, x2-x2), :map => Map.put(acc.map, key, val)}
          end)|>Map.get(:map)
        end)
    result = Chart.chart(stats, chart_type)
    json conn, result
  end

  def contrast(conn, %{"username" => username}) do
    # user = %{username: ""}
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)
    #获取分析结果
    {_, _, tool, page_list, _, _, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    # 拆解url路径和参数
    #拿到缓存中所有数据
    statx = Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username)
    staty = Hitbserver.ets_get(:stat_drg, "comy" <> "_" <> username)
    #取当前key
    {_, list, _, _, _, _, _, cnkey, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    staty =
      cond do
        is_list(staty) and staty != [] -> ["org", "time"] ++ staty
        staty == nil -> cnkey
      end

    stat = [staty] ++ statx

    #按照字段取值
    #存储在自定义之前最后一次url
    Hitbserver.ets_insert(:stat_drg, "defined_url_" <> username, "page=" <> to_string(page) <> "&type=" <> type <> "&tool_type=" <> tool_type <> "&time=" <> "&drg=" <> drg <> "&order=" <> order <> "&order_type=" <> order_type <> "&page_type=" <> page_type <> "&org=" <> org)
    json conn, %{stat: stat, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type}
  end

  #对比缓存读取和删除
  def contrast_operate(conn, %{"username" => username, "field" => field, "com_type" => com_type})do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)
    #获取分析结果
    {stat, _, _, _,  _,_, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")
    cond do
      com_type == "add_x" or com_type == "del_x" ->
        #拿到缓存中所有数据
        cache = Hitbserver.ets_get(:stat_drg, "comx_" <> username)
        cache = unless(cache)do [] else cache end
        #求真实id
        id = field
        # |>String.to_integer
        #求当前id记录

        stat = Enum.reject(stat, fn x -> List.first(x) <> "_" <> List.first(List.delete_at(x, 0)) != id end)
        #根据情况处理缓存
        case com_type do
          "add_x" ->
            #处理缓存
            Hitbserver.ets_insert(:stat_drg, "comx_" <> username, cache ++ stat)
          "del_x" ->
            #去除当前id记录
            cache = Enum.reject(cache, fn x -> List.first(x) <> "_" <> List.first(List.delete_at(x, 0)) == id end)
            #处理缓存
            Hitbserver.ets_insert(:stat_drg, "comx_" <> username, cache)
        end
      com_type == "add_y" or com_type == "del_y" ->
        yid =
          case com_type do
            "add_y" ->
              #拿到缓存中所有数据
              cache = Hitbserver.ets_get(:stat_drg, "comy_" <> username)
              cache = unless(cache)do [] else cache end
              cond do
                type in ["mdc", "adrg", "drg"] ->
                  ["drg2"] ++ :lists.usort(cache ++ [field])
                true -> :lists.usort(cache ++ [field])
              end
            "del_y" ->
              #拿到缓存中所有数据
              cache = Hitbserver.ets_get(:stat_drg, "comy_" <> username)
              cache = unless(cache)do [] else cache end
              :lists.usort(cache -- [field])
          end
        #处理缓存
        Hitbserver.ets_insert(:stat_drg, "comy_" <> username, yid)
      true -> []
    end
    Hitbserver.ets_insert(:stat_drg, "comurl_" <> username, {page, type, tool_type, org, time, drg, order, order_type, page_type})
    json conn, %{result: true}
  end

  #获取list
  def contrast_list(conn, %{"username" => username})do
    %{ "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)

    #拆解url路径和参数
    {page, _, _, _, _, _, order, order_type, page_type} = Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
    #存储url
    Hitbserver.ets_insert(:stat_drg, "comurl_" <> username, {page, type, tool_type, org, time, drg, order, order_type, page_type})
    #取数据
    {_, list, _, _, _, _, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat")

    com_list = Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username)|>Enum.map(fn x -> List.first(x) end)
    list =
      Enum.reduce(com_list, list, fn x, acc ->
        acc -- [x]
      end)
    json conn, %{list: list}
  end

  def contrast_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    params = Map.merge(%{"chart_type" => "", "chart_key" => ""}, conn.params)
    %{"chart_key" => chart_key} = params
    # user = get_session(conn, :user)
    {_, type, tool_type, _, _, drg, _, _, page_type} = Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
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
    statx = Hitbserver.ets_get(:stat_drg, "comx_" <> username)
    #按照字段取值
    stat = statx
      |>Enum.map(fn x ->
          Enum.reduce(0..length(x)-1, %{stat: x, key: key, map: %{}}, fn x2, acc ->
            val = List.first(acc.stat)
            key = String.to_atom(List.first(acc.key))
            val =
              cond do
                key in [:org, :time, :drg] -> val
                is_nil(val) -> "-"
                true -> String.to_float(val)
              end
            %{acc | :stat => List.delete_at(acc.stat, x2-x2), :key => List.delete_at(acc.key, x2-x2), :map => Map.put(acc.map, key, val)}
          end)|>Map.get(:map)
        end)
    #最终要对比值
    result = Chart.chart(stat, chart_type)
    json conn, result
  end

  def contrast_info(conn, %{"username" => username})do
    #取对比分析
    {statx, staty} =
      case Hitbserver.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> {[], []}
        _ ->
          statx = Hitbserver.ets_get(:stat_drg, "comx" <> "_" <> username)
          staty = Hitbserver.ets_get(:stat_drg, "comy" <> "_" <> username)
          {unless(statx)do [] else statx end, unless(staty)do [] else staty end}
      end
    comtabx = Enum.map(statx, fn x ->
      List.first(x) <> "_" <> List.first(List.delete_at(x, 0))
    end)
    # comtaby = Enum.map(staty, fn x -> Key.cnkey(x) end)
    comtaby = staty
    json conn, %{x: comtabx, y: comtaby}
  end

  def contrast_clear(conn, %{"username" => username})do
    Hitbserver.ets_insert(:stat_drg, "comx_" <> username, [])
    Hitbserver.ets_insert(:stat_drg, "comy_" <> username, [])
    json conn, %{result: true}
  end

  def download_stat(conn, %{"username" => username})do
    #取对比分析
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)
    {stat, _, _, _, _, _, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "download")
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
    {_, type, tool_type, _, _, drg, _, _, page_type} = Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
    #获取keys
    keys = ["info_type"] ++ Key.key(username, drg, type, tool_type, page_type)
    {stats, _} = stat_info_p(username, keys)
    stats2 = stats
      |>Enum.map(fn x ->
          Enum.reduce(0..length(x)-1, %{stat: x, key: keys, map: %{}}, fn x2, acc ->
            val = List.first(acc.stat)
            key = String.to_atom(List.first(acc.key))
            val =
              cond do
                key in [:info_type, :org, :time, :drg] -> val
                is_nil(val) -> "-"
                true -> String.to_float(val)
              end
            %{acc | :stat => List.delete_at(acc.stat, x2-x2), :key => List.delete_at(acc.key, x2-x2), :map => Map.put(acc.map, key, val)}
          end)|>Map.get(:map)
        end)
    #环比和同比判断
    #去除多余的key
    stats2 = stats2
    |>Enum.map(fn x ->
        Enum.map(keys, fn y -> String.to_atom(y) end)
        |>Enum.map(fn y ->
            cond do
              Map.get(x, y) == nil -> %{info: "", key: y, val: "无数据"}
              is_float(Map.get(x, y)) -> %{info: "", key: y, val: Float.round(Map.get(x, y), 4)}
              true -> %{info: "", key: y, val: Map.get(x, y)}
            end
        end)
      end)
    com = stats2
      |>Enum.map(fn x ->
          Enum.reduce(x, %{}, fn x2, acc ->
            val = if(x2.val == "无数据" and x2.key not in [:org, :drg2, :time])do 0.0 else x2.val end
            Map.put(acc, x2.key, val)
          end)
        end)
    com =
      Enum.map(List.delete_at(com, 0), fn x ->
        type =
          case x.info_type do
            "环比记录" -> "环比"
            "同比记录" -> "同比"
          end
        #判断体
        res = Map.keys(x)
          |>Enum.map(fn key ->
              i = Map.get(x, key)
              if(is_float(i))do
                j = Map.get(hd(com), key)
                cond do
                  i <= 0.0 -> nil
                  true ->
                    res =
                      cond do
                        (j-i)/i == 0.0 -> "无变化"
                        (j-i)/i < 0.0 -> "降低" <> to_string(Float.round((j-i)/i*100*-1, 2)) <> "%"
                        (j-i)/i > 0.0 -> "增长" <> to_string(Float.round((j-i)/i*100, 2)) <> "%"
                      end
                    Key.cnkey(to_string(key)) <> type <> res
                end
              end
            end)
          |>Enum.reject(fn x -> x == nil end)
          |>Enum.join("，")
        if(res == "")do "无" <> type <> "记录。" else res <> "。" end
      end)
    cnkey = Enum.map(keys, fn x -> Key.cnkey(x) end)
    stats = [cnkey] ++ stats
      # , tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type
    json conn, %{stat: stats, com: com}
  end

  #提供分析
  defp stat_info_p(username, keys) do
    #拿到缓存中所有数据
    stat = Hitbserver.ets_get(:stat_drg, "comx_" <> username)
    stat = unless(stat)do [] else stat end
    #求当前id记录
    #去除当前id记录
    stat = List.last(stat)
    org = List.first(stat)
    time = List.first(List.delete_at(stat, 0))
    stat = ["当前记录"] ++ stat
    #取得记录
    sql = "select contrast('" <> org <> "', '" <> time <> "', '')"
    res = hd(hd(Postgrex.query!(Hitbserver.ets_get(:postgresx, :pid), sql, [], [timeout: 15000000]).rows))
    {page, type, tool_type, _, _, drg, order, order_type, page_type} = Hitbserver.ets_get(:stat_drg, "comurl_" <> username)
    {_, mm_stat, yy_stat} = List.to_tuple(res)
    mm_stat =
      if(nil in mm_stat)do
        []
      else
        {org, time} = List.to_tuple(mm_stat)
        {mm_stat, _, _, _, _, _, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 1, "download")
        ["环比记录"] ++ List.last(mm_stat)
      end
    yy_stat =
      if(nil in yy_stat)do
        []
      else
        {org, time} = List.to_tuple(yy_stat)
        {yy_stat, _, _, _, _, _, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 1, "download")
        ["环比记录"] ++ List.last(yy_stat)
      end
    stats = ([stat] ++ [mm_stat] ++ [yy_stat])|>Enum.reject(fn x -> x == [] end)
    # IO.inspect stats|>Enum.reject(fn x -> x == [] end)
    cnkey = Enum.map(keys, fn x -> Key.cnkey(x) end)

    {stats, cnkey}
  end
end
