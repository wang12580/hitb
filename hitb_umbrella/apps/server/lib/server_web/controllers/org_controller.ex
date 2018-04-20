defmodule ServerWeb.OrgController do
  use ServerWeb, :controller

  alias ServerWeb.SchemaHospitals
  alias Server.Org
  plug ServerWeb.Access
  # action_fallback ServerWeb.FallbackController
  def index(conn, _params) do
    %{"name" => name, "page" => page} = Map.merge(%{"name" => "", "page" => "1"}, conn.params)
    skip = Hitbserver.Page.skip(page, 15)
    {count, result} = SchemaHospitals.list_org(name, skip, 15)
    {page_num, page_list, _} = Hitbserver.Page.page_list(page, count, 15)
    render(conn, "index.json", %{org: result, page_num: page_num, page_list: page_list})
  end

  def create(conn, %{"org" => org_params}) do
    case SchemaHospitals.create_org(org_params)  do
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
    org = Repo.get!(Hospitals.Org, id)
    render(conn, "show.json", org: org)
  end

  def update(conn, %{"id" => id, "org" => org_params}) do
    db_org = SchemaHospitals.get_org!(id)
    case SchemaHospitals.update_org(db_org, org_params) do
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
    org = SchemaHospitals.get_org!(id)
    with {:ok, %Org{}} <- SchemaHospitals.delete_org(org) do
      # org
      # user = get_session(conn, :user)
      # record = %{type: "机构管理", mode: "删除", username: user.username, old_value: org.code <> ", " <> org.name}
      # SchemaHospitals.create_record(record)
      send_resp(conn, :no_content, "")
    end
  end

  defp mycase(val) do
    case to_string(val) do
      "true" -> "是"
      "false" -> "否"
      _ -> val
    end
  end
end
