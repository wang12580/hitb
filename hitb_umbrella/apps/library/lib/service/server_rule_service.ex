defmodule Library.ServerRuleService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Library.Mdc
  alias Hitb.Library.Adrg
  alias Hitb.Library.Drg

  def server_rule(table, code) do
    result =
      case table do
        "mdc" ->
          Repo.all(from p in Mdc)
        "adrg" ->
          case code do
            "" -> Repo.all(from p in Adrg)
            _ -> Repo.all(from p in Adrg, where: p.mdc == ^code)
          end
        "drg" ->
          case code do
            "" -> Repo.all(Drg)
            _ -> Repo.all(from p in Drg, where: p.adrg == ^code or p.code == ^code)
          end
      end
    Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
      |>Map.put(:table, table)
    end)
  end
end
