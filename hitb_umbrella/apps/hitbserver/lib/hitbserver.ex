defmodule Hitbserver do
  @tab [:hitb_log, :postgresx, :json, :stat_drg, :my_user, :stat]
  def ets_new() do
    Enum.each(@tab, fn x -> ets_new(x) end)
  end

  def ets_insert(tab, key, value) do
    case tab in @tab do
      true -> :ets.insert(tab, {key, value})
      false -> false
    end
  end

  def ets_get(tab, key) do
    case tab in @tab do
      true ->
        val = :ets.lookup(tab, key)
        case val do
          [] -> nil
          _ ->
            [{_, i}] = val
            i
        end
      false -> nil
    end
  end

  defp ets_new(tab) do
    :ets.new(tab, [:named_table, :public])
  end
end
