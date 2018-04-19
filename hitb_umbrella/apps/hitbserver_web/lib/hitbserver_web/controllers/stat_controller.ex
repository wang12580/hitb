defmodule HitbserverWeb.StatController do
  use HitbserverWeb, :controller
  alias HitbserverWeb.MyUser
  plug :put_layout, "app_stat.html"

  def stat(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)
      render conn, "stat.html", user: user, type: type, tool_type: tool_type, order_type: order_type, org: org, time: time, drg: drg, order: order, page_type: page_type, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def stat_info(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      %{"type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "id" => id} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc"}, conn.params)
      render conn, "stat_info_html.html", user: user, id: id, type: type, org: org, time: time, drg: drg, tool_type: tool_type
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  # def contrast(conn, %{"table" => table, "id" => id}) do
  #   user = get_session(conn, :user)
  #   login = MyUser.is_login(conn)
  #   if(login)do
  #     render conn, "contrast.html", user: user, table: table, id: id
  #   else
  #     redirect conn, to: "/hospitals/login"
  #   end
  # end
  def contrast(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "contrast.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end
end
