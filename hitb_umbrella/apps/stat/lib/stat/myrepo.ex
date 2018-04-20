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
      if(stat == nil or stat_type == "download")do
        #求skip
        skip = Hitbserver.Page.skip(page, rows_num)
        #查询stat
        sql = "select getstat(" <> to_string(skip) <> ", " <> to_string(rows_num) <> ", '" <> type <> "', '" <> time <> "', '" <> org <> "', '" <> drg <> "', '" <> to_string(order) <> "', '" <> order_type <> "', '" <> page_type <> "', '" <> tool_type <> "')"
        IO.puts sql
        stat = Postgrex.query!(Hitbserver.ets_get(:postgresx, :pid), sql, [], [timeout: 15000000]).rows
        #查询左侧list
        sql = "select getstat2('" <> type <> "', '" <> time <> "', '" <> org <> "', '" <> drg <> "', '" <> org <> "', '" <> page_type <> "')"
        list = Postgrex.query!(Hitbserver.ets_get(:postgresx, :pid), sql, [], [timeout: 15000000]).rows|>List.flatten|>Enum.uniq
        #查询工具
        sql = "select gettool('" <> type <> "', '" <> time <> "', '" <> org <> "', '" <> drg <> "', '" <> to_string(order) <> "', '" <> page_type <> "')"
        tool = Postgrex.query!(Hitbserver.ets_get(:postgresx, :pid), sql, [], [timeout: 15000000]).rows
        #求总数
        count = hd(hd(stat))
        count = String.to_integer(hd(:lists.usort(hd(count))))
        #取得分析结果
        stat = List.delete_at(hd(hd(stat)), 0)
        #存储
        Hitbserver.ets_insert(:stat, [page, type, org, time, drg, to_string(order), to_string(order_type), key, rows_num, Hitbserver.Time.sdata_date()], {list, count, skip, stat})
        {list, count, skip, stat, tool}
      else
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
end
