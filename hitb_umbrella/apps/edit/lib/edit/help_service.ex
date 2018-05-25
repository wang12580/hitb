defmodule Edit.HelpService do
  import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.ClinetHelp
  alias Hitb.Time

  def help_list() do
    Repo.all(from p in ClinetHelp, select: p.name)
  end

  def help_file() do
    Repo.get_by(ClinetHelp, name: "输入提示").content
  end

end
