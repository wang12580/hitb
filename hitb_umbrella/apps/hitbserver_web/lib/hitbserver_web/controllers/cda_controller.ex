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

  def index(conn, _params) do
    %{"filename" => filename, "username" => username} = Map.merge(%{"filename" => "", "username" => ""}, conn.params)
    [cda, info] = CdaService.cda_file(filename, username)
    json conn, %{cda: cda, info: info}
  end
  def update(conn, _params) do
    %{"content" => content, "doctype" => doctype, "file_name" => file_name, "header" => header, "id" => id, "save_type" => save_type,  "username"  => username, "mouldtype" => mouldtype} = Map.merge(%{"content" => "", "doctype" => "" , "file_name" => "", "header" => %{
      "上传时间" => "",
      "下载时间" => "",
      "保存时间" => "",
      "修改时间" => "",
      "创建时间" => "",
      "发布时间" => "",
      "标题" => "",
      "病人" => "",
      "缓存时间" => ""
      }, "id" => "", "save_type" => 1, "mouldtype" => ""}, conn.params)
    result = CdaService.update(id, content, file_name, username, doctype, header, save_type, mouldtype)
    json conn, result
  end
  def cdh_control(conn, _params) do
    %{"key" => key, "value" => value, "username" => username} = Map.merge(%{"key" => "", "value" => "", "username" => ""}, conn.params)
    result = CdaService.cdh_control(key, value, username)
    json conn, result
  end
end
