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
  alias Block.Stat.StatOrg

  def get_latest_cda_hash do
    Repo.all(from p in Cda, select: p.hash)
  end

  def get_latest_statorg_hash do
    Repo.all(from p in StatOrg, select: p.hash)
  end


  def get_latest_ruleadrg_hash do
    Repo.all(from p in RuleAdrg, select: p.hash)
  end

  def get_latest_cmp_hash do
    Repo.all(from p in ChineseMedicinePatent, select: p.hash)
  end

  def get_latest_cm_hash do
    Repo.all(from p in ChineseMedicine, select: p.hash)
  end

  def get_latest_ruledrg_hash do
    Repo.all(from p in RuleDrg, select: p.hash)
  end

  def get_latest_ruleicd9_hash do
    Repo.all(from p in RuleIcd9, select: p.hash)
  end

  def get_latest_ruleicd10_hash do
    Repo.all(from p in RuleIcd10, select: p.hash)
  end

  def get_latest_rulemdc_hash do
    Repo.all(from p in RuleMdc, select: p.hash)
  end

  def get_latest_libwt4_hash do
    Repo.all(from p in LibWt4, select: p.hash)
  end

  def get_latest_wt4_hash do
    Repo.all(from p in Wt4, select: p.hash)
  end

  def get_data(x, hash) do
    hash = if(hash == nil)do [] else hash end
    case x do
      "statorg_hash" -> Repo.all(StatOrg)
      "cda_hash" -> Repo.all(Cda)
      "ruleadrg_hash" -> Repo.all(RuleAdrg)
      "cmp_hash" -> Repo.all(ChineseMedicinePatent)
      "cm_hash" -> Repo.all(ChineseMedicine)
      "ruledrg_hash" -> Repo.all(RuleDrg)
      "ruleicd9_hash" -> Repo.all(RuleIcd9)
      "ruleicd10_hash" -> Repo.all(RuleIcd10)
      "rulemdc_hash" -> Repo.all(RuleMdc)
      "libwt4_hash" -> Repo.all(LibWt4)
      "wt4_hash" -> Repo.all(Wt4)
    end
    |>Enum.reject(fn x -> x.hash in hash end)
    |>Enum.map(fn x -> Map.drop(x, [:__meta__, :__struct__, :id]) end)
  end

end
