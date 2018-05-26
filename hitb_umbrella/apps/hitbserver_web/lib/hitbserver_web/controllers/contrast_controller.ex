defmodule HitbserverWeb.ContrastController do
  use HitbserverWeb, :controller
  plug HitbserverWeb.Access
  alias Stat.Key
  alias Stat.Query
  alias Stat.Chart
  alias Stat.ContrastService

  def contrast(conn, %{"username" => _username}) do
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username] = conn_merge(conn.params)
    result = ContrastService.contrast(page, page_type, type, tool_type, org, time, drg, order, order_type, username)
    json conn, result
  end

  #对比缓存读取和删除
  def contrast_operate(conn, %{"username" => username, "field" => field, "com_type" => com_type})do
    [page, page_type, type, tool_type, org, time, drg, order, order_type] =
      case conn.params["url"] do
        [] -> ["1", "base", "org", "total", "", "", "", "org", "asc"]
        _ -> conn.params["url"]
      end
    ContrastService.contrast_operate(page, page_type, type, tool_type, org, time, drg, order, order_type, username, com_type, field)
    json conn, %{result: true}
  end

  #获取list
  def contrast_list(conn, %{"username" => username})do
    [_page, _page_type, type, tool_type, org, time, drg, _order, _order_type, _username] = conn_merge(conn.params)
    #拆解url路径和参数
    [page, _, _, _, _, _, order, order_type, page_type] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["1", "", "", "", "", "", "org", "desc", "base"]
        _ -> Hitb.ets_get(:stat_drg, "comurl_" <> username)
      end
    list = ContrastService.contrast_list(page, type, tool_type, org, time, drg, username, order, order_type, page_type)
    json conn, %{list: list}
  end

  def contrast_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    %{"chart_key" => chart_key} = Map.merge(%{"chart_key" => ""}, conn.params)
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username)do
        nil-> ["", "org", "", "", "", "drg", "", "", "base"]
          _ -> Hitb.ets_get(:stat_drg, "comurl_" <> username)
      end
    result = ContrastService.contrast_chart(chart_type, username, chart_key, type, tool_type, drg, page_type)
    json conn, result
  end

  def contrast_info(conn, %{"username" => username})do
    result = ContrastService.contrast_info(username)
    json conn, result
  end

  def contrast_clear(conn, %{"username" => username})do
    ContrastService.contrast_clear(username)
    json conn, %{result: true}
  end

  #调取条件初始化
  defp conn_merge(params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, params)
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username]
  end

end
