defmodule Library.Rule do
  use GenServer
  # use CndrgWeb, :controller
  alias Library.Repo
  import Ecto.Query
  alias Library.Mdc
  alias Library.Adrg
  alias Library.Drg
  alias Library.Icd10
  alias Library.Icd9
  alias Library.RuleMdc
  alias Library.RuleAdrg
  alias Library.RuleDrg
  alias Library.RuleIcd10
  alias Library.RuleIcd9
  alias Library.DrgRate

  @doc """
  Starts the registry.
  """
  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Rule, timeout: 15000000)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, year) do
    GenServer.call(server, {:lookup, year})
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Server Callbacks

  def init(:ok) do
    # IO.puts "======CN-DRG分组器!======"
    IO.puts "======分组器规则读取!======"
    rule()
    IO.puts "======分组器规则读取完成!======"
    # {:ok, HashDict.new}
    {:ok, Map.new}
  end

  def handle_call({:lookup, year}, _from, names) do
    rule()
    {:reply, Map.fetch(names, year), names}
  end

  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:noreply, Map.put(names, name, "bucket")}
    end
  end

  defp rule() do
    #读取mdc表并转换为atom字段存入缓存
    from(p in Mdc)
    |>Repo.all
    |>Enum.each(fn x ->
        #修正P组的结果
        adrgs =
          case x.mdc do
            "P" -> Repo.all(from p in Adrg, where: p.mdc == "P", select: p.code)
            _ -> []
          end
        Hitbserver.ets_insert(:mdc_cn, x.mdc, Map.merge(x, %{adrgs: adrgs}))
      end)
    #读取adrg表并转换为atom字段存入缓存
    from(p in Adrg)
    |>Repo.all
    |>Enum.each(fn x ->
        Hitbserver.ets_insert(:adrg_cn, x.code, %{x | :sf0100 => s2i(x.sf0100), :sf0102 => s2i(x.sf0102)})
      end)

    #读取drg表并转换为atom字段存入缓存
    from(p in Drg)
    |>Repo.all
    |>Enum.each(fn x ->
        Hitbserver.ets_insert(:drg_cn, x.code, %{x | :age => s2i(x.age), :sf0108 => s2i(x.sf0108), :day => s2i(x.day)})
      end)

    #读取icd10表并转换为atom字段存入缓存
    from(p in Icd10)
    |>Repo.all
    |>Enum.each(fn x ->
        Hitbserver.ets_insert(:icd10_cn, x.name, x)
      end)

    #读取icd9表并转换为atom字段存入缓存
    from(p in Icd9)
    |>Repo.all
    |>Enum.each(fn x ->
        Hitbserver.ets_insert(:icd9_cn, x.name, x)
      end)

    #DrgRate
    from(p in DrgRate)
    |>Repo.all
    |>Enum.each(fn x ->
        key = if(x.name)do x.drg <> "_" <> x.name else x.drg end
        Hitbserver.ets_insert(:drg_rate, key, x.rate)
      end)

    #其他版本
    #读取mdc表并转换为atom字段存入缓存
    from(p in RuleMdc)
    |>where([p], p.year == "2017")
    |>where([p], p.version != "CN")
    |>where([p], p.version != "TEST")
    |>where([p], p.version != "CC")
    |>select([p], %{mdc: p.mdc, code: p.code, name: p.name, icd9_a: p.icd9_a, version: p.version})
    |>Repo.all
    |>Enum.each(fn x ->
        case x.version do
          "BJ" -> Hitbserver.ets_insert(:mdc_bj, x.mdc, x)
          "GB" -> Hitbserver.ets_insert(:mdc_gb, x.mdc, x)
        end
      end)
    #读取adrg表并转换为atom字段存入缓存
    from(p in RuleAdrg)
    |>where([p], p.year == "2017")
    |>where([p], p.version != "CN")
    |>where([p], p.version != "TEST")
    |>where([p], p.version != "CC")
    |>select([p], %{code: p.code, name: p.name, drgs_1: p.drgs_1, mdc: p.mdc, icd10_a: p.icd10_a, icd10_b: p.icd10_b, icd9_a: p.icd9_a, icd9_b: p.icd9_b, version: p.version})
    |>Repo.all
    |>Enum.each(fn x ->
        case x.version do
          "BJ" -> Hitbserver.ets_insert(:adrg_bj, x.code, x)
          "GB" -> Hitbserver.ets_insert(:adrg_gb, x.code, x)
        end
      end)

    #读取drg表并转换为atom字段存入缓存
    from(p in RuleDrg)
    |>where([p], p.year == "2017")
    |>where([p], p.version != "CN")
    |>where([p], p.version != "TEST")
    |>where([p], p.version != "CC")
    |>select([p], %{code: p.code, adrg: p.adrg, version: p.version})
    |>Repo.all
    |>Enum.each(fn x ->
        case x.version do
          "BJ" -> Hitbserver.ets_insert(:drg_bj, x.code, x)
          "GB" -> Hitbserver.ets_insert(:drg_gb, x.code, x)
        end
      end)

    #读取icd10表并转换为atom字段存入缓存
    from(p in RuleIcd10)
    |>where([p], p.year == "2017")
    |>where([p], p.version != "CN")
    |>where([p], p.version != "TEST")
    |>where([p], p.version != "CC")
    |>select([p], %{code: p.code, name: p.name, adrg: p.adrg, mcc: p.mcc, cc: p.cc, nocc_a: p.nocc_a, version: p.version})
    |>Repo.all
    |>Enum.each(fn x ->
        case x.version do
          "BJ" -> Hitbserver.ets_insert(:icd10_bj, x.code, x)
          "GB" -> Hitbserver.ets_insert(:icd10_gb, x.code, x)
        end
      end)

    #读取icd9表并转换为atom字段存入缓存
    from(p in RuleIcd9)
    |>where([p], p.year == "2017")
    |>where([p], p.version != "CN")
    |>where([p], p.version != "TEST")
    |>where([p], p.version != "CC")
    |>select([p], %{code: p.code, name: p.name, adrg: p.adrg, p_type: p.p_type, version: p.version})
    |>Repo.all
    |>Enum.each(fn x ->
        case x.version do
          "BJ" -> Hitbserver.ets_insert(:icd9_bj, x.code, x)
          "GB" -> Hitbserver.ets_insert(:icd9_gb, x.code, x)
        end
      end)

  #   # wt4_count = hd(Repo.all(from p in Wt2016, select: count(p.id)))
  #   # from(p in Wt2016)
  #   # |>group_by([p], p.drg)
  #   # |>select([p], %{drg: p.drg, num: count(p.id)})
  #   # |>Repo.all
  #   # |>Enum.each(fn x ->
  #   #     Hitbserver.ets_insert(:hitb_rate, x.drg, x.num/wt4_count)
  #   #   end)
  end


  def s2i(list) do
    case list do
      [] -> []
      nil -> []
      _ ->
        Enum.map(list, fn x ->
          case x do
            nil -> nil
            _ -> String.to_integer(x)
          end
        end)
    end
  end
end
