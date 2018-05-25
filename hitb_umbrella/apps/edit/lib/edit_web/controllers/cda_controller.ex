defmodule EditWeb.CdaController do
  use EditWeb, :controller

  alias Edit.Client
  alias Edit.Client.Cda
  alias Edit.MyMould
  alias Edit.ClinetHelp
  alias Hitb.Time
  plug EditWeb.Access

  def test(conn, _params) do
    resule = Repo.all(from p in Client.Cda, select: [p.username, p.name, p.content])
    Enum.each(resule, fn x -> 
      [username, name, content] = x
      b = String.split(name, ".")|>hd
      # IO.inspect b
      rule = %{"username" => username, "name"=> b<>".cdh", "content" => content, "is_change" => true, "is_show" => true}
      %MyMould{}
      |> MyMould.changeset(rule)
      |> Repo.insert()
    end)
    json conn, %{}
  end

  def test2(conn, _params) do
    a = ["输入提示", "参考病案", "病案历史","在线交流","DRG分析","HIS接口"]
    Enum.each(a, fn x -> 
      rule = %{"name" => x}
      %ClinetHelp{}
      |> ClinetHelp.changeset(rule)
      |> Repo.insert()
      IO.inspect rule
    end)
    json conn, %{}
  end

  def cda_user(conn, _params) do
    # %{"type" => type} = Map.merge(%{"type" => "user"}, conn.params)
    [cda, info] = Client.list_cda("user", "")
    json conn, %{cda: cda, info: info}
  end

  def cda_file(conn, _params) do
    %{"username" => username} = Map.merge(%{"username" => ""}, conn.params)
    [cda, info] = Client.list_cda("file", username)
    json conn, %{cda: cda, info: info}
  end

  def index(conn, _params) do
    %{"filename" => filename, "username" => username} = Map.merge(%{"filename" => "", "username" => ""}, conn.params)
    [cda, info] = Client.list_cda("filename", {filename, username})
    json conn, %{cda: cda, info: info}
  end
  def mould_list(conn, _params) do
    %{"username" => username} = Map.merge(%{"username" => ""}, conn.params)
    resule = Repo.all(from p in MyMould, where: p.username == ^username, select: p.name)
    json conn, %{resule: resule, success: true}
  end

  def mould_file(conn, _params) do
    %{"username" => username, "name" => name} = Map.merge(%{"username" => "", "name" => ""}, conn.params)
    resule = Repo.get_by(MyMould, name: name, username: username)
    result = resule.content
    json conn, %{result: result, success: true}
  end

  def help_list(conn, _params) do
    resule = Repo.all(from p in ClinetHelp, select: p.name)
    json conn, %{resule: resule, success: true}
  end

  def help_file(conn, _params) do
    %{"name" => name} = Map.merge(%{"name" => ""}, conn.params)
    resule = Repo.get_by(ClinetHelp, name: "输入提示")
    result = resule.content
    json conn, %{result: result, success: true}
  end

  def update(conn, %{"content" => content, "file_name" => file_name, "username" => username, "doctype" => doctype, "mouldtype" => mouldtype}) do
    IO.inspect (String.contains? file_name, "-")
    {file_username, file_name} =
      if(String.contains? file_name, "-")do
        List.to_tuple(String.split(file_name, "-"))
      else
        {username, file_name}
      end
    rules = %{"file_name" => file_name, "file_username" => file_username, "content" => content, "doctype" => doctype, "username" => username}
    if (mouldtype == "模板") do
      myMoulds(conn, rules)
    else
      myCdas(conn, rules)
    end
  end
  defp myMoulds(conn, params) do
    %{"file_name" => file_name, "file_username" => file_username, "content" => content, "doctype" => doctype, "username" => username} = params
    mymould = Repo.get_by(Edit.MyMould, name: file_name, username: file_username)
    if(mymould)do
      mymould
      |> MyMould.changeset(%{content: content})
      |> Repo.update()
    else
      namea = doctype<>".cdh"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => true, "is_show" => true}
      IO.inspect body
      %MyMould{}
      |> MyMould.changeset(body)
      |> Repo.insert()
      json conn, %{success: true, info: "新建成功"}
    end
  end

  defp myCdas(conn, params) do
    %{"file_name" => file_name, "file_username" => file_username, "content" => content, "doctype" => doctype, "username" => username} = params
    cda = Repo.get_by(Cda, name: file_name, username: file_username)
    if(cda)do
      cond do
        username == file_username ->
          cda
          |>Cda.changeset(%{content: content})
          |>Repo.update
          json conn, %{success: true, info: "保存成功"}
        true ->
          case cda.is_change do
            false -> json conn, %{success: false, info: "用户设置该文件不允许其他用户修改,请联系该文件拥有者"}
            true ->
              cda
              |>Cda.changeset(%{content: content})
              |>Repo.update
              json conn, %{success: true, info: "保存成功"}
          end
      end
    else
      namea = doctype <>"_"<>Time.stime_number<>".cda"
      body = %{"content" => content, "name" => namea, "username" => file_username, "is_change" => false, "is_show" => true}
      %Cda{}
      |> Cda.changeset(body)
      |> Repo.insert()
      json conn, %{success: true, info: "新建成功"}
    end
  end
end
