defmodule EditWeb.CdaController do
  use EditWeb, :controller

  alias Edit.Client
  alias Edit.Client.Cda
  plug EditWeb.Access

  def cda_user(conn, _params) do
    # %{"type" => type} = Map.merge(%{"type" => "user"}, conn.params)
    cda = Client.list_cda("user", "")
    json conn, cda
  end

  def cda_file(conn, _params) do
    %{"username" => username} = Map.merge(%{"username" => ""}, conn.params)
    cda = Client.list_cda("file", username)
    json conn, cda
  end

  def index(conn, _params) do
    %{"filename" => filename, "username" => username} = Map.merge(%{"filename" => "", "username" => ""}, conn.params)
    cda = Client.list_cda("filename", {filename, username})
    json conn, cda
  end

  def update(conn, %{"content" => content, "file_name" => file_name, "username" => username}) do
    file_name =
      if(String.contains? file_name, username <> "-")do
        List.last(String.split(file_name, username <> "-"))
      else
        file_name
      end
    cda = Repo.get_by(Cda, name: file_name, username: username)
    case cda do
      nil -> json conn, %{success: false, info: "没有操作权限"}
      _ ->
        cda
        |>Cda.changeset(%{content: content})
        |>Repo.update
        json conn, %{success: true, info: "保存成功"}
    end
  end
end
