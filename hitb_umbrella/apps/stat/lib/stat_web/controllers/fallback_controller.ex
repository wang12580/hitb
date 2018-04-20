defmodule StatWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use StatWeb, :controller
  plug StatWeb.Access

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(StatWeb.ChangesetView, "error.json", changeset: changeset)
  end

  # def call(conn, {:error, :not_found}) do
  #   conn
  #   |> put_status(:not_found)
  #   |> render(StatWeb.ErrorView, :"404")
  # end
end
