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
end
