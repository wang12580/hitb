defmodule Edit.HelpService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.ClinetHelp
  # alias Hitb.Time
  def help_insert(name, content) do
    body = %{"name" => name, "content" => content}
    help = Repo.get_by(ClinetHelp, name: name)
    case help do
      nil ->
        %ClinetHelp{}
        |> ClinetHelp.changeset(body)
        |> Repo.insert()
        %{success: true, info: "新建成功"}
      _ ->
        help
        |>ClinetHelp.changeset(%{content: content})
        |>Repo.update
        %{success: true, info: "修改成功"}
    end
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
