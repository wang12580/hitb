defmodule Server do
  import Ecto.Query
  @moduledoc """
  Server keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def all_user() do
    Server.Repo.all(from p in Server.User, select: p.username)
  end
end
