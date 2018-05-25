defmodule Library.ServerRuleService do
  import Ecto
  import Ecto.Query
  alias Hitb.Repo

  def server_rule(table, code) do
    result =
      case table do
        "mdc" ->
          Repo.all(from p in Hitb.Library.Mdc)
        "adrg" ->
          case code do
            "" -> Repo.all(from p in Hitb.Library.Adrg)
            _ -> Repo.all(from p in Hitb.Library.Adrg, where: p.mdc == ^code)
          end
        "drg" ->
          case code do
            "" -> Repo.all(Hitb.Library.Drg)
            _ -> Repo.all(from p in Hitb.Library.Drg, where: p.adrg == ^code or p.code == ^code)
          end
      end
    Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
      |>Map.put(:table, table)
    end)
  end
end
