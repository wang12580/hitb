defmodule HitbserverWeb.RulePageController do
  use HitbserverWeb, :controller
  alias Server.UserService
  plug :put_layout, "app_stat.html"

  def rule(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(conn)
    if(login)do
      %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect} = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => ""}, conn.params)
      render conn, "rule.html", user: user, page: page, type: type, tab_type: tab_type, version: version, year: year,
      dissect: dissect
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def details(conn, _params) do
    %{"code" => code, "table" => table, "version" => version, "name" => name} = Map.merge(%{"code" => "", "table" => "", "version" => "", "name" => ""}, conn.params)
    user = get_session(conn, :user)
    login = UserService.is_login(conn)
    if(login)do
      render conn, "details.html", user: user, code: code, name: name, table: table, version: version
    else
      redirect conn, to: "/hospitals/login"
    end
  end

end
