defmodule LibraryWeb.Router do
  use LibraryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/library", LibraryWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/library", LibraryWeb do
    pipe_through :api
    get "/rule_client", PageController, :rule_client
    get "/rule_file", PageController, :rule_file
    get "/rule", PageController, :rule
    get "/contrast", PageController, :contrast
    get "/details", PageController, :details
    get "/search", PageController, :search
    get "/wt4", Wt4Controller, :index
    get "/stat_wt4", Wt4Controller, :stat_wt4
  end
end
