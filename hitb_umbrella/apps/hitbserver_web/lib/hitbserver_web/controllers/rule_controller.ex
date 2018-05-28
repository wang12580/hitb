defmodule HitbserverWeb.RuleController do
  use HitbserverWeb, :controller
  # alias Server.UserService
  alias Library.RuleService
  plug HitbserverWeb.Access
  plug :put_layout, "app_stat.html"

  def rule(conn, _params) do
    %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect, "rows" => rows} = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => "", "rows" => 15}, conn.params)
    result = RuleService.rule(page, type, tab_type, version, year, dissect, rows)
    json conn, result
  end

  def rule_file(conn, _params) do
    file = RuleService.rule_file()
    json conn, %{data: file}
  end

  def rule_client(conn, _params) do
    %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect, "rows" => rows} = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => "", "rows" => 15}, conn.params)
    result = RuleService.rule_client(page, type, tab_type, version, year, dissect, rows)
    json conn, result
  end

  def contrast(conn, %{"table" => table, "id" => id}) do
    result = RuleService.contrast(table, id)
    json conn, result
  end

  def details(conn, %{"code" => code, "table" => table, "version" => version}) do
    result = RuleService.details(code, table, version)
    json conn, result
  end
# 模糊搜索
  def search(conn, _params) do
    %{"page" => page, "table" => table, "code" => code} = Map.merge(%{"page" => "1", "table" => "", "code" => ""}, conn.params)
    result = RuleService.search(page, table, code)
    json conn, result
  end

end
