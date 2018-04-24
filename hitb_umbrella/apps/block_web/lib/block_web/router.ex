defmodule BlockWeb.Router do
  use BlockWeb, :router

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

  scope "/", BlockWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/block_html", PageController, :block
    get "/peer", PageController, :peer
    get "/login", PageController, :login_html
    get "/logout", PageController, :logout
    get "/account", PageController, :account
  end

  # Other scopes may use custom stacks.
  scope "/api", BlockWeb do
    pipe_through :api

    get "/status", PageController, :status
    get "/status/sync", PageController, :sync
    get "/getSystemInfo", PageController, :getSystemInfo

    post "/block", BlockController, :add_block
    get "/blocks", BlockController, :get_all_blocks
    get "/getBlock", BlockController, :getBlock
    get "/getFullBlock",  BlockController, :getFullBlock
    get "/getBlocks", BlockController, :getBlocks
    get "/getHeight", BlockController, :getHeight
    get "/getFee", BlockController, :getFee
    get "/getMilestone", BlockController, :getMilestone
    get "/getReward", BlockController, :getReward
    get "/getSupply", BlockController, :getSupply
    get "/getStatus", BlockController, :getStatus
    get "/getBlockByHash", BlockController, :getBlockByHash

    post "/peer", PeerController, :add_peer
    get "/peers", PeerController, :get_all_peers
    get "/getPeers", PeerController, :getPeers
    get "/peerVersion", PeerController, :version
    get "/getPeer", PeerController, :getPeer

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
    put "/addSignature", AccountController, :addSignature
    get "/getAccountsPublicKey", AccountController, :getAccountsPublicKey
    get "/getAccountByPublicKey", AccountController, :getAccountByPublicKey
    get "/getAccountByAddress", AccountController, :getAccountByAddress

    get "/count", DelegateController, :count
    get "/getVoters", DelegateController, :getVoters
    get "/getDelegate", DelegateController, :getDelegate
    get "/getDelegates", DelegateController, :getDelegates
    get "/getDelegateFee", DelegateController, :getDelegateFee
    get "/forging/getForgedByAccount", DelegateController, :getForgedByAccount
    put "/addDelegate", DelegateController, :addDelegate

    get "/getTransactions", TransactionController, :getTransactions
    get "/getTransaction", TransactionController, :getTransaction
    get "/unconfirmed/get", TransactionController, :getUnconfirmedTransaction
    get "/unconfirmed", TransactionController, :getUnconfirmedTransactions
    put "/addTransactions", TransactionController, :addTransactions
    get "/getStorage", TransactionController, :getStorage
    get "/getStorage:id", TransactionController, :getStorage
    put "/putStorage", TransactionController, :putStorage
    get "/getTransactionsByBlockHeight", TransactionController, :getTransactionsByBlockHeight
    get "/getTransactionsByBlockHash", TransactionController, :getTransactionsByBlockHash
  end

  #服务器配置
  scope "/block/", BlockWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/block_html", PageController, :block
    get "/peer", PageController, :peer
    get "/login", PageController, :login_html
    get "/logout", PageController, :logout
    get "/account", PageController, :account
  end

  # Other scopes may use custom stacks.
  scope "/block/api", BlockWeb do
    pipe_through :api

    get "/status", PageController, :status
    get "/status/sync", PageController, :sync
    get "/getSystemInfo", PageController, :getSystemInfo

    post "/block", BlockController, :add_block
    get "/blocks", BlockController, :get_all_blocks
    get "/getBlock", BlockController, :getBlock
    get "/getFullBlock",  BlockController, :getFullBlock
    get "/getBlocks", BlockController, :getBlocks
    get "/getHeight", BlockController, :getHeight
    get "/getFee", BlockController, :getFee
    get "/getMilestone", BlockController, :getMilestone
    get "/getReward", BlockController, :getReward
    get "/getSupply", BlockController, :getSupply
    get "/getStatus", BlockController, :getStatus
    get "/getBlockByHash", BlockController, :getBlockByHash

    post "/peer", PeerController, :add_peer
    get "/peers", PeerController, :get_all_peers
    get "/getPeers", PeerController, :getPeers
    get "/peerVersion", PeerController, :version
    get "/getPeer", PeerController, :getPeer

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
    put "/addSignature", AccountController, :addSignature
    get "/getAccountsPublicKey", AccountController, :getAccountsPublicKey
    get "/getAccountByPublicKey", AccountController, :getAccountByPublicKey
    get "/getAccountByAddress", AccountController, :getAccountByAddress

    get "/count", DelegateController, :count
    get "/getVoters", DelegateController, :getVoters
    get "/getDelegate", DelegateController, :getDelegate
    get "/getDelegates", DelegateController, :getDelegates
    get "/getDelegateFee", DelegateController, :getDelegateFee
    get "/forging/getForgedByAccount", DelegateController, :getForgedByAccount
    put "/addDelegate", DelegateController, :addDelegate

    get "/getTransactions", TransactionController, :getTransactions
    get "/getTransaction", TransactionController, :getTransaction
    get "/unconfirmed/get", TransactionController, :getUnconfirmedTransaction
    get "/unconfirmed", TransactionController, :getUnconfirmedTransactions
    put "/addTransactions", TransactionController, :addTransactions
    get "/getStorage", TransactionController, :getStorage
    get "/getStorage:id", TransactionController, :getStorage
    put "/putStorage", TransactionController, :putStorage
    get "/getTransactionsByBlockHeight", TransactionController, :getTransactionsByBlockHeight
    get "/getTransactionsByBlockHash", TransactionController, :getTransactionsByBlockHash
  end
end
