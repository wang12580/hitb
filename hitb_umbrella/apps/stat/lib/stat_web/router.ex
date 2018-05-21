defmodule StatWeb.Router do
  use StatWeb, :router

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
    plug :fetch_flash
  end

  scope "/stat", StatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/test", PageController, :test
  end

  # Other scopes may use custom stacks.
  scope "/stat", StatWeb do
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
