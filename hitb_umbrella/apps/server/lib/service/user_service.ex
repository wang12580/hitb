defmodule Server.UserService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Server.User
  alias ServerWeb.MyUser

  def list_user(page, num) do
    skip = Hitb.Page.skip(page, 15)
    query = from(w in User)
      |> limit([w], ^num)
      |> offset([w], ^skip)
      |> Repo.all
    count = hd(Repo.all(from p in User, select: count(p.id)))
    [count, query]
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
        attrs = Map.merge(%{"hashpw" => Bcrypt.hashpwsalt(attrs["password"]), "is_show" => false}, attrs)
        changeset = User.changeset(%User{}, attrs)
        # changeset = %{changeset | :errors => ["error": "用户名已存在！"]}
        {:error, changeset}
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

  def update_user(id, attrs) do
    get_user!(id)
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) do
    user = UserService.get_user!(id)
    Repo.delete(user)
  end
end
