defmodule HitbserverWeb.Router do
  use HitbserverWeb, :router

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

  scope "/", HitbserverWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    #登录页面
    get "/login", PageController, :login_html
    #登出
    get "/logout", PageController, :logout
    #区块链
    get "/blockchain",BlockController, :blockchain
    get "/bc_asset", BlockController, :bc_asset
    get "/bc_accounts", BlockController, :bc_accounts
    get "/bc_application", BlockController, :bc_application
    get "/bc_production", BlockController, :bc_production
    get "/bc_blockchain", BlockController, :bc_blockchain
    get "/bc_delegates", BlockController, :bc_delegates
    get "/bc_pay", BlockController, :bc_pay
    get "/bc_peers", BlockController, :bc_peers
    # 规则表
    get "/rule", RuleController, :rule
    get "/rule_contrast", RuleController, :contrast
    get "/details", RuleController, :details



    #统计分析
    get "/stat_html", StatController, :stat
    get "/contrast", StatController, :contrast
    get "/stat_info", StatController, :stat_info
    #系统设置
    get "/org_set", ServerController, :org_set
    get "/comp_info", ServerController, :comp_info
    get "/record", ServerController, :record
    get "/doctors", ServerController, :doctors
    #json处理
    get "/wt4_json", ServerController, :upload_html
    #统计分析页面
    get "/comp_html", ServerController, :comp_html
    # 字典审核
    get "/rule_auditing_html", ServerController, :auditing_html
  end

  scope "/hospitals", HitbserverWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    #登录页面
    get "/login", PageController, :login_html
    #登出
    get "/logout", PageController, :logout
    #区块链
    get "/blockchain",BlockController, :blockchain
    get "/bc_asset", BlockController, :bc_asset
    get "/bc_accounts", BlockController, :bc_accounts
    get "/bc_application", BlockController, :bc_application
    get "/bc_production", BlockController, :bc_production
    get "/bc_blockchain", BlockController, :bc_blockchain
    get "/bc_delegates", BlockController, :bc_delegates
    get "/bc_delegates", BlockController, :bc_delegates
    get "/bc_pay", BlockController, :bc_pay
    get "/bc_peers", BlockController, :bc_peers
    # 规则表
    get "/rule", RuleController, :rule
    get "/rule_contrast", RuleController, :contrast
    get "/details", RuleController, :details

    #统计分析
    get "/stat_html", StatController, :stat
    get "/contrast", StatController, :contrast
    get "/stat_info", StatController, :stat_info
    #系统设置
    get "/org_set", ServerController, :org_set
    get "/department_set", ServerController, :department
    get "/add", ServerController, :add
    get "/server_edit", ServerController, :server_edit
    get "/comp_info", ServerController, :comp_info
    get "/record", ServerController, :record
    get "/doctors", ServerController, :doctors

    #json处理
    get "/wt4_json", ServerController, :upload_html
    #统计分析页面
    get "/comp_html", ServerController, :comp_html
    # 字典审核
    get "/rule_auditing_html", ServerController, :auditing_html
    get "/user_html", ServerController, :user_html


  end

  # Other scopes may use custom stacks.
  scope "/hospitals", HitbserverWeb do
    pipe_through :api


    post "/login", PageController, :login
    #省市县三级联动
    get "/province", ServerController, :province
  end
end
