defmodule Stat.CompService do
  import Ecto.Query, warn: false
  alias Stat.Key
  alias Hitb.Stat.StatFile
  alias Hitb.Repo

  def target1()do
    Repo.all(from p in StatFile, select: fragment("array_agg(distinct ?)", p.second_menu))|>List.flatten
  end

  def target(file) do
    target =
      Enum.reduce(target1(), %{}, fn x, acc ->
        val = Repo.all(from p in StatFile, where: p.second_menu == ^x, select: fragment("array_agg(distinct ?)", p.file_name))|>List.flatten
        Map.put(acc, x, val)
      end)

    index = Map.get(target, file)
      |>Enum.map(fn x ->
          Repo.get_by(StatFile, file_name: x).page_type
        end)
    index = index
      |>Enum.map(fn x ->
          case Key.tool(x) do
            [] -> Key.key("", "", "", "", x)
            _ ->
              Key.tool(x)
              |>Enum.map(fn x -> x.en end)
              |>Enum.map(fn x2 -> Key.key("", "", "", x2, x) end)
          end
        end)
      |>List.flatten|>List.delete("org")|>List.delete("time")|>:lists.usort
      |>Enum.map(fn x -> Key.cnkey(x) end)
    %{index: index, dimension: ["时间", "机构", "病种"]}
  end
end
