defmodule HitbserverWeb.CdaController do
  use HitbserverWeb, :controller
  alias Edit.CdaService
  # alias Hitb.Time
  plug HitbserverWeb.Access

  def cda_user(conn, %{"server_type" => server_type}) do
    [cda, info] = CdaService.cda_user(server_type)
    json conn, %{cda: cda, info: info}
  end

  def cda_file(conn, _params) do
    %{"username" => username, "server_type" => server_type} = Map.merge(%{"username" => "", "server_type" => "server"}, conn.params)
    [cda, info] = CdaService.cda_files(username, server_type)
    json conn, %{cda: cda, info: info}
  end

  def cda_consule(conn, _params) do
    %{"diag" => cda_info} = Map.merge(%{"diag" => []}, conn.params)
    result =
      case cda_info do
        [] -> []
        _->
          cda_info = Poison.decode!(cda_info)
          CdaService.consule(cda_info)
      end
    json conn, %{cda: result}
  end

  def index(conn, _params) do
    %{"filename" => filename, "username" => username} = Map.merge(%{"filename" => "", "username" => ""}, conn.params)
    [cda, info] = CdaService.cda_file(filename, username)
    json conn, %{cda: cda, info: info}
  end

  def update(conn, %{"id" => id, "content" => content, "file_name" => file_name, "username" => username, "doctype" => doctype, "mouldtype" => mouldtype, "header"=> header, "save_type" => save_type}) do
    result = CdaService.update(id, content, file_name, username, doctype, mouldtype, header, save_type)
    json conn, result
  end
end
