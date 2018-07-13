defmodule Server.ShareService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Time
  alias Hitb.Repo

  alias Block.BlockService
  alias Block.AccountService
  alias Block.LibraryService
  alias Block.EditService
  alias Block.StatService

  alias Hitb.Edit.Cda
  alias Hitb.Library.Cdh
  alias Hitb.Stat.StatOrg
  alias Hitb.Stat.StatFile
  alias Hitb.Library.RuleMdc
  alias Hitb.Library.RuleAdrg
  alias Hitb.Library.RuleDrg
  alias Hitb.Library.RuleIcd9
  alias Hitb.Library.RuleIcd10
  alias Hitb.Library.LibWt4
  alias Hitb.Library.ChineseMedicinePatent
  alias Hitb.Library.ChineseMedicine
  alias Hitb.Server.User
  alias Library.RuleService

  def share(type, file_name, username, content) do
    content =
      case content do
        "" -> content
        [] ->  ""
        _ -> Poison.decode!(content)
      end
    latest =
      case type do
        "cdh" -> LibraryService.get_cdh()
        "edit" -> EditService.get_cda()
        "stat" -> StatService.get_stat()
        "library" ->
          case file_name do
            "mdc.csv" -> LibraryService.get_rulemdc()
            "adrg.csv" -> LibraryService.get_ruleadrg()
            "drg.csv" -> LibraryService.get_ruledrg()
            "icd9.csv" -> LibraryService.get_ruleicd9()
            "icd10.csv" -> LibraryService.get_ruleicd10()
            "中药.csv" -> LibraryService.get_chinese_medicine()
            "中成药.csv" -> LibraryService.get_chinese_medicine_patent()
            _ ->
              file_name2 = String.split(file_name, ".")|>List.first
              LibraryService.get_lib_wt4(file_name2)
          end
      end
    previous_hash =
      case latest do
        [] -> ""
        _ -> List.first(latest)|>Map.get(:hash)
      end
    data =
      case type do
        "cdh" ->
          Repo.all(from p in Cdh)
        "edit" ->
          [username, editName] = String.split(file_name, "-")
          edit = Repo.all(from p in Cda, where: p.name == ^editName and p.username == ^username)
          bloackCdaFile = EditService.get_cda_file(username, editName)
          if !bloackCdaFile do
            body = %{"username" => username, "filename" => editName}
            EditService.create_cda_file(body)
          end
          edit
        "stat" ->
          page_type = Repo.get_by(StatFile, file_name: "#{file_name}")
          if(StatService.get_stat_file(file_name) == nil)do
            StatService.create_stat_file(Map.drop(page_type, [:id, :__meta__, :__struct__]))
          end
          [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, 1, "org", "total", "", "", "", "org", "asc", page_type.page_type, 15, "download", "server")
          # content.
          cont = Enum.map(content, fn x ->
            x = String.split(x, ",")
            # %{org: Enum.at(x, 0), time: Enum.at(x, 1)}
            "#{Enum.at(x, 0)}-#{Enum.at(x, 1)}"
          end)
          Enum.reject(stat, fn x -> "#{x.org}-#{x.time}" not in cont end)
        "library" ->
          file_name2 = String.split(file_name, ".")|>List.first
          [library, _list, _count, _page_list,_page_num] = RuleService.clinet(1, "year", file_name2, "BJ", "", "", 0, "server")
          library
      end
    data =
      Enum.reduce(data, [[], previous_hash], fn x, acc ->
        [data, previous_hash] = acc
        hash =
          case type do
            "cdh" -> hash("#{x.content}#{x.name}#{x.type}")
            "edit" -> hash("#{x.name}#{x.content}")
            "stat" -> hash("#{x.org}#{x.time}#{x.org_type}#{x.time_type}")
            "library" ->
              cond do
                file_name in ["mdc.csv", "adrg.csv", "drg.csv", "icd9.csv", "icd10.csv"] ->
                  hash("#{x.code}#{x.name}#{x.version}#{x.year}#{x.org}#{x.plat}")
                true ->
                  hash("#{x.code}#{x.name}")
              end
          end
        x = Map.drop(x, [:id, :__meta__, :__struct__])
          |>Map.merge(%{hash: hash, previous_hash: previous_hash})
        [Enum.concat(data, [x]), hash]
      end)
      |>List.first
    user = Repo.get_by(User, username: username)
    if(user)do
      Enum.each(data, fn x ->
        case type do
          "cdh" -> LibraryService.create_cdh(x)
          "edit" -> EditService.create_cda(x)
          "stat" -> StatService.create_stat_org(x)
          "library" ->
            case file_name do
              "mdc.csv" -> LibraryService.create_rulemdc(x)
              "adrg.csv" -> LibraryService.create_ruleadrg(x)
              "drg.csv" -> LibraryService.create_ruledrg(x)
              "icd9.csv" -> LibraryService.create_ruleicd9(x)
              "icd10.csv" -> LibraryService.create_ruleicd10(x)
              "中药.csv" -> LibraryService.create_chinese_medicine(x)
              "中成药.csv" -> LibraryService.create_chinese_medicine_patent(x)
              _ -> LibraryService.create_libwt4(x)
            end
        end
      end)
      secret = AccountService.getAccountByAddress(user.block_address).username
      block = BlockService.create_next_block("#{type}-#{file_name}", secret)
      BlockService.add_block(block)
    end
    :ok
  end

  def get_share() do
    edit = EditService.get_cda_num()
    stat_org = StatService.get_stat_num()
    mdc = LibraryService.get_rulemdc_num()
    adrg = LibraryService.get_ruleadrg_num()
    drg = LibraryService.get_ruledrg_num()
    icd9 = LibraryService.get_ruleicd9_num()
    icd10 = LibraryService.get_ruleicd10_num()
    chinese_medicine = LibraryService.get_chinese_medicine_num()
    chinese_medicine_patent = LibraryService.get_chinese_medicine_patent_num()
    lib_wt4 = LibraryService.get_lib_wt4_num()
    last_edit =
      case edit do
        0 -> "-"
        _ -> EditService.get_cda|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_stat_org =
      case stat_org do
        0 -> "-"
        _ -> StatService.get_stat|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_mdc =
      case mdc do
        0 -> "-"
        _ -> LibraryService.get_rulemdc|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_adrg =
      case adrg do
        0 -> "-"
        _ -> LibraryService.get_ruleadrg|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_drg =
      case drg do
        0 -> "-"
        _ -> LibraryService.get_ruledrg|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_icd9 =
      case icd9 do
        0 -> "-"
        _ -> LibraryService.get_ruleicd9|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_icd10 =
      case icd10 do
        0 -> "-"
        _ -> LibraryService.get_ruleicd10|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_chinese_medicine =
      case chinese_medicine do
        0 -> "-"
        _ -> LibraryService.get_chinese_medicine|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_chinese_medicine_patent =
      case chinese_medicine_patent do
        0 -> "-"
        _ -> LibraryService.get_chinese_medicine_patent|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    last_lib_wt4 =
      case lib_wt4 do
        0 -> "-"
        _ -> LibraryService.get_last_lib_wt4|>Map.get(:inserted_at)|>List.first|>Time.stime_ecto
      end
    [%{key: "edit", val: edit, last: last_edit}, %{key: "stat_org", val: stat_org, last: last_stat_org}, %{key: "mdc", val: mdc, last: last_mdc}, %{key: "adrg", val: adrg, last: last_adrg}, %{key: "drg", val: drg, last: last_drg}, %{key: "icd9", val: icd9, last: last_icd9}, %{key: "icd10", val: icd10, last: last_icd10}, %{key: "chinese_medicine", val: chinese_medicine, last: last_chinese_medicine}, %{key: "chinese_medicine_patent", val: chinese_medicine_patent, last: last_chinese_medicine_patent}, %{key: "lib_wt4", val: lib_wt4, last: last_lib_wt4}]
  end

  def insert(table, _time) do
    hashs =
      cond do
        table == "edit" ->
          Repo.all(from p in Cda, select: %{name: p.name, content: p.content})
          |>Enum.map(fn x -> hash("#{x.name}#{x.content}") end)
        table == "stat_org" ->
          Repo.all(from p in StatOrg, select: %{org: p.org, time: p.time, org_type: p.org_type, time_type: p.time_type})
          |>Enum.map(fn x -> hash("#{x.org}#{x.time}#{x.org_type}#{x.time_type}") end)
        table in ["mdc", "adrg", "drg", "icd9", "icd10"] ->
          case table do
            "mdc" ->
              Repo.all(from p in RuleMdc, select: %{code: p.code, name: p.name, version: p.version, year: p.year, org: p.org, plat: p.plat})
            "adrg" ->
              Repo.all(from p in RuleAdrg, select: %{code: p.code, name: p.name, version: p.version, year: p.year, org: p.org, plat: p.plat})
            "drg" ->
              Repo.all(from p in RuleDrg, select: %{code: p.code, name: p.name, version: p.version, year: p.year, org: p.org, plat: p.plat})
            "icd9" ->
              Repo.all(from p in RuleIcd9, select: %{code: p.code, name: p.name, version: p.version, year: p.year, org: p.org, plat: p.plat})
            "icd10" ->
              Repo.all(from p in RuleIcd10, select: %{code: p.code, name: p.name, version: p.version, year: p.year, org: p.org, plat: p.plat})
          end
          |>Enum.map(fn x -> hash("#{x.code}#{x.name}#{x.version}#{x.year}#{x.org}#{x.plat}") end)
        table == "chinese_medicine" ->
          Repo.all(from p in ChineseMedicine, select: %{code: p.code, name: p.name})
          |>Enum.map(fn x -> hash("#{x.code}#{x.name}") end)
        table == "chinese_medicine_patent" ->
          Repo.all(from p in ChineseMedicinePatent, select: %{code: p.code, name: p.name})
          |>Enum.map(fn x -> hash("#{x.code}#{x.name}") end)
        true ->
          Repo.all(from p in LibWt4, select: %{code: p.code, name: p.name})
          |>Enum.map(fn x -> hash("#{x.code}#{x.name}") end)
      end
    data =
      case table do
        "edit" ->  EditService.get_cdas()
        "stat_org" -> StatService.get_stats()
        "mdc" -> LibraryService.get_rulemdcs()
        "adrg" -> LibraryService.get_ruleadrgs()
        "drg" -> LibraryService.get_ruledrgs()
        "icd9" -> LibraryService.get_ruleicd9s()
        "icd10" -> LibraryService.get_ruleicd10s()
        "chinese_medicine" -> LibraryService.get_chinese_medicines()
        "chinese_medicine_patent" -> LibraryService.get_chinese_medicine_patents()
        "lib_wt4" -> LibraryService.get_lib_wt4s()
      end
    data
    |>Enum.reject(fn x -> x.hash in hashs end)
    |>Enum.map(fn x ->
        x = Map.drop(x, [:id, :__meta__, :__struct__])
        case table do
          "edit" -> %Cda{}|>Cda.changeset(x)
          "stat_org" -> %StatOrg{}|>StatOrg.changeset(x)
          "mdc" -> %RuleMdc{}|>RuleMdc.changeset(x)
          "adrg" -> %RuleAdrg{}|>RuleAdrg.changeset(x)
          "drg" -> %RuleDrg{}|>RuleDrg.changeset(x)
          "icd9" -> %RuleIcd9{}|>RuleIcd9.changeset(x)
          "icd10" -> %RuleIcd10{}|>RuleIcd10.changeset(x)
          "chinese_medicine" -> %ChineseMedicine{}|>ChineseMedicine.changeset(x)
          "chinese_medicine_patent" -> %ChineseMedicinePatent{}|>ChineseMedicinePatent.changeset(x)
          "lib_wt4" -> %LibWt4{}|>LibWt4.changeset(x)
        end
        |>Repo.insert
      end)
  end

  defp hash(s) do
    s = :crypto.hash(:sha256, s)
    |> Base.encode64

    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end

end
