defmodule Block.AccountRepository do
  import Ecto.Query, warn: false
  alias Block.Repo
  alias Block.Account

  def insert_account(account) do
    %Account{}
    |> Account.changeset(account)
    |> Repo.insert
  end

  def get_all_accounts() do
    Repo.all(from p in Account, order_by: [asc: p.index])
  end

  def get_all_usernames() do
    Repo.all(from p in Account, select: p.username)
  end

  def get_account(username) do
    Map.drop(Repo.get_by(Account, username: username), [:__meta__, :__struct__])
  end

  def get_account_by_publicKey(publicKey) do
    Repo.get_by(Account, publicKey: publicKey)
  end

  def get_account_by_address(address) do
    Repo.get_by(Account, address: address)
  end


  def update_secondPublicKey(account) do
    get_account(account.username)
    |> Account.changeset(%{secondPublicKey: account.secondPublicKey})
    |> Repo.update
  end

  def delete_account(account) do
    Repo.delete(account)
  end
end
