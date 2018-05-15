defmodule Stat.Convert do
  def obj2list(obj, key) do
    obj
    |>Enum.map(fn x ->
        key
        |>Enum.map(fn x ->
            if(is_bitstring(x))do String.to_atom(x) else x end
          end)
        |>Enum.map(fn k ->
            v = Map.get(x, k)
            cond do
              is_nil(v) -> Stat.Rand.rand(k, nil)
              is_float(v) ->  Float.round(v, 4)
              is_integer(v) ->  Stat.Rand.rand(k, nil)
              true -> v
            end
        end)
    end)
  end
  def mm_time(time)do
    case length(String.split(time, "年")) do
      2 ->
        [year, last] = String.split(time, "年")
        year = String.to_integer(year)
        cond do
          String.contains? last, "季度" ->
            case last do
              "第一季度" -> "#{year-1}年第四季度"
              "第二季度" -> "#{year}年第一季度"
              "第三季度" -> "#{year}年第二季度"
              "第四季度" -> "#{year}年第三季度"
            end
          String.contains? last, "月" ->
            month = String.split(last, "月")|>List.first|>String.to_integer
            case month < 2 do
              true -> "#{year-1}年12月"
              false -> "#{year}年#{month-1}月"
            end
          true ->
            []
        end
      3 ->
        [year, last, _] = String.split(time, "年")
        case last do
          "上半" -> "#{year-1}年下半年"
          "下半" -> "#{year}年上半年"
        end
    end
  end

  def yy_time(time)do
    case length(String.split(time, "年")) do
      2 ->
        [year, last] = String.split(time, "年")
        "#{String.to_integer(year)-1}年#{last}"
      3 ->
        [year, last, _] = String.split(time, "年")
        "#{String.to_integer(year)-1}年#{last}年"
    end
  end
end
