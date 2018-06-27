defmodule Server.CustomizeDepartmentService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Server.CustomizeDepartment
  alias Hitb.Page

  def list_customize(page, name, num) do
    skip = Page.skip(page, 15)
    query = from(w in CustomizeDepartment)
    name = "%" <> name <> "%"
    query =
      case name do
        "%%" -> query
        _ -> query|>where([w], like(w.org, ^name) or like(w.wt_code, ^name))
      end
    count = query
      |>select([w], count(w.id))
      |>Repo.all
      |>List.first
    query = query
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
    result = query|>Repo.all
    [page_num, page_list, _count] = Page.page_list(page, count, 15)
    %{customize_department: result, page_num: page_num, page_list: page_list}
  end

  def create_customize(params, user) do
    params = Map.merge(params, %{"c_user" => user.username, "wt_name" => ""})
    %CustomizeDepartment{}
    |> CustomizeDepartment.changeset(params)
    |> Repo.insert()
  end

  def get_customize!(id), do: Repo.get!(CustomizeDepartment, id)

  def update_customize(id, params) do
    get_customize!(id)
    |> CustomizeDepartment.changeset(params)
    |> Repo.update()
  end

  def delete_customize(id) do
    customize_department = get_customize!(id)
    Repo.delete(customize_department)
  end

end
