defmodule Edit.CdaService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.Cda
  alias Hitb.Edit.MyMould
  # alias Hitb.Edit.ClinetHelp
  alias Hitb.Time

  def cda_user() do
    users = Repo.all(from p in Cda, select: p.username)|>:lists.usort
    [users -- Server.Repo.all(from p in Server.User, where: p.is_show == false, select: p.username), "读取成功"]
  end

  def cda_files(username) do
    case username do
      "" ->
        [Repo.all(from p in Cda, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
      _ ->
      [Repo.all(from p in Cda, where: p.username == ^username, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
    end
  end

  def cda_file(filename, username) do
    edit = Repo.get_by(Cda, username: username, name: filename)
    cond do
      edit.is_show == false ->
        [[],["文件拥有者不允许他人查看,请联系文件拥有者"]]
      edit.is_change == false ->
        [[edit.content],["文件读取成功,但文件拥有者不允许修改"]]
      true ->
        [[edit.content],["文件读取成功"]]
    end
  end

  def update(content, file_name, username, doctype, mouldtype) do
    {file_username, file_name} =
      if(String.contains? file_name, "-")do
        List.to_tuple(String.split(file_name, "-"))
      else
        {username, file_name}
      end
    _rules = %{"file_name" => file_name, "file_username" => file_username, "content" => content, "doctype" => doctype, "username" => username}
    if (mouldtype == "模板") do
      myMoulds(file_name, file_username, content, doctype)
    else
      myCdas(file_name, file_username, content, doctype, username)
    end
  end

  defp myMoulds(file_name, file_username, content, doctype) do
    mymould = Repo.get_by(Edit.MyMould, name: file_name, username: file_username)
    if(mymould)do
      mymould
      |> MyMould.changeset(%{content: content})
      |> Repo.update()
    else
      namea = doctype<>".cdh"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => true, "is_show" => true}
      %MyMould{}
      |> MyMould.changeset(body)
      |> Repo.insert()
    end
  end

  defp myCdas(file_name, file_username, content, doctype, username) do
    cda = Repo.get_by(Cda, name: file_name, username: file_username)
    if(cda)do
      cond do
        username == file_username ->
          cda
          |>Cda.changeset(%{content: content})
          |>Repo.update
          %{success: true, info: "保存成功"}
        true ->
          case cda.is_change do
            false -> %{success: false, info: "用户设置该文件不允许其他用户修改,请联系该文件拥有者"}
            true ->
              cda
              |>Cda.changeset(%{content: content})
              |>Repo.update
              %{success: true, info: "保存成功"}
          end
      end
    else
      namea = "#{doctype}_#{Time.stime_number}.cda"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => false, "is_show" => true}
      %Cda{}
      |> Cda.changeset(body)
      |> Repo.insert()
       %{success: true, info: "新建成功"}
    end
  end
end
