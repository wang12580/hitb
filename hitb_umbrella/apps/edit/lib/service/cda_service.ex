defmodule Edit.CdaService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo, as: HitbRepo
  alias Block.Repo, as: BlockRepo
  alias Hitb.Edit.Cda, as: HitbCda
  alias Hitb.Edit.CdaFile, as: BlockCdaFile
  alias Hitb.Edit.CdaFile, as: HitbCdaFile
  alias Block.Edit.Cda, as: BlockCda
  alias Hitb.Edit.MyMould
  alias Hitb.Time
  alias Hitb.Server.User

  def cda_user(server_type) do
    users =
      case server_type do
        "server" -> HitbRepo.all(from p in HitbCdaFile, select: p.username)|>:lists.usort
        "block" -> BlockRepo.all(from p in BlockCdaFile, select: p.username)|>:lists.usort
      end
    users2 = HitbRepo.all(from p in User, where: p.is_show == false, select: p.username)
    users2 = if(users2)do users2 else [] end
    [users -- users2, "读取成功"]
  end

  def cda_files(username, server_type) do
    case server_type do
      "block" ->
        [BlockRepo.all(from p in BlockCda, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
      _ ->
        case username do
          "" ->
            [HitbRepo.all(from p in HitbCda, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
          _ ->
            [HitbRepo.all(from p in HitbCda, where: p.username == ^username, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
        end
    end
  end

  def cda_file(filename, username) do
    edit = HitbRepo.get_by(HitbCda, username: username, name: filename)
    cond do
      edit == nil ->
        [[],["文件读取失败,无此文件"]]
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
    mymould = HitbRepo.get_by(MyMould, name: file_name, username: file_username)
    if(mymould)do
      mymould
      |> MyMould.changeset(%{content: content})
      |> HitbRepo.update()
      %{success: true, info: "保存成功"}
    else
      namea = doctype<>".cdh"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => true, "is_show" => true}
      %MyMould{}
      |> MyMould.changeset(body)
      |> HitbRepo.insert()
      %{success: true, info: "新建成功"}
    end
  end

  defp myCdas(file_name, file_username, content, doctype, username) do
    cda = HitbRepo.get_by(HitbCda, name: file_name, username: file_username)
    if(cda)do
      cond do
        username == file_username ->
          cda
          |>HitbCda.changeset(%{content: content})
          |>HitbRepo.update
          %{success: true, info: "保存成功"}
        true ->
          case cda.is_change do
            false -> %{success: false, info: "用户设置该文件不允许其他用户修改,请联系该文件拥有者"}
            true ->
              cda
              |>HitbCda.changeset(%{content: content})
              |>HitbRepo.update
              %{success: true, info: "保存成功"}
          end
      end
    else
      namea = "#{doctype}_#{Time.stime_number}.cda"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => false, "is_show" => true}
      %HitbCda{}
      |> HitbCda.changeset(body)
      |> HitbRepo.insert()
       %{success: true, info: "新建成功"}
    end
  end
end
