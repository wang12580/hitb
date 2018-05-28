defmodule HitbserverWeb.OrgController do
  use HitbserverWeb, :controller
  alias Server.OrgService
  alias Hitb.Server.Org
  plug HitbserverWeb.Access
  action_fallback HitbserverWeb.FallbackController

  def index(conn, _params) do
    %{"name" => name, "page" => page} = Map.merge(%{"name" => "", "page" => "1"}, conn.params)
    result = OrgService.list_org(name, page, 15)
    render(conn, "index.json", result)
  end

  def create(conn, %{"org" => org_params}) do
    case OrgService.create_org(org_params)  do
      {:ok, org} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", org_path(conn, :show, org))
        |> render("show.json", org: org, success: true)
      {:error, org} ->
        org = Map.merge(%Org{id: -1}, org.changes)
        conn
        |> put_status(:created)
        |> put_resp_header("location", org_path(conn, :show, org))
        |> render("show.json", org: org, success: false)
    end
  end

  def show(conn, %{"id" => id}) do
    org = OrgService.get_org!(id)
    render(conn, "show.json", org: org, success: true)
  end

  def update(conn, %{"id" => id, "org" => org_params}) do
    case OrgService.update_org(id, org_params) do
      {:ok, org} ->
        conn
        |> put_resp_header("location", org_path(conn, :show, org))
        |> render("show.json", org: org, success: true)
      {:error, org} ->
        org = Map.merge(%Org{id: -1}, org.changes)
        conn
        |> put_resp_header("location", org_path(conn, :show, org))
        |> render("show.json", org: org, success: false)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Org{}} <- OrgService.delete_org(id) do
      # org
      # user = get_session(conn, :user)
      # record = %{type: "机构管理", mode: "删除", username: user.username, old_value: org.code <> ", " <> org.name}
      # SchemaHospitals.create_record(record)
      send_resp(conn, :no_content, "")
    end
  end
end
