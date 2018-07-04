defmodule HitbserverWeb.PageController do
  use HitbserverWeb, :controller
  alias Server.UserService
  alias Stat.StatCdaService
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
    IO.inspect StatCdaService.get_stat_cda("死亡")
    # Server.ShareService.share("cdh", "", "", [])
    # Hitb.Repo.all(from p in Hitb.Library.LibWt4, where: p.type != "病理诊断编码(M码)" and p.type != "街道乡镇代码" and p.type != "科别" and p.type != "行政区划" and p.type != "区县编码", select: p.type, group_by: p.type)|>List.flatten
    # |>Enum.map(fn x ->
    #     res = Hitb.Repo.all(from p in Hitb.Library.LibWt4, select: p.name, where: p.type == ^x)
    #     res = res
    #       |>Enum.map(fn x ->
    #           x = Regex.replace(~r/ /, x, "")
    #           x = Regex.replace(~r/ /, x, "")
    #         end)
    #     %Hitb.Library.Cdh{}
    #     |>Hitb.Library.Cdh.changeset(%{key: x, value: res|>Enum.join(" ")})
    #     |>Hitb.Repo.insert
    #   end)

    # city = Hitb.Province.county()
    # Hitb.Province.city()|>Map.values()|>List.flatten
    # |>Enum.map(fn x ->
    #   %Hitb.Library.Cdh{}
    #   |>Hitb.Library.Cdh.changeset(%{key: x, value: Map.get(city, x)|>Enum.join(" ")})
    #   |>Hitb.Repo.insert
    #
    #  end)


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
