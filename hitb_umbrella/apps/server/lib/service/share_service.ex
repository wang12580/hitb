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
            hash = hash(acc, timestamp, "#{x.org}#{x.time}")
            Map.drop(x, [:__meta__, :__struct__, :id])
            |>Map.merge(%Block.Edit.Cda{hash: hash, previous_hash: acc})
            |>Block.Repo.insert!
            acc = hash
          end)
        "stat" ->
          latest = Block.Repo.all(from p in Block.Stat.StatOrg, order_by: [desc: p.inserted_at], limit: 1)
          previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
          [stat, _, _, _, _, _, _, _, _] = Query.getstat(username, 1, "org", "", "", "", "", "org", "asc", Stat.page_en(file_name), 15, "download")
          Enum.reduce(stat, previous_hash, fn x, acc ->
            hash = hash(acc, timestamp, "#{x.org}#{x.time}")
            Map.drop(x, [:__meta__, :__struct__, :id])
            |>Map.merge(%Block.Stat.StatOrg{hash: hash, previous_hash: acc})
            |>Block.Repo.insert!
            acc = hash
          end)
        "library" ->
          case file_name do
            "mdc.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleMdc, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.RuleMdc{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            "adrg.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleAdrg, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.RuleAdrg{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            "drg.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleDrg, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.RuleDrg{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            "icd9.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleIcd9, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.RuleIcd9{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            "icd10.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.RuleIcd10, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.RuleIcd10{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            "中药.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.ChineseMedicine, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.ChineseMedicine{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            "中成药.csv" ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.ChineseMedicinePatent, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.ChineseMedicinePatent{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
            _ ->
              file_name = String.split(file_name, ".")|>List.first
              latest = Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == ^file_name, order_by: [desc: p.inserted_at], limit: 1)
              previous_hash = if(latest != [])do latest|>hd|>Map.get(:hash) else "" end
              mdc = Library.RuleService.rule_client(1, "year", file_name, "BJ", "", "", 0)
              Enum.reduce(mdc, previous_hash, fn x, acc ->
                hash = hash(acc, timestamp, "#{x.code}#{x.name}")
                Map.drop(x, [:__meta__, :__struct__, :id])
                |>Map.merge(%Block.Library.LibWt4{hash: hash, previous_hash: acc})
                |>Block.Repo.insert!
                acc = hash
              end)
          end
      end
  end

  defp hash(previous_hash, timestamp, data) do
    s = :crypto.hash(:sha256, "#{previous_hash}#{timestamp}#{data}")
    |> Base.encode64

    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end

end
