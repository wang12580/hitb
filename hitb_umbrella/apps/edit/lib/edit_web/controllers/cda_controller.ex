defmodule EditWeb.CdaController do
  use EditWeb, :controller

  alias Edit.Client
  alias Edit.Client.Cda
  alias Hitb.Time
  plug EditWeb.Access

  def cda_user(conn, _params) do
    # %{"type" => type} = Map.merge(%{"type" => "user"}, conn.params)
    [cda, info] = Client.list_cda("user", "")
    json conn, %{cda: cda, info: info}
  end

  def cda_file(conn, _params) do
    %{"username" => username} = Map.merge(%{"username" => ""}, conn.params)
    [cda, info] = Client.list_cda("file", username)
    json conn, %{cda: cda, info: info}
  end

  def index(conn, _params) do
    %{"filename" => filename, "username" => username} = Map.merge(%{"filename" => "", "username" => ""}, conn.params)
    [cda, info] = Client.list_cda("filename", {filename, username})
    json conn, %{cda: cda, info: info}
  end

  def update(conn, %{"content" => content, "file_name" => file_name, "username" => username, "doctype" => doctype}) do
    IO.inspect (String.contains? file_name, "-")
    {file_username, file_name} =
      if(String.contains? file_name, "-")do
        List.to_tuple(String.split(file_name, "-"))
      else
        {username, file_name}
      end
    cda = Repo.get_by(Cda, name: file_name, username: file_username)
    if(cda)do
      cond do
        username == file_username ->
          cda
          |>Cda.changeset(%{content: content})
          |>Repo.update
          json conn, %{success: true, info: "保存成功"}
        true ->
          case cda.is_change do
            false -> json conn, %{success: false, info: "用户设置该文件不允许其他用户修改,请联系该文件拥有者"}
            true ->
              cda
              |>Cda.changeset(%{content: content})
              |>Repo.update
              json conn, %{success: true, info: "保存成功"}
          end
      end
    else
      namea = doctype <>"_"<>Time.stime_number<>".cda"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => false, "is_show" => true}
      %Cda{}
      |> Cda.changeset(body)
      |> Repo.insert()
      json conn, %{success: false, info: "新建成功"}
    end
  end
end
