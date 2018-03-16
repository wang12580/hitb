defmodule HitbWeb.Router do
  use HitbWeb, :router

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

  scope "/", HitbWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", HitbWeb do
    pipe_through :api

    post "/block", BlockController, :add_block
    get "/blocks", BlockController, :get_all_blocks

    post "/peer", PeerController, :add_peer
    get "/peers", PeerController, :get_all_peers

    post "/open", AccountController, :openAccount
    post "/open2", AccountController, :openAccount2
    get  "/getBalance", AccountController, :getBalance
    get "/getPublicKey", AccountController, :getPublickey
    post "/generatePublicKey", AccountController, :generatePublickey
    get "/delegates", AccountController, :getDelegates
    get "/delegates/fee", AccountController, :getDelegatesFee
    put "/delegates", AccountController, :addDelegates
    get "/account", AccountController, :getAccount
    get "/newAccount", AccountController, :newAccount
  end
end
