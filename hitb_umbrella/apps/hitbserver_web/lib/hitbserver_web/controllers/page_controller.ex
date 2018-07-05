defmodule HitbserverWeb.PageController do
  use HitbserverWeb, :controller
  import Ecto.Query
  alias Server.UserService
  alias Server.UploadService
  # alias Stat.StatCdaService
  plug HitbserverWeb.Access

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

    cda = Block.Repo.all(from p in Block.Edit.Cda)

    Enum.map(cda, fn x ->
      patient_id = Hitb.Repo.get_by(Hitb.Edit.Cda, name: x.name, username: x.username).patient_id
      x
      |>Block.Edit.Cda.changeset(%{patient_id: patient_id})
      |>Block.Repo.update
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
    %{"username" => username, "password" => password} = user
    [user, login] = UserService.login(%{username: username, password: password}, %{})
    conn =
      case login do
        false ->
          put_session(conn, :user, %{login: false, username: "", type: 2, key: []})
        true ->
          put_session(conn, :user, %{id: user.id, login: login, username: username, type: user.type, key: user.key})
      end
    json conn, %{login: true, username: username}
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
