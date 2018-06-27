defmodule HitbserverWeb.UserController do
  use HitbserverWeb, :controller
  plug HitbserverWeb.Access
  alias Hitb.Server.User
  alias Server.UserService

  action_fallback HitbserverWeb.FallbackController

  def index(conn, _params) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    [count, user] = UserService.list_user(page, 15)
    [page_num, page_list, _count] = Hitb.Page.page_list(page, count, 15)
    render(conn, "index.json", user: user, page_num: page_num, page_list: page_list)
  end

  def create(conn, %{"user" => user_params}) do
    case UserService.create_user(user_params)  do
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
    user = UserService.get_user!(id)
    render(conn, "show.json", user: user, success: true)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case UserService.update_user(id, user_params) do
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
    with {:ok, %User{}} <- UserService.delete_user(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
