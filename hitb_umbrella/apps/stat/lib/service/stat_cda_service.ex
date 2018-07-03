defmodule Stat.StatCdaService do
  import Ecto.Query
  alias Hitb.Repo
  # alias Stat.StatCda
  alias Hitb.Edit.Cda

  def comp() do
    Repo.all(from p in Cda)
    |>Enum.map(fn x ->
        content = String.split(x.content, "，")
        IO.inspect x.content
        IO.inspect content
        IO.inspect "=========================="
      end)
  end

end
