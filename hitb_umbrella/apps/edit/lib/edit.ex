defmodule Edit do
  import Ecto.Query
  @moduledoc """
  Edit keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def all_cda() do
    Edit.Repo.all(from p in Edit.Client.Cda, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end)
  end
end
