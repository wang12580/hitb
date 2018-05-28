defmodule Edit.MouldService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.MyMould

  def mould_list(username) do
    Repo.all(from p in MyMould, where: p.username == ^username, select: p.name)
  end

  def mould_file(username, name) do
    my_mould = Repo.get_by(MyMould, name: name, username: username)
    case my_mould do
      nil -> []
      _ -> my_mould.content
    end
  end

end
