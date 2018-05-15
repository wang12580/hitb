defmodule ServerWeb.UserController do
  use ServerWeb, :controller
  plug ServerWeb.Access

  alias ServerWeb.MyUser
  alias Server.User
  alias ServerWeb.SchemaHospitals

  action_fallback ServerWeb.FallbackController

  def login(conn, %{"user" => user}) do
    %{"username" => username, "password" => password, "address" => address, "privateKey" => privateKey, "publicKey" => publicKey, "secret" => secret} = Map.merge(%{"address" => "", "privateKey" => "", "publicKey" => "", "secret" => ""}, user)
    {conn, login} = MyUser.login(conn, %{username: username, password: password}, %{publicKey: publicKey, privateKey: privateKey, address: address, secret: secret})
    user =
      case login do
        true -> get_session(conn, :user)
        false -> %{}
      end
    json conn, Map.merge(%{login: login, username: username}, user)
  end


  def index(conn, _params) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    skip = Hitbserver.Page.skip(page, 15)
    [count, user] = SchemaHospitals.list_user(skip, 15)
    [page_num, page_list, _] = Hitbserver.Page.page_list(page, count, 15)
    user = Enum.map(user, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)

    # user = SchemaHospitals.list_user(1,15)
    render(conn, "index.json", user: user, page_num: page_num, page_list: page_list)
  end

  def create(conn, %{"user" => user_params}) do
    case SchemaHospitals.create_user(user_params)  do
      {:ok, user} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json", user: user, success: true)
      {:error, user} ->
        user = Map.merge(%User{id: -1}, user.changes)
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user, success: false)
    end
  end

  def show(conn, %{"id" => id}) do
    user = SchemaHospitals.get_user!(id)
    render(conn, "show.json", user: user, success: true)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = SchemaHospitals.get_user!(id)
    case SchemaHospitals.update_user(user, user_params) do
      {:ok, user} ->
          conn
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json", user: user, success: true)
      {:error, user} ->
        user = Map.merge(%User{id: -1}, user.changes)
        conn
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user, success: false)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = SchemaHospitals.get_user!(id)
    with {:ok, %User{}} <- SchemaHospitals.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
