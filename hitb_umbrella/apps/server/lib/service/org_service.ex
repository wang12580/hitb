defmodule Server.OrgService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Server.Org
  alias Hitb.Page

  def list_org(name, page, num) do
    skip = Page.skip(page, 15)
    query = from(w in Org)
    name = "%" <> name <> "%"
    case name do
      "" -> query
      _ -> query|>where([w], like(w.name, ^name) or like(w.code, ^name))
    end
    count = query
      |>select([w], count(w.id))
      |>Repo.all
      |>hd
    query = query
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
    result = query|>Repo.all
    [page_num, page_list, _count] = Page.page_list(page, count, 15)
    %{org: result, page_num: page_num, page_list: page_list}
  end

  def create_org(attrs \\ %{}) do
    code = attrs["code"]
    org = Repo.get_by(Org, code: code)
    case org do
      nil ->
        org = Repo.all(from p in Org, select: p.stat_org_name, order_by: [desc: p.stat_org_name], limit: 1)
        attrs =
          case org do
            [] -> Map.merge(%{"stat_org_name" => 1}, attrs)
            _ -> Map.merge(%{"stat_org_name" => hd(org)+1}, attrs)
          end
        %Org{}
        |> Org.changeset(attrs)
        |> Repo.insert()
      _ ->
        changeset = Org.changeset(%Org{}, attrs)
        changeset = %{changeset | :errors => ["error": "编码已存在！"]}
        {:error, changeset}
    end
  end

  def get_org!(id), do: Repo.get!(Org, id)

  def update_org(id, attrs) do
    org = get_org!(id)
    cond do
      attrs["code"] == nil ->
        Org.changeset(org, attrs)
        |> Repo.update()
      attrs["code"] == org.code ->
        Org.changeset(org, attrs)
        |> Repo.update
      Repo.get_by(Org, code: attrs["code"]) == nil ->
        Org.changeset(org, attrs)
        |> Repo.update()
      true ->
        changeset = Org.changeset(%Org{}, attrs)
        changeset = %{changeset | :errors => ["error": "编码已存在！"]}
        {:error, changeset}
    end
  end

  def delete_org(id) do
    org = get_org!(id)
    Repo.delete(org)
  end

end
