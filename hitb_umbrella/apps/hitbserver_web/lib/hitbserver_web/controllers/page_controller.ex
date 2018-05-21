defmodule HitbserverWeb.PageController do
  use HitbserverWeb, :controller
  alias HitbserverWeb.MyUser

  def index(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "index.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def chat(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "chat_test.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def login_html(conn, _params)do
    user = MyUser.user_info(conn)
    render conn, "login.html", user: user
  end

  def login(conn, %{"user" => user}) do
    params = Poison.encode!(%{user: user})
    [conn, username, login] =
      case HTTPoison.request(:post, "http://127.0.0.1:8040/login/",
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
    conn = MyUser.logout(conn)
    redirect conn, to: "/hospitals/login"
  end



end
