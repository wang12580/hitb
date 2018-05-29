defmodule Edit.HelpService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.ClinetHelp
  # alias Hitb.Time
  def help_insert() do
    body = %{"name" => "编辑器使用帮助"}
    %ClinetHelp{}
      |> ClinetHelp.changeset(body)
      |> Repo.insert()
  end
  def help_list() do
    Repo.all(from p in ClinetHelp, select: p.name)
  end

  def help_file() do
    help = Repo.get_by(ClinetHelp, name: "输入提示")
    case help do
      nil -> []
      _ -> help.content
    end
  end

end
