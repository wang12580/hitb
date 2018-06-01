defmodule Block.OtherSyncService do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Edit.Cda
  alias Block.Library.RuleAdrg
  alias Block.Library.ChineseMedicinePatent
  alias Block.Library.ChineseMedicine
  alias Block.Library.RuleDrg
  alias Block.Library.RuleIcd9
  alias Block.Library.RuleIcd10
  alias Block.Library.RuleMdc
  alias Block.Library.LibWt4
  alias Block.Library.Wt4

  def get_latest_cda_hash do
    Repo.all(from p in Cda, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_ruleadrg_hash do
    Repo.all(from p in RuleAdrg, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_cmp_hash do
    Repo.all(from p in ChineseMedicinePatent, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_cm_hash do
    Repo.all(from p in ChineseMedicine, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_ruledrg_hash do
    Repo.all(from p in RuleDrg, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_ruleicd9_hash do
    Repo.all(from p in RuleIcd9, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_ruleicd10_hash do
    Repo.all(from p in RuleIcd10, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_rulemdc_hash do
    Repo.all(from p in RuleMdc, select: p.hash)
  end

  def get_latest_libwt4_hash do
    Repo.all(from p in LibWt4, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_latest_wt4_hash do
    Repo.all(from p in Wt4, select: p.hash, order_by: [desc: p.inserted_at], limit: 1)|>List.first
  end

  def get_rulemdc(hash) do
    case hash do
      nil -> Repo.all(RuleMdc)|>Enum.map(fn x -> Map.drop(x, [:__meta__, :__struct__, :id]) end)
      _ ->
        Repo.all(RuleMdc)
        |>Enum.reject(fn x -> x in hash end)
        |>Enum.map(fn x -> Map.drop(x, [:__meta__, :__struct__, :id]) end)
        # mdc = Repo.get_by(RuleMdc, hash: hash).inserted_at
        # Repo.all(from p in RuleMdc, where: p.inserted_at > ^inserted_at)|>Enum.map(fn x -> Map.drop(x, [:__meta__, :__struct__, :id]) end)
    end

  end

end
