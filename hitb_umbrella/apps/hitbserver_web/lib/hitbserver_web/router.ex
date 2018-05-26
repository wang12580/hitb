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
    get "/chat", PageController, :chat
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
    get "/rule", RulePageController, :rule
    get "/rule_contrast", RulePageController, :contrast
    get "/details", RulePageController, :details
    #统计分析
    get "/stat_html", StatPageController, :stat
    get "/contrast", StatPageController, :contrast
    get "/stat_info", StatPageController, :stat_info
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
    get "/myset", ServerController, :myset
  end

  scope "/hospitals", HitbserverWeb do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
    get "/chat", PageController, :chat
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
    get "/rule", RulePageController, :rule
    get "/rule_contrast", RulePageController, :contrast
    get "/details", RulePageController, :details

    #统计分析
    get "/stat_html", StatPageController, :stat
    get "/contrast", StatPageController, :contrast
    get "/stat_info", StatPageController, :stat_info
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
    #json处理
    get "/json_check", ServerController, :json_check
    get "/check_html", ServerController, :check_html

    #统计分析页面
    get "/comp_html", ServerController, :comp_html
    # 字典审核
    get "/rule_auditing_html", ServerController, :auditing_html
    get "/user_html", ServerController, :user_html
    get "/myset", ServerController, :myset
  end

  # Other scopes may use custom stacks.
  scope "/hospitals", HitbserverWeb do
    pipe_through :api
    post "/login", PageController, :login
    #省市县三级联动
    get "/province", ServerController, :province
  end

  scope "/edit", HitbserverWeb do
    pipe_through :api
    get "/cda", CdaController, :index
    get "/cda_user", CdaController, :cda_user
    get "/cda_file", CdaController, :cda_file
    post "/cda", CdaController, :update
    get "/mouldlist", MouldController, :mould_list
    get "/mouldfile", MouldController, :mould_file
    get "/helplist", HelpController, :help_list
    get "/helpfile", HelpController, :help_file
  end

  scope "/library", HitbserverWeb do
    pipe_through :api
    get "/rule_client", RuleController, :rule_client
    get "/rule_file", RuleController, :rule_file
    get "/rule", RuleController, :rule
    get "/contrast", RuleController, :contrast
    get "/details", RuleController, :details
    get "/search", RuleController, :search
    get "/wt4", Wt4Controller, :index
    get "/stat_wt4", Wt4Controller, :stat_wt4
    get "/server_rule", RuleController, :server_rule
  end

  scope "/servers", HitbserverWeb do
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
    # 科室列表
    get "/wt4_department_list", PageController, :wt4_department_list
    get "/wt4_insert", PageController, :wt4_insert
    resources "/chat_record", ChatRecordController, except: [:new, :edit]
  end

  scope "/stat", HitbserverWeb do
    pipe_through :api
    get "/stat_json", StatController, :stat_json
    #对比
    post "/contrast", ContrastController, :contrast_operate
    get "/contrast", ContrastController, :contrast
    get "/contrast_list", ContrastController, :contrast_list
    get "/contrast_chart", ContrastController, :contrast_chart
    get "/contrast_info", ContrastController, :contrast_info
    get "/download_stat", StatController, :download_stat
    get "/stat_info_chart", StatController, :stat_info_chart
    get "/stat_info", StatController, :stat_info
    get "/contrast_clear", ContrastController, :contrast_clear
    get "/stat_file", ClientController, :stat_file
    get "/stat_client", ClientController, :stat_client
    get "/target", CompController, :target
    get "/target1", CompController, :target1
    post "/stat_add", StatController, :stat_add
    get "/com_html", ComController, :com_html
    post "/stat_create", ClientController, :stat_create
  end

end
