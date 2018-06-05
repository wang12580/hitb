defmodule Server.ShareService do
  # import Ecto
  import Ecto.Query
  alias Stat.Query
  alias Hitb.Time
  alias Block.Repo, as: BlockRepo
  alias Hitb.Repo, as: HitbRepo
  alias Block.Edit.Cda, as: BlockCda
  alias Hitb.Edit.Cda, as: HitbCda
  alias Block.Stat.StatOrg, as: BlockStatOrg
  alias Hitb.Stat.StatOrg, as: HitbStatOrg
  alias Block.ShareRecord
  alias Block.Library.RuleMdc, as: BlockRuleMdc
  alias Hitb.Library.RuleMdc, as: HitbRuleMdc
  alias Library.RuleService
  alias Block.Library.RuleAdrg, as: BlockRuleAdrg
  alias Hitb.Library.RuleAdrg, as: HitbRuleAdrg
  alias Block.Library.RuleDrg, as: BlockRuleDrg
  alias Hitb.Library.RuleDrg, as: HitbRuleDrg
  alias Block.Library.RuleIcd9, as: BlockRuleIcd9
  alias Hitb.Library.RuleIcd9, as: HitbRuleIcd9
  alias Block.Library.RuleIcd10, as: BlockRuleIcd10
  alias Hitb.Library.RuleIcd10, as: HitbRuleIcd10
  alias Block.Library.LibWt4, as: BlockLibWt4
  alias Hitb.Library.LibWt4, as: HitbLibWt4
  alias Block.Library.ChineseMedicinePatent, as: BlockChineseMedicinePatent
  alias Block.Library.ChineseMedicine, as: BlockChineseMedicine
  alias Hitb.Library.ChineseMedicinePatent, as: HitbChineseMedicinePatent
  alias Hitb.Library.ChineseMedicine, as: HitbChineseMedicine



  def share(type, file_name, username, content) do
    content =
      case content do
        "" -> content
        [] ->  ""
        _ -> Poison.decode!(content)
      end
      case type do
        "edit" ->
          [_, editName] = String.split(file_name, "-")
          latest = BlockRepo.all(from p in BlockCda, order_by: [desc: p.inserted_at], limit: 1)
          previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
          cda = HitbRepo.all(from p in HitbCda, where: p.name == ^editName and p.username == ^username)
          Enum.reduce(cda, previous_hash, fn x, acc ->
            hash = hash("#{x.name}")
            %BlockCda{}
            |>BlockCda.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
            |>BlockRepo.insert
            hash
          end)
        "stat" ->
          content = Enum.map(content, fn x ->
              x = String.split(x, ",")
              "#{Enum.at(x, 0)}#{Enum.at(x, 1)}"
            end)
          latest = BlockRepo.all(from p in BlockStatOrg, order_by: [desc: p.inserted_at], limit: 1)
          hashs = BlockRepo.all(from p in BlockStatOrg, select: p.hash)
          previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "-" end
          [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, 1, "org", "", "", "", "", "org", "asc", Stat.page_en(file_name), 15, "download", "server")
          Enum.reject(stat, fn x -> "#{x.org}#{x.time}" not in content end)
          |>Enum.reduce(previous_hash, fn x, acc ->
              hash = hash("#{x.org}#{x.time}")
              if(hash not in hashs)do
                %BlockStatOrg{}
                |>BlockStatOrg.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              else
                acc
              end
            end)
          if(BlockRepo.get_by(ShareRecord, type: "stat", file_name: file_name) == nil)do
              %ShareRecord{}
              |>ShareRecord.changeset(%{username: username, file_name: file_name, datetime: Time.stime_local(), type: "stat"})
              |>BlockRepo.insert
          end
        "library" ->
          case file_name do
            "mdc.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockRuleMdc, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [mdc, _list, _count, _page_list,_page_num] = RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockRuleMdc{}
                |>BlockRuleMdc.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            "adrg.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockRuleAdrg, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [adrg, _list, _count, _page_list,_page_num] = RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(adrg, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockRuleAdrg{}
                |>BlockRuleAdrg.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            "drg.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockRuleDrg, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [drg, _list, _count, _page_list,_page_num] =  RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(drg, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockRuleDrg{}
                |>BlockRuleDrg.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            "icd9.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockRuleIcd9, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [icd9, _list, _count, _page_list,_page_num] = RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(icd9, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockRuleIcd9{}
                |>BlockRuleIcd9.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            "icd10.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockRuleIcd10, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [icd10, _list, _count, _page_list,_page_num] =  RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(icd10, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockRuleIcd10{}
                |>BlockRuleIcd10.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            "中药.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockChineseMedicine, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [mdc, _list, _count, _page_list,_page_num] =  RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockChineseMedicine{}
                |>BlockChineseMedicine.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            "中成药.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockChineseMedicinePatent, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              cmp = RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(cmp, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockChineseMedicinePatent{}
                |>BlockChineseMedicinePatent.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
            _ ->
              file_name = String.split(file_name, ".")|>List.first
              latest = BlockRepo.all(from p in BlockLibWt4, where: p.type == ^file_name, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              lib_wt4 = RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(lib_wt4, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %BlockLibWt4{}
                |>BlockLibWt4.changeset(Map.merge(Map.drop(x, [:id, :__meta__, :__struct__]), %{hash: hash, previous_hash: acc}))
                |>BlockRepo.insert
                hash
              end)
          end
      end
  end

  def get_share() do
    edit = BlockRepo.all(from p in BlockCda, select: count(p.id))|>List.first
    stat_org = BlockRepo.all(from p in BlockStatOrg, select: count(p.id))|>List.first
    mdc = BlockRepo.all(from p in BlockRuleMdc, select: count(p.id))|>List.first
    adrg = BlockRepo.all(from p in BlockRuleAdrg, select: count(p.id))|>List.first
    drg = BlockRepo.all(from p in BlockRuleDrg, select: count(p.id))|>List.first
    icd9 = BlockRepo.all(from p in BlockRuleIcd9, select: count(p.id))|>List.first
    icd10 = BlockRepo.all(from p in BlockRuleIcd10, select: count(p.id))|>List.first
    chinese_medicine = BlockRepo.all(from p in BlockChineseMedicine, select: count(p.id))|>List.first
    chinese_medicine_patent = BlockRepo.all(from p in BlockChineseMedicinePatent, select: count(p.id))|>List.first
    lib_wt4 = BlockRepo.all(from p in BlockLibWt4, select: count(p.id))|>List.first
    last_edit =
      case edit do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockCda, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_stat_org =
      case stat_org do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockStatOrg, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_mdc =
      case mdc do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockRuleMdc, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_adrg =
      case adrg do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockRuleAdrg, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_drg =
      case drg do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockRuleDrg, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_icd9 =
      case icd9 do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockRuleIcd9, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_icd10 =
      case icd10 do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockRuleIcd10, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_chinese_medicine =
      case chinese_medicine do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockChineseMedicine, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_chinese_medicine_patent =
      case chinese_medicine_patent do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockChineseMedicinePatent, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    last_lib_wt4 =
      case lib_wt4 do
        0 -> "-"
        _ -> BlockRepo.all(from p in BlockLibWt4, select: p.inserted_at, order_by: [asc: p.inserted_at], limit: 1)|>List.first|>Time.stime_ecto
      end
    [%{key: "edit", val: edit, last: last_edit}, %{key: "stat_org", val: stat_org, last: last_stat_org}, %{key: "mdc", val: mdc, last: last_mdc}, %{key: "adrg", val: adrg, last: last_adrg}, %{key: "drg", val: drg, last: last_drg}, %{key: "icd9", val: icd9, last: last_icd9}, %{key: "icd10", val: icd10, last: last_icd10}, %{key: "chinese_medicine", val: chinese_medicine, last: last_chinese_medicine}, %{key: "chinese_medicine_patent", val: chinese_medicine_patent, last: last_chinese_medicine_patent}, %{key: "lib_wt4", val: lib_wt4, last: last_lib_wt4}]
  end

  def insert(table, _time) do
    case table do
      "edit" ->

        BlockRepo.all(from p in BlockCda)
        |>Enum.map(fn x ->
            %HitbCda{}
            |>HitbCda.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "stat_org" ->
        BlockRepo.all(from p in BlockStatOrg)
        |>Enum.map(fn x ->
            %HitbStatOrg{}
            |>HitbStatOrg.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "mdc" ->
        BlockRepo.all(from p in BlockRuleMdc)
        |>Enum.map(fn x ->
            %HitbRuleMdc{}
            |>HitbRuleMdc.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "adrg" ->
        BlockRepo.all(from p in BlockRuleAdrg)
        |>Enum.map(fn x ->
            %HitbRuleAdrg{}
            |>HitbRuleAdrg.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "drg" ->
        BlockRepo.all(from p in BlockRuleDrg)
        |>Enum.map(fn x ->
            %HitbRuleDrg{}
            |>HitbRuleDrg.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "icd9" ->
        BlockRepo.all(from p in BlockRuleIcd9)
        |>Enum.map(fn x ->
            %HitbRuleIcd9{}
            |>HitbRuleIcd9.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "icd10" ->
        BlockRepo.all(from p in BlockRuleIcd10)
        |>Enum.map(fn x ->
            %HitbRuleIcd10{}
            |>HitbRuleIcd10.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "chinese_medicine" ->
        BlockRepo.all(from p in BlockChineseMedicine)
        |>Enum.map(fn x ->
            %HitbChineseMedicine{}
            |>HitbChineseMedicine.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "chinese_medicine_patent" ->
        BlockRepo.all(from p in BlockChineseMedicinePatent)
        |>Enum.map(fn x ->
            %HitbChineseMedicinePatent{}
            |>HitbChineseMedicinePatent.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
      "lib_wt4" ->
        BlockRepo.all(from p in BlockLibWt4)
        |>Enum.map(fn x ->
            %HitbLibWt4{}
            |>HitbLibWt4.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
            |>HitbRepo.insert
          end)
    end
  end

  defp hash(s) do
    s = :crypto.hash(:sha256, s)
    |> Base.encode64

    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end

end
