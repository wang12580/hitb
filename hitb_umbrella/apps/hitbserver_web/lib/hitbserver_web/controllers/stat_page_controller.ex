defmodule HitbserverWeb.StatPageController do
  use HitbserverWeb, :controller
  alias Server.UserService
  plug :put_layout, "app_stat.html"

  def stat(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(conn)
    if(login)do
      %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => _username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, conn.params)
      render conn, "stat.html", user: user, type: type, tool_type: tool_type, order_type: order_type, org: org, time: time, drg: drg, order: order, page_type: page_type, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def stat_info(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(conn)
    if(login)do
      %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => _username, "id" => id} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, conn.params)
      render conn, "stat_info_html.html", user: user, type: type, tool_type: tool_type, order_type: order_type, org: org, time: time, drg: drg, order: order, page_type: page_type, page_num: page, id: id
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def contrast(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(conn)
    if(login)do
      %{"page" => page, "page_type" => page_type, "type" => _type, "tool_type" => tool_type, "org" => org, "time" => _time, "drg" => _drg, "order" => order, "order_type" => order_type, "username" => _username} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => ""}, conn.params)
      [_, type, _, _, time, drg, _, _, _] = Hitb.ets_get(:stat_drg, "comurl_" <> user.username)
      render conn, "contrast.html", user: user, type: type, tool_type: tool_type, order_type: order_type, org: org, time: time, drg: drg, order: order, page_type: page_type, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end
end
