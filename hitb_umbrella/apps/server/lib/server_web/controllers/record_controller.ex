defmodule ServerWeb.RecordController do
  use ServerWeb, :controller

  alias ServerWeb.SchemaHospitals
  alias Server.Record
  plug ServerWeb.Access

  action_fallback ServerWeb.FallbackController

  def index(conn, %{"page"=> page}) do
    skip = Hitbserver.Page.skip(page, 15)
    record = SchemaHospitals.list_record(skip, 15)
    {count, record} = record
    {page_num, page_list, _} = Hitbserver.Page.page_list(page, count, 15)
    record = Enum.map(record, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    render(conn, "index.json", record: record, page_num: page_num, page_list: page_list)
  end

  def create(conn, %{"record" => record_params}) do
    with {:ok, %Record{} = record} <- SchemaHospitals.create_record(record_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", record_path(conn, :show, record))
      |> render("show.json", record: record)
    end
  end

  def show(conn, %{"id" => id}) do
    record = SchemaHospitals.get_record!(id)
    render(conn, "show.json", record: record)
  end

  # def update(conn, %{"id" => id, "record" => record_params}) do
  #   record = SchemaHospitals.get_record!(id)
  #   with {:ok, %Record{} = record} <- SchemaHospitals.update_record(record, record_params) do
  #     render(conn, "show.json", record: record)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    record = SchemaHospitals.get_record!(id)
    with {:ok, %Record{}} <- SchemaHospitals.delete_record(record) do
      send_resp(conn, :no_content, "")
    end
  end
end
