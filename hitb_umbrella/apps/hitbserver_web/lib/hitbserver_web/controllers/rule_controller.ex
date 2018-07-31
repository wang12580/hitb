defmodule HitbserverWeb.RuleController do
  use HitbserverWeb, :controller
  # alias Server.UserService
  alias Library.RuleService
  alias Library.RuleService
  alias Library.CdhService
  alias Library.RuleCdaStatService
  plug HitbserverWeb.Access
  plug :put_layout, "app_stat.html"

  def rule(conn, _params) do
    %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect, "rows" => rows} = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => "", "rows" => 15}, conn.params)
    result = RuleService.rule_json(page, type, tab_type, version, year, dissect, rows)
    json conn, result
  end

  def rule_file(conn, _params) do
    %{"server_type" => server_type} = Map.merge(%{"server_type" => "server"}, conn.params)
    file = RuleService.rule_file(server_type)
    json conn, %{data: file}
  end

  def rule_client(conn, _params) do
    %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect, "rows" => rows, "server_type" => server_type, "sort_type" => sort_type, "sort_value" => sort_value} = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => "", "rows" => 15, "server_type" => "server", "sort_type" => "", "sort_value" => ""}, conn.params)
    sort_value =
      cond do
        tab_type == "西药" and sort_value == "编码" -> "英文名称"
        tab_type == "cdh" and sort_value == "编码" -> "键"
        true -> sort_value
      end
    server_type = if(server_type == "undefined")do "server" else server_type end
    result =
      case tab_type do
        "cdh" ->
          CdhService.cdh(page, rows, server_type, sort_type, sort_value)
        _ ->
          RuleService.rule_client(page, type, tab_type, version, year, dissect, rows, server_type, sort_type, sort_value)
      end
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
  # 字典库下载
  def rule_down(conn, %{"filename" => filename}) do
    result = RuleService.rule_down(filename)
    json conn, result
  end
  # 客户端模糊搜索
  def rule_search(conn, _params) do
    %{"filename" => filename, "value" => value, "servertype" => servertype} = Map.merge(%{"filename" => "", "value" => "", "servertype" => ""}, conn.params)
    result = RuleService.rule_search(filename, value, servertype)
    json conn, result
  end
  def rule_symptom(conn, _params) do
    %{"symptom" => symptom, "icd9_a" => icd9_a, "icd10_a" => icd10_a, "pharmacy" => pharmacy } = Map.merge(%{"symptom" => "上腹痛", "icd9_a" => [], "icd10_a" => [], "pharmacy" => ["消化系溃疡"]}, conn.params)
    RuleService.rule_symptom(symptom, icd9_a, icd10_a, pharmacy)
    json conn, %{}
  end
  def symptom_serach(conn, _params) do
    %{"symptom" => symptom} = Map.merge(%{"symptom" => %{}}, conn.params)
    result = RuleCdaStatService.symptom_serach(symptom)
    json conn, %{result: result}
  end

end
