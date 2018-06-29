defmodule HitbserverWeb.PageController do
  use HitbserverWeb, :controller
  alias Server.UserService
  alias Server.UploadService
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
    Enum.map(Hitb.Repo.all(from p in Hitb.Edit.Cda, where: p.username == "test@hitb.com.cn"), fn x ->
      IO.inspect x
    #   [date, time] = Hitb.Time.stime_ecto(x.inserted_at)|>String.split("　")
    #   date = String.split(date, "-")|>Enum.join("")
    #   time = String.split(time, ":")|>Enum.join("")
    #   if(x.patient_id === nil)do
      x = Map.drop(x, [:id, :__meta__, :__struct__])
      x = %{x | :username => "test@test.com.cn"}
        %Hitb.Edit.Cda{}
        |>Hitb.Edit.Cda.changeset(x)
        |>Hitb.Repo.insert
    #   end
    end)




    # Block.AutoSyncService.sync()


    # {:ok, pid} = Postgrex.start_link(hostname: "127.0.0.1", username: "postgres", password: "postgres", database: "drg_dev")
    # sql = "select code, name from icd10c;"
    # icd10 = Postgrex.query!(pid, sql, [], [timeout: 15000000]).rows
    # Enum.each(icd10, fn x ->
    #   [x, name] = x
    #   sql = "select name from rule_bj_icd10 where icdc = '#{x}';"
    #   a = Postgrex.query!(pid, sql, [], [timeout: 15000000]).rows|>List.flatten
    #   IO.inspect [name | a]
    # end)
    # IO.inspect Hitb.Repo.all(from p in Hitb.Library.RuleMdc, select: p.version, group_by: p.version)
    # names = Hitb.Repo.all(from p in Hitb.Library.RuleDrg, where: p.version == "CN", order_by: [asc: p.code], select: [p.name, p.code])
    # Enum.each(names, fn x ->
    #   x = x|>Enum.join(" ")
    #   body =%{ "type" => "CN", "name" => "DRG", "content" => x}
    #   %Cdh{}
    #   |> Cdh.changeset(body)
    #   |> Hitb.Repo.insert()
    # end)

    # content = ["ICD10"| names]|>Enum.join(" ")
    # body =%{ "type" => "CN", "name" => "ICD10", "content" => content}
    # %Cdh{}
    # |> Cdh.changeset(body)
    # |> Hitb.Repo.insert()
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
