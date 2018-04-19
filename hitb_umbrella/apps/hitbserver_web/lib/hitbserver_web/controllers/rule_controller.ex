defmodule HitbserverWeb.RuleController do
  use HitbserverWeb, :controller
  alias HitbserverWeb.MyUser
  plug :put_layout, "app_stat.html"

  def rule(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect} = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => ""}, conn.params)
      render conn, "rule.html", user: user, page: page, type: type, tab_type: tab_type, version: version, year: year,
      dissect: dissect
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def details(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "details.html", user: user
    else
      redirect conn, to: "/hospitals/login"
    end
  end



end
