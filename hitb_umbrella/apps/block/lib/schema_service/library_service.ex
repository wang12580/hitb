defmodule Block.LibraryService do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Library.Cdh
  alias Block.Library.LibWt4
  alias Block.Library.RuleMdc
  alias Block.Library.RuleAdrg
  alias Block.Library.RuleDrg
  alias Block.Library.RuleIcd9
  alias Block.Library.RuleIcd10
  alias Block.Library.ChineseMedicine
  alias Block.Library.ChineseMedicinePatent


  def get_cdh() do
    Repo.all(from p in Cdh, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_rulemdc() do
    Repo.all(from p in RuleMdc, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_ruleadrg() do
    Repo.all(from p in RuleAdrg, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_ruledrg() do
    Repo.all(from p in RuleDrg, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_ruleicd9() do
    Repo.all(from p in RuleIcd9, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_ruleicd10() do
    Repo.all(from p in RuleIcd10, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_chinese_medicine() do
    Repo.all(from p in ChineseMedicine, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_chinese_medicine_patent() do
     Repo.all(from p in ChineseMedicinePatent, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_lib_wt4(file_name2) do
    Repo.all(from p in LibWt4, where: p.type == ^file_name2, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_rulemdcs() do
    Repo.all(from p in RuleMdc)
  end

  def get_ruleadrgs() do
    Repo.all(from p in RuleAdrg)
  end

  def get_ruledrgs() do
    Repo.all(from p in RuleDrg)
  end

  def get_ruleicd9s() do
    Repo.all(from p in RuleIcd9)
  end

  def get_ruleicd10s() do
    Repo.all(from p in RuleIcd10)
  end

  def get_chinese_medicines() do
    Repo.all(from p in ChineseMedicine)
  end

  def get_chinese_medicine_patents() do
    Repo.all(from p in ChineseMedicinePatent)
  end

  def get_lib_wt4s() do
    Repo.all(from p in LibWt4)
  end

  def get_last_lib_wt4() do
    Repo.all(from p in LibWt4, order_by: [desc: p.inserted_at], limit: 1)
  end

  def get_rulemdc_num() do
    Repo.all(from p in RuleMdc, select: count(p.id))|>List.first
  end

  def get_ruleadrg_num() do
    Repo.all(from p in RuleAdrg, select: count(p.id))|>List.first
  end

  def get_ruledrg_num() do
    Repo.all(from p in RuleDrg, select: count(p.id))|>List.first
  end

  def get_ruleicd9_num() do
    Repo.all(from p in RuleIcd9, select: count(p.id))|>List.first
  end

  def get_ruleicd10_num() do
    Repo.all(from p in RuleIcd10, select: count(p.id))|>List.first
  end

  def get_chinese_medicine_num() do
    Repo.all(from p in ChineseMedicine, select: count(p.id))|>List.first
  end

  def get_chinese_medicine_patent_num() do
     Repo.all(from p in ChineseMedicinePatent, select: count(p.id))|>List.first
  end

  def get_lib_wt4_num() do
    Repo.all(from p in LibWt4, select: count(p.id))|>List.first
  end

  def create_cdh(attr) do
    %Cdh{}
    |>Cdh.changeset(attr)
    |>Repo.insert
  end

  def create_rulemdc(attr) do
    %RuleMdc{}
    |>RuleMdc.changeset(attr)
    |>Repo.insert
  end

  def create_ruleadrg(attr) do
    %RuleAdrg{}
    |>RuleAdrg.changeset(attr)
    |>Repo.insert
  end

  def create_ruledrg(attr) do
    %RuleDrg{}
    |>RuleDrg.changeset(attr)
    |>Repo.insert
  end

  def create_ruleicd9(attr) do
    %RuleIcd9{}
    |>RuleIcd9.changeset(attr)
    |>Repo.insert
  end

  def create_ruleicd10(attr) do
    %RuleIcd10{}
    |>RuleIcd10.changeset(attr)
    |>Repo.insert
  end

  def create_chinese_medicine(attr) do
    %ChineseMedicine{}
    |>ChineseMedicine.changeset(attr)
    |>Repo.insert
  end

  def create_chinese_medicine_patent(attr) do
    %ChineseMedicinePatent{}
    |>ChineseMedicinePatent.changeset(attr)
    |>Repo.insert
  end

  def create_libwt4(attr) do
    %LibWt4{}
    |>LibWt4.changeset(attr)
    |>Repo.insert
  end

end
