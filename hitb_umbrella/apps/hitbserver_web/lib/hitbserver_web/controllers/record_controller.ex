defmodule HitbserverWeb.RecordController do
  use HitbserverWeb, :controller
  alias Server.RecordService
  alias Hitb.Server.Record
  plug HitbserverWeb.Access

  action_fallback HitbserverWeb.FallbackController

  def index(conn, %{"page"=> page}) do
    [count, record] = RecordService.list_record(page, 15)
    [page_num, page_list, _count] = Hitb.Page.page_list(page, count, 15)
    render(conn, "index.json", record: record, page_num: page_num, page_list: page_list)
  end

  def create(conn, %{"record" => record_params}) do
    with {:ok, %Record{} = record} <- RecordService.create_record(record_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", record_path(conn, :show, record))
      |> render("show.json", record: record)
    end
  end

  def show(conn, %{"id" => id}) do
    record = RecordService.get_record!(id)
    render(conn, "show.json", record: record)
  end

  # def update(conn, %{"id" => id, "record" => record_params}) do
  #   record = SchemaHospitals.get_record!(id)
  #   with {:ok, %Record{} = record} <- SchemaHospitals.update_record(record, record_params) do
  #     render(conn, "show.json", record: record)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Record{}} <- RecordService.delete_record(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
