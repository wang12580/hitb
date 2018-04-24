defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", ServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", ServerWeb do
    pipe_through :api
    #省市县三级联动
    get "/province", PageController, :province
    #服务器连接
    get "/connect", PageController, :connect
    #上传wt4
    post "/wt4_upload", PageController, :wt4_upload
    #登录
    post "/login", UserController, :login
    #更新机构
    post "/org_update", OrgController, :update
    #机构
    resources "/org", OrgController, except: [:new, :edit]
    #更新机构
    post "/customize_department_update", CustomizeDepartmentController, :update
    #科室
    resources "/customize_department", CustomizeDepartmentController, except: [:new, :edit]
    #操作记录
    resources "/record", RecordController, except: [:new, :edit]
    #标准科室
    resources "/department", DepartmentController, except: [:new, :edit]
    #用户
    post "/user_update", UserController, :update
    #用户
    resources "/user", UserController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  scope "/servers", ServerWeb do
    pipe_through :api
    #省市县三级联动
    get "/province", PageController, :province
    #服务器连接
    get "/connect", PageController, :connect
    #上传wt4
    post "/wt4_upload", PageController, :wt4_upload
    #登录
    post "/login", UserController, :login
    #更新机构
    post "/org_update", OrgController, :update
    #机构
    resources "/org", OrgController, except: [:new, :edit]
    #更新机构
    post "/customize_department_update", CustomizeDepartmentController, :update
    #科室
    resources "/customize_department", CustomizeDepartmentController, except: [:new, :edit]
    #操作记录
    resources "/record", RecordController, except: [:new, :edit]
    #标准科室
    resources "/department", DepartmentController, except: [:new, :edit]
    #用户
    post "/user_update", UserController, :update
    #用户
    resources "/user", UserController, except: [:new, :edit]
  end
end
