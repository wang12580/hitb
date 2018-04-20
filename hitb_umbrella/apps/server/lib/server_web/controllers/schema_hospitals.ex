defmodule ServerWeb.SchemaHospitals do
  use ServerWeb, :controller

  alias Server.Department
  alias Server.CustomizeDepartment
  alias Server.Org
  alias Server.User
  alias Server.Record
  alias Comeonin.Bcrypt

  def list_department() do
    class_list = Repo.all(from p in Department, select: %{class_code: p.class_code, class_name: p.class_name}, group_by: [p.class_code, p.class_name], order_by: [asc: p.class_code])
    result =
      Enum.reduce(class_list, %{}, fn x, acc ->
        class_code = x.class_code
        x2 = Repo.all(from p in Department, where: p.class_code == ^class_code, select: %{class_code: p.class_code, department_code: p.department_code, department_name: p.department_name}, order_by: [asc: p.department_code])
        Map.merge(%{class_code => x2}, acc)
      end)
    {class_list, result}
  end

  def create_department(attrs \\ %{}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  def get_department!(id), do: Repo.get!(Department, id)

  def update_department(%Department{} = department, attrs) do
    department
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  def delete_department(%Department{} = department) do
    Repo.delete(department)
  end

  def list_customize(name, skip, num) do
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
      |>hd
    query = query
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
    {count, query|>Repo.all}
  end

  def create_customize_department(attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"wt_name" => ""})
    %CustomizeDepartment{}
    |> CustomizeDepartment.changeset(attrs)
    |> Repo.insert()
  end

  def get_customize_department!(id), do: Repo.get!(CustomizeDepartment, id)

  def update_customize_department(%CustomizeDepartment{} = customize_department, attrs) do
    customize_department
    |> CustomizeDepartment.changeset(attrs)
    |> Repo.update()
  end

  def delete_customize_department(%CustomizeDepartment{} = customize_department) do
    Repo.delete(customize_department)
  end

  def list_org(name, skip, num) do
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
    {count, query|>Repo.all}
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

  def update_org(org, attrs) do
    case attrs["code"] do
      nil ->
        org
        |> Org.changeset(attrs)
        |> Repo.update()
      _ ->
        cond do
          org.code == attrs["code"] ->
            org
            |> Org.changeset(attrs)
            |> Repo.update
          true ->
            db_org = Repo.get_by(Org, code: attrs["code"])
            case db_org do
              nil ->
                org
                |> Org.changeset(attrs)
                |> Repo.update()
              _ ->
                changeset = Org.changeset(%Org{}, attrs)
                changeset = %{changeset | :errors => ["error": "编码已存在！"]}
                {:error, changeset}
            end
        end
    end
  end

  def delete_org(%Org{} = org) do
    Repo.delete(org)
  end

  def list_user(skip, num) do
    query = from(w in User)
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> Repo.all
    count = hd(Repo.all(from p in User, select: count(p.id)))
    {count, query}
    # Repo.all(User)
  end

  def create_user(attrs \\ %{}) do
    user = attrs["username"]
    get_user = Repo.get_by(User, username: user)
    case get_user do
      nil ->
        attrs = Map.merge(%{"hashpw" => Bcrypt.hashpwsalt(attrs["password"]), "type" => 2, "key" => []}, attrs)
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()
      _ ->
        attrs = Map.merge(%{"hashpw" => Bcrypt.hashpwsalt(attrs["password"])}, attrs)
        changeset = User.changeset(%User{}, attrs)
        # changeset = %{changeset | :errors => ["error": "用户名已存在！"]}
        {:error, changeset}
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def list_record(skip, num) do
    query = from(w in Record)
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> Repo.all
    count = hd(Repo.all(from p in Record, select: count(p.id)))
    {count, query}
    # query = Repo.all(from p in Record)
  end

  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  def get_record!(id), do: Repo.get!(Record, id)

  # def update_record(%Record{} = record, attrs) do
  #   record
  #   |> User.changeset(attrs)
  #   |> Repo.update()
  # end

  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end
  #
  # def butying_insert(page, user) do
  #   time = Time.stime_local()
  #   date = Time.sdata_date()
  #   #获取当前日期前一操作
  #   butying_point = Repo.all(from p in ButyingPoint, where: p.date == ^date, order_by: [desc: p.action_time], limit: 1)
  #   map = %{action_info: page, username: user, date: date, action_time: time, dep_time: time}
  #   #数据库是否最新一条存在
  #   case butying_point do
  #     [] ->
  #       %ButyingPoint{}
  #       |> ButyingPoint.changeset(map)
  #       |> Repo.insert
  #     _ ->
  #       if(hd(butying_point).action_info != page)do
  #         %ButyingPoint{}
  #         |> ButyingPoint.changeset(map)
  #         |> Repo.insert
  #       end
  #       hd(butying_point)
  #       |> ButyingPoint.changeset(%{dep_time: time})
  #       |> Repo.update
  #   end
  # end
  #
  # def list_hospitals_stat do
  #   Repo.all(HospitalsStat)
  # end
  #
  # def get_hospitals_stat!(id), do: Repo.get!(HospitalsStat, id)
  #
  # def create_hospitals_stat(attrs \\ %{}) do
  #   %HospitalsStat{}
  #   |> HospitalsStat.changeset(attrs)
  #   |> Repo.insert()
  # end
  #
  # def update_hospitals_stat(%HospitalsStat{} = hospitals_stat, attrs) do
  #   hospitals_stat
  #   |> HospitalsStat.changeset(attrs)
  #   |> Repo.update()
  # end
  #
  # def delete_hospitals_stat(%HospitalsStat{} = hospitals_stat) do
  #   Repo.delete(hospitals_stat)
  # end
  #
  # def change_hospitals_stat(%HospitalsStat{} = hospitals_stat) do
  #   HospitalsStat.changeset(hospitals_stat, %{})
  # end

end
