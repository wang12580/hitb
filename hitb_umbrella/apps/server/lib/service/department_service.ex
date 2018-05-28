defmodule Server.DepartmentService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Server.Department

  def list_department() do
    class_list = Repo.all(from p in Department, select: %{class_code: p.class_code, class_name: p.class_name}, group_by: [p.class_code, p.class_name], order_by: [asc: p.class_code])
    result =
      Enum.reduce(class_list, %{}, fn x, acc ->
        class_code = x.class_code
        x2 = Repo.all(from p in Department, where: p.class_code == ^class_code, select: %{class_code: p.class_code, department_code: p.department_code, department_name: p.department_name}, order_by: [asc: p.department_code])
        Map.merge(%{class_code => x2}, acc)
      end)
    [class_list, result]
  end

  def create_department(attrs \\ %{}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  def get_department!(id), do: Repo.get!(Department, id)

  def update_department(id, attrs) do
    get_department!(id)
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  def delete_department(id) do
    department = get_department!(id)
    Repo.delete(department)
  end
end
