defmodule Stat.StatCdaService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Stat.StatCda
  alias Hitb.Edit.Cda

  def get_stat_cda(item) do
    #查询条件整理
    cda_info = String.split(item, ",")
    |>Enum.reject(fn x -> x == "" end)
    #通过查询条件查询符合的病案
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
    |>Enum.map(fn x -> Repo.get!(Cda, String.to_integer(x)) end)
    |>List.flatten
    |>Enum.map(fn x -> x.content end)
  end

  def comp() do
    #查询所有的已经分析过的病案数据,并保存为%{记录itmes: 记录, 记录2itmes: 记录2}的格式
    stat_cda =
      Repo.all(from p in StatCda)
      |>Enum.reduce(%{}, fn x, acc ->
          Map.put(acc, x.items, x)
        end)
    #查询所有计算过的items
    items = Repo.all(from p in StatCda, select: p.items)|>List.flatten
    #根据病案数据生成新的窄表
    new_cdas = generate()
    Enum.each(new_cdas, fn x ->
      cond do
        x.items in items ->
          #已经存在的并且病案id不同的做更新
          if(Map.get(stat_cda, x.items).patient_id != x.patient_id)do
            Map.get(stat_cda, x.items)
            |>StatCda.changeset(x)
            |>Repo.update
          end
        true ->
          #不存在的做插入处理
          %StatCda{}
          |>StatCda.changeset(x)
          |>Repo.insert
      end
    end)
    :ok
  end

  #初始化计算
  def init_comp() do
    Repo.delete_all(from p in StatCda)
    generate()
    |>Enum.each(fn x ->
        %StatCda{}
        |>StatCda.changeset(x)
        |>Repo.insert
      end)
    :ok
  end

  defp generate() do
    cdas = Repo.all(from p in Cda)
    |>Enum.reduce(%{}, fn x, acc ->
        #切分病案文档
        content = String.split(x.content, ",")
        content
        |>Enum.map(fn x-> String.split(x, " ")|>List.last end)
        |>Enum.map(fn x ->
            #去除无用标点符号
            x = Regex.replace(~r/；/, x, " ")
            x = Regex.replace(~r/、/, x, " ")
            x = Regex.replace(~r/\//, x, " ")
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
          #把相同key的放在一起作为map的key,整理patient_id
            val = Map.get(acc2, key)
            case val do
              nil -> Map.put(acc2, key, %{patient_id: [x.patient_id]})
              _ -> %{acc2 | key => %{patient_id: (val.patient_id ++ [x.patient_id])|>:lists.usort}}
            end
          end)
      end)
    #将%{itme: %{patient_id: []}, ...}转换为[%{items: "", patient_id: [], num: 0}]格式
    Map.keys(cdas)
    |>Enum.map(fn key ->
        map = Map.get(cdas, key)
        %{items: key, patient_id: map.patient_id, num: length(map.patient_id)}
      end)
  end

  #去除含有无用信息item
  defp reject(x) do
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
  #判断字符串是否是纯数字的字符串
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
