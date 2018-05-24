defmodule LibraryWeb.PageController do
  use LibraryWeb, :controller
  plug LibraryWeb.Access
  alias Library.ChineseMedicine
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

  def test(conn, _params) do
    {:ok, str} = File.read("/home/hitb/桌面/未命名文件夹 2/中成药 (复件).csv")
    Enum.each(String.split(str, "\n") -- [""], fn x ->
      [code, medicine_type, type, medicine_code, name, other_spec, name_1, indicatorg_limition, department_limit, user_limit, other_limit ]= String.split(x, ",")
      rule = %{"code" => code, "medicine_type" => medicine_type, "type" => type, "medicine_code" => medicine_code, "name" => name, "other_spec" => other_spec, "name_1" => name_1, "indicatorg_limition" => indicatorg_limition, "department_limit" => department_limit, "user_limit" => user_limit, "other_limit" => other_limit}
      %ChineseMedicinePatent{}
      |> ChineseMedicinePatent.changeset(rule)
      |> Repo.insert()
      # IO.inspect rule
    end)
    json conn, %{}
  end




end
