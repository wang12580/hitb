defmodule HitbserverWeb.ServerController do
  use HitbserverWeb, :controller
  alias HitbserverWeb.MyUser
  alias Hitbserver.Province


  def org_set(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      render conn, "org_set.html", user: user
      # , page: page, type: type, tab_type: tab_type, version: version, year: year,
      # dissect: dissect
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def department(conn, _params) do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "department.html", user: user, page: page
      # , page: page, type: type, tab_type: tab_type, version: version, year: year,
      # dissect: dissect
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def add(conn, %{"type" => type})do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      # org = MyUser.user_info(conn).org
      render conn, "add.html", user: user, type: type
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def server_edit(conn, %{"type" => type, "id" => id})do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      # result =
      #   case type do
      #     "org" -> Repo.get!(Org, id)
      #     "department" -> Repo.get!(CustomizeDepartment, id)
      #     "user" -> Repo.get!(User, id)
      #   end
      org = MyUser.user_info(conn).org
      render conn, "edit.html", user: user, type: type, org: org, id: id
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def user_html(conn, _params)do
    user = get_session(conn, :user)
    login = MyUser.is_login(conn)
    if(login)do
      # SchemaHospitals.butying_insert("用户管理", user.username)
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      # skip = Myfn.skip(page, 10)
      # user_list = from(w in User)
      #   |> limit([w], 10)
      #   |> offset([w], ^skip)
      #   |> order_by([w], [asc: w.id])
      #   |> Repo.all
      # count = hd(Repo.all(from p in User, select: count(p.id)))
      # {page_num, page_list} = Myfn.page(page, skip, count, 10)
      render conn, "user_html.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def comp_info(conn, _params)do
    user = get_session(conn, :user)
    render conn, "comp_info.html",user: user
  end

  def record(conn, _params)do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    user = get_session(conn, :user)
    IO.inspect page
    render conn, "record.html", user: user, page: page
  end


  def upload_html(conn, _params)do
    user = get_session(conn, :user)
    render conn, "upload.html", user: user
  end

  def comp_html(conn, _params) do
    user = get_session(conn, :user)
    render conn, "comp_html.html", user: user
  end

  def auditing_html(conn, _params) do
    user = get_session(conn, :user)
    render conn, "auditing.html", user: user
  end

  def doctors(conn, _params) do
    user = get_session(conn, :user)
    render conn, "doctors_html.html", user: user
  end

  def province(conn, _params)do
    json conn, %{province: Province.province(), city: Province.city(), county: Province.county()}
  end

end
