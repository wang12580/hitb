defmodule HitbserverWeb.CdaController do
  use HitbserverWeb, :controller
  alias Edit.CdaService
  alias Hitb.Time
  plug HitbserverWeb.Access

  def cda_user(conn, _params) do
    [cda, info] = CdaService.cda_user()
    json conn, %{cda: cda, info: info}
  end

  def cda_file(conn, _params) do
    %{"username" => username} = Map.merge(%{"username" => ""}, conn.params)
    [cda, info] = CdaService.cda_files(username)
    json conn, %{cda: cda, info: info}
  end

  def index(conn, _params) do
    %{"filename" => filename, "username" => username} = Map.merge(%{"filename" => "", "username" => ""}, conn.params)
    [cda, info] = CdaService.cda_file(filename, username)
    json conn, %{cda: cda, info: info}
  end

  def update(conn, %{"content" => content, "file_name" => file_name, "username" => username, "doctype" => doctype, "mouldtype" => mouldtype}) do
    result = CdaService.update(content, file_name, username, doctype, mouldtype)
    json conn, result
  end
end
