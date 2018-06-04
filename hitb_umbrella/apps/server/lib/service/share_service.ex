defmodule Server.ShareService do
  # import Ecto
  import Ecto.Query
  alias Stat.ClientService
  alias Stat.Query

  def share(type, file_name, username, content) do
    timestamp = :os.system_time(:seconds)
      case type do
        "edit" ->
          latest = Block.Repo.all(from p in Block.Edit.Cda, order_by: [desc: p.inserted_at], limit: 1)
          previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
          cda = Hitb.Repo.all(from p in Hitb.Edit.Cda, where: p.name == ^file_name or p.username == ^username)
          Enum.reduce(cda, previous_hash, fn x, acc ->
            hash = hash("#{x.org}#{x.time}")
            %Block.Edit.Cda{hash: hash, previous_hash: acc}
            |>Map.merge(Map.drop(x, [:id]))
            |>Block.Repo.insert!
            acc = hash
          end)
        "stat" ->
          latest = Block.Repo.all(from p in Block.Stat.StatOrg, order_by: [desc: p.inserted_at], limit: 1)
          previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
          [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, 1, "org", "", "", "", "", "org", "asc", Stat.page_en(file_name), 15, "download")
          Enum.reduce(stat, previous_hash, fn x, acc ->
            hash = hash("#{x.org}#{x.time}")
            %Block.Stat.StatOrg{hash: hash, previous_hash: acc}
            |>Map.merge(Map.drop(x, [:id]))
            |>Block.Repo.insert!
            acc = hash
          end)
        "library" ->
          case file_name do
            "mdc.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleMdc, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [mdc, _list, _count, _page_list,_page_num] = Library.RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              # IO.inspect mdc
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %Block.Library.RuleMdc{hash: hash, previous_hash: acc}
                |>Map.merge(Map.drop(x, [:id]))
                |>Block.Repo.insert!
                acc = hash
              end)
            "adrg.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleAdrg, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [adrg, _list, _count, _page_list,_page_num] = Library.RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(adrg, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %Block.Library.RuleAdrg{hash: hash, previous_hash: acc}
                |>Map.merge(Map.drop(x, [:id]))
                |>Block.Repo.insert!
                acc = hash
              end)
            "drg.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleDrg, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [drg, _list, _count, _page_list,_page_num] =  Library.RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(drg, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %Block.Library.RuleDrg{hash: hash, previous_hash: acc}
                |>Map.merge(Map.drop(x, [:id]))
                |>Block.Repo.insert!
                acc = hash
              end)
            "icd9.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleIcd9, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [icd9, _list, _count, _page_list,_page_num] = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(icd9, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %Block.Library.RuleIcd9{hash: hash, previous_hash: acc}
                |>Map.merge(Map.drop(x, [:id]))
                |>Block.Repo.insert!
                acc = hash
              end)
            "icd10.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleIcd10, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              [icd10, _list, _count, _page_list,_page_num] =  Library.RuleService.clinet(1, "year", file_name, "BJ", "", "", 0, "server")
              # mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(icd10, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                %Block.Library.RuleIcd10{hash: hash, previous_hash: acc}
                |>Map.merge(Map.drop(x, [:id]))
                |>Block.Repo.insert!
                acc = hash
              end)
            # "中药.csv" ->
            #   file_name = String.split(file_name, ".")|>List.first
            #   latest = Block.Repo.all(from p in Block.Library.ChineseMedicine, order_by: [desc: p.inserted_at], limit: 1)
            #   previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
            #   [icd10, _list, _count, _page_list,_page_num] =  Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
            #   Enum.reduce(mdc, previous_hash, fn x, acc ->
            #     hash = hash(acc, timestamp, "#{x.code}#{x.name}")
            #     Map.drop(x, [:__meta__, :__struct__, :id])
            #     |>Map.merge(%Block.Library.ChineseMedicine{hash: hash, previous_hash: acc})
            #     |>Block.Repo.insert!
            #     acc = hash
            #   end)
            # "中成药.csv" ->
            #   file_name = String.split(file_name, ".")|>List.first
            #   latest = Block.Repo.all(from p in Block.Library.ChineseMedicinePatent, order_by: [desc: p.inserted_at], limit: 1)
            #   previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
            #   mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
            #   Enum.reduce(mdc, previous_hash, fn x, acc ->
            #     hash = hash(acc, timestamp, "#{x.code}#{x.name}")
            #     Map.drop(x, [:__meta__, :__struct__, :id])
            #     |>Map.merge(%Block.Library.ChineseMedicinePatent{hash: hash, previous_hash: acc})
            #     |>Block.Repo.insert!
            #     acc = hash
            #   end)
            _ ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == ^file_name, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0, "server")
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash("#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.LibWt4{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
          end
      end
  end

  def get_share() do
    edit = Block.Repo.all(from p in Block.Edit.Cda, select: count(p.id))|>List.first
    stat_org = Block.Repo.all(from p in Block.Stat.StatOrg, select: count(p.id))|>List.first
    mdc = Block.Repo.all(from p in Block.Library.RuleMdc, select: count(p.id))|>List.first
    adrg = Block.Repo.all(from p in Block.Library.RuleAdrg, select: count(p.id))|>List.first
    drg = Block.Repo.all(from p in Block.Library.RuleDrg, select: count(p.id))|>List.first
    icd9 = Block.Repo.all(from p in Block.Library.RuleIcd9, select: count(p.id))|>List.first
    icd10 = Block.Repo.all(from p in Block.Library.RuleIcd10, select: count(p.id))|>List.first
    chinese_medicine = Block.Repo.all(from p in Block.Library.ChineseMedicine, select: count(p.id))|>List.first
    chinese_medicine_patent = Block.Repo.all(from p in Block.Library.ChineseMedicinePatent, select: count(p.id))|>List.first
    lib_wt4 = Block.Repo.all(from p in Block.Library.LibWt4, select: count(p.id))|>List.first
    [%{key: "edit", val: edit}, %{key: "stat_org", val: stat_org}, %{key: "mdc", val: mdc}, %{key: "adrg", val: adrg}, %{key: "drg", val: drg}, %{key: "icd9", val: icd9}, %{key: "icd10", val: icd10}, %{key: "chinese_medicine", val: chinese_medicine}, %{key: "chinese_medicine_patent", val: chinese_medicine_patent}, %{key: "lib_wt4", val: lib_wt4}]
  end

  def insert(table) do
    case table do
      "edit" ->
        Block.Repo.all(from p in Block.Edit.Cda)
        |>Enum.map(fn x ->
            %Hitb.Edit.Cda{}
            |>Hitb.Edit.Cda.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "stat_org" ->
        Block.Repo.all(from p in Block.Stat.StatOrg)
        |>Enum.map(fn x ->
            %Hitb.Stat.StatOrg{}
            |>Hitb.Stat.StatOrg.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "mdc" ->
        Block.Repo.all(from p in Block.Library.RuleMdc)
        |>Enum.map(fn x ->
            %Hitb.Library.RuleMdc{}
            |>Hitb.Library.RuleMdc.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "adrg" ->
        Block.Repo.all(from p in Block.Library.RuleAdrg)
        |>Enum.map(fn x ->
            %Hitb.Library.RuleAdrg{}
            |>Hitb.Library.RuleAdrg.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "drg" ->
        Block.Repo.all(from p in Block.Library.RuleDrg)
        |>Enum.map(fn x ->
            %Hitb.Library.RuleDrg{}
            |>Hitb.Library.RuleDrg.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "icd9" ->
        Block.Repo.all(from p in Block.Library.RuleIcd9)
        |>Enum.map(fn x ->
            %Hitb.Library.RuleIcd9{}
            |>Hitb.Library.RuleIcd9.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "icd10" ->
        Block.Repo.all(from p in Block.Library.RuleIcd10)
        |>Enum.map(fn x ->
            %Hitb.Library.RuleIcd10{}
            |>Hitb.Library.RuleIcd10.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "chinese_medicine" ->
        Block.Repo.all(from p in Block.Library.ChineseMedicine)
        |>Enum.map(fn x ->
            %Hitb.Library.ChineseMedicine{}
            |>Hitb.Library.ChineseMedicine.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "chinese_medicine_patent" ->
        Block.Repo.all(from p in Block.Library.ChineseMedicinePatent)
        |>Enum.map(fn x ->
            %Hitb.Library.ChineseMedicinePatent{}
            |>Hitb.Library.ChineseMedicinePatent.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
          end)
      "lib_wt4" ->
        Block.Repo.all(from p in Block.Library.LibWt4)
        |>Enum.map(fn x ->
            %Hitb.Library.LibWt4{}
            |>Hitb.Library.LibWt4.changeset(Map.drop(x, [:id, :__meta__, :__struct__]))
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
