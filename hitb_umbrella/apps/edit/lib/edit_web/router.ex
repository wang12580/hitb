defmodule EditWeb.Router do
  use EditWeb, :router

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

  scope "/edit", EditWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # get "/test", PageController, :test
  end

  # Other scopes may use custom stacks.
  scope "/edit", EditWeb do
    pipe_through :api

    get "/test", CdaController, :test
    get "/cda", CdaController, :index
    get "/cda_user", CdaController, :cda_user
    get "/cda_file", CdaController, :cda_file
    post "/cda", CdaController, :update
    get "/mouldlist", CdaController, :mould_list
    get "/mouldfile", CdaController, :mould_file
    get "/helplist", CdaController, :help_list
    get "/helpfile", CdaController, :help_file
  end
end
