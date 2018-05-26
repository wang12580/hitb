defmodule Edit.MouldService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.MyMould

  def mould_list(username) do
    Repo.all(from p in MyMould, where: p.username == ^username, select: p.name)
  end

  def mould_file(username, name) do
    IO.inspect username
    IO.inspect name
    IO.inspect "------------------------"
    Repo.get_by(MyMould, name: name, username: username).content
  end

end
