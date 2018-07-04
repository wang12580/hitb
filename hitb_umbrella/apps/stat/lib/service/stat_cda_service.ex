defmodule Stat.StatCdaService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Stat.StatCda
  alias Hitb.Edit.Cda

  def get_stat_cda(item) do
    cda_info = String.split(item, ",")
    |>Enum.reject(fn x -> x == "" end)

    query = from(p in StatCda)
    Enum.reduce(cda_info, query, fn x, acc ->
      x = "%#{x}%"
      acc
      |>or_where([p],  like(p.items, ^x))
    end)
    |>select([p], p.patient_id)
    |>Repo.all
    |>List.flatten
    |>:lists.usort
    |>Enum.map(fn x -> Repo.all(from p in Cda, where: p.patient_id == ^x) end)
  end

  def comp() do
    stat_cda =
      Repo.all(from p in StatCda)
      |>Enum.reduce(%{}, fn x, acc ->
          Map.put(acc, x.items, x)
        end)
    items = Repo.all(from p in StatCda, select: p.items)|>List.flatten
    new_cdas = generate()
    Enum.each(new_cdas, fn x ->
      cond do
        x.items in items ->
          if(Map.get(stat_cda, x.items).patient_id != x.patient_id)do
            Map.get(stat_cda, x.items)
            |>StatCda.changeset(x)
            |>Repo.update
          end
        true ->
          %StatCda{}
          |>StatCda.changeset(x)
          |>Repo.insert
      end
    end)
  end


  def init_comp() do
    generate()
    |>Enum.map(fn x ->
        %StatCda{}
        |>StatCda.changeset(x)
        |>Repo.insert
      end)
  end

  defp generate() do
    cdas = Repo.all(from p in Cda)
    |>Enum.reduce(%{}, fn x, acc ->
        content = String.split(x.content, ",")
        content
        |>Enum.map(fn x-> String.split(x, " ")|>List.last end)
        |>Enum.map(fn x ->
            x = Regex.replace(~r/；/, x, " ")
            x = Regex.replace(~r/、/, x, " ")
            x = Regex.replace(~r/，/, x, " ")
            x = Regex.replace(~r/。/, x, " ")
            x = Regex.replace(~r/”/, x, " ")
            x = Regex.replace(~r/“/, x, " ")
            cond do
              String.contains? x, " " -> String.split(x, " ")
              true -> x
            end
          end)
        |>List.flatten
        |>Enum.reject(fn x -> reject(x) end)
        |>Enum.reduce(acc, fn key, acc2 ->
            val = Map.get(acc2, key)
            case val do
              nil -> Map.put(acc2, key, %{patient_id: [x.patient_id]})
              _ -> %{acc2 | key => %{patient_id: (val.patient_id ++ [x.patient_id])|>:lists.usort}}
            end
          end)
      end)
    Map.keys(cdas)
    |>Enum.map(fn key ->
        map = Map.get(cdas, key)
        %{items: key, patient_id: map.patient_id, num: length(map.patient_id)}
      end)
  end

  def reject(x) do
    cond do
      x == "" -> true
      String.contains? x, "邮政编码" -> true
      String.contains? x, "出生地" -> true
      String.contains? x, "省" -> true
      String.contains? x, "市" -> true
      String.contains? x, "县" -> true
      String.contains? x, "区" -> true
      String.contains? x, "街" -> true
      String.contains? x, "乡" -> true
      String.contains? x, "镇" -> true
      String.contains? x, "族" -> true
      String.contains? x, "国" -> true
      String.contains? x, "时间" -> true
      String.contains? x, "-" -> true
      String.contains? x, "岁" -> true
      String.contains? x, "个人信息" -> true
      String.contains? x, ":" -> Enum.map(String.split(x, ":"), fn x -> is_num(x) end)|>Enum.all?
      String.contains? x, "：" -> Enum.map(String.split(x, "："), fn x -> is_num(x) end)|>Enum.all?
      x in ["有", "无"] -> true
      x in ["否", "是"] -> true
      x in ["男","女"] -> true
      x in ["已婚", "未婚", "离异"] -> true
      x == "配偶" -> true
      is_num(x) -> true
      true -> false
    end
  end

  defp is_num(x) do
    x2 =
      try do
        String.to_integer(x)
      rescue
        _ ->
          try do
            String.to_float(x)
          rescue
            _ -> x
          end
      end
    case x == x2 do
      true -> false
      false -> true
    end
  end

end
