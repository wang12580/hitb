defmodule LibraryWeb.PageController do
  use LibraryWeb, :controller
  plug LibraryWeb.Access
  # alias Library.ChineseMedicine
  alias Library.ChineseMedicinePatent

  def index(conn, _params) do
    render conn, "index.html"
  end

  def server_rule(conn, _params) do
    %{"table" => table, "code" => code} = Map.merge(%{"table" => "mdc", "code" => ""}, conn.params)
    result =
      case table do
        "mdc" ->
          Repo.all(from p in Library.Mdc)
        "adrg" ->
          case code do
            "" -> Repo.all(from p in Library.Adrg)
            _ -> Repo.all(from p in Library.Adrg, where: p.mdc == ^code)
          end
        "drg" ->
          case code do
            "" -> Repo.all(Library.Drg)
            _ -> Repo.all(from p in Library.Drg, where: p.adrg == ^code or p.code == ^code)
          end
      end
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
      |>Map.put(:table, table)
    end)
    json conn, %{data: result}
  end

end
