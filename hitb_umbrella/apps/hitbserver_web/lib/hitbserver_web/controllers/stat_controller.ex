defmodule HitbserverWeb.StatController do
  use HitbserverWeb, :controller
  plug HitbserverWeb.Access
  alias Stat.StatService

  def stat_json(conn, _params) do
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username, server_type] = conn_merge(conn.params)
    result = StatService.stat_json(page, page_type, type, tool_type, org, time, drg, order, order_type, username)
    json conn, result
  end

  def download_stat(conn, %{"username" => _username})do
    #取对比分析
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username, server_type] = conn_merge(conn.params)
    path = StatService.download_stat(page, page_type, type, tool_type, org, time, drg, order, order_type, username)
    json conn, %{path: path}
  end

  def stat_info(conn, %{"username" => username}) do
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["", "org", "", "", "", "drg", "", "", "base"]
        _ -> Hitb.ets_get(:stat_drg, "comurl_" <> username)
      end
    result = StatService.stat_info(type, tool_type, drg, page_type, username)
    json conn, result
  end

  #详情页图表获取
  def stat_info_chart(conn, %{"chart_type" => chart_type, "username" => username})do
    [_, type, tool_type, _, _, drg, _, _, page_type] =
      case Hitb.ets_get(:stat_drg, "comurl_" <> username) do
        nil -> ["", "org", "", "", "", "drg", "", "", "base"]
        _ ->  Hitb.ets_get(:stat_drg, "comurl_" <> username)
      end
    %{"chart_key" => chart_key} = Map.merge(%{"chart_type" => "", "chart_key" => ""}, conn.params)
    result = StatService.stat_info_chart(type, tool_type, drg, page_type, chart_type, chart_key, username)
    json conn, result
  end

  #对比页新增对比
  def stat_add(conn, %{"url" => url, "username" => username})do
    [page, type, tool_type, org, time, drg, order, order_type, page_type] = url
    #获取分析结果
    StatService.stat_add(page, type, tool_type, org, time, drg, order, order_type, page_type, username)
    json conn, %{result: true}
  end

  #调取条件初始化
  defp conn_merge(params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, params)
    [page, page_type, type, tool_type, org, time, drg, order, order_type, username]
  end
end
