defmodule HitbserverWeb.PageController do
  use HitbserverWeb, :controller
  alias Server.UserService
  alias Server.UploadService
  plug HitbserverWeb.Access
  import Ecto.Query

  def index(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(user)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "index.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def test(conn, _params) do
    Hitb.Repo.all(from p in Hitb.Edit.Cda)
    |>Enum.map(fn x ->
        inserted_at = Hitb.Time.stime_ecto(x.inserted_at)
        updated_at = Hitb.Time.stime_ecto(x.updated_at)
        str = "创建时间:#{inserted_at};保存时间:#{updated_at};创建用户:#{x.username};修改用户:#{x.username};标题:;姓名:,#{x.content}"
        x
        |>Hitb.Edit.Cda.changeset(%{content: str})
        |>Hitb.Repo.update
    end)


    json conn, %{}
  end



  def chat(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(user)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "chat_test.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def login_html(conn, _params)do
    user = get_session(conn, :user)
    user = UserService.user_info(user)
    render conn, "login.html", user: user
  end

  def login(conn, %{"user" => user}) do
    params = Poison.encode!(%{user: user})
    [conn, username, login] =
      case HTTPoison.request(:post, "http://127.0.0.1/servers/login/",
      params, [{"X-API-Key", "foobar"}, {"Content-Type", "application/json"}]) do
        {:ok, result} ->
          %{body: body} = result
          body = Poison.decode!(body)
          [put_session(conn, :user, %{id: body["id"], login: body["login"], username: body["username"], type: body["type"], key: body["key"]}), body["username"], body["login"]]
        {:error, _} ->
          [put_session(conn, :user, %{login: false, username: "", type: 2, key: []}), "", false]
      end
    json conn, %{login: login, username: username}
  end

  def logout(conn, _params) do
    user = UserService.logout()
    conn = put_session(conn, :user, user)
    redirect conn, to: "/hospitals/login"
  end

  def wt4_upload(conn, _params) do
    wt4s = UploadService.wt4_upload(conn)
    json conn, wt4s
  end

  def wt4_insert(conn, _params) do
    wt4s = UploadService.wt4_insert()
    json conn, wt4s
  end

  def share(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(user)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "share.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end
  def connect(conn, _params) do
    json conn, %{success: true}
  end
end
