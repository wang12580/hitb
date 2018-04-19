defmodule Edit.Client do
  @moduledoc """
  The Client context.
  """

  import Ecto.Query, warn: false
  alias Edit.Repo

  alias Edit.Client.Cda

  @doc """
  Returns the list of cda.

  ## Examples

      iex> list_cda()
      [%Cda{}, ...]

  """
  def list_cda(type, val) do
    case type do
      "user" -> Repo.all(from p in Cda, select: p.username)|>:lists.usort
      "file" ->
        case val do
          "" ->
            Repo.all(from p in Cda, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end)
          _ ->
          Repo.all(from p in Cda, where: p.username == ^val, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end)
        end
      "filename" ->
        {filename, username} = val
        Repo.all(from p in Cda, where: p.username == ^username and p.name == ^filename, select: p.content)
    end
  end

  @doc """
  Gets a single cda.

  Raises `Ecto.NoResultsError` if the Cda does not exist.

  ## Examples

      iex> get_cda!(123)
      %Cda{}

      iex> get_cda!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cda!(id), do: Repo.get!(Cda, id)

  @doc """
  Creates a cda.

  ## Examples

      iex> create_cda(%{field: value})
      {:ok, %Cda{}}

      iex> create_cda(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cda(attrs \\ %{}) do
    %Cda{}
    |> Cda.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cda.

  ## Examples

      iex> update_cda(cda, %{field: new_value})
      {:ok, %Cda{}}

      iex> update_cda(cda, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cda(%Cda{} = cda, attrs) do
    cda
    |> Cda.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Cda.

  ## Examples

      iex> delete_cda(cda)
      {:ok, %Cda{}}

      iex> delete_cda(cda)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cda(%Cda{} = cda) do
    Repo.delete(cda)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cda changes.

  ## Examples

      iex> change_cda(cda)
      %Ecto.Changeset{source: %Cda{}}

  """
  def change_cda(%Cda{} = cda) do
    Cda.changeset(cda, %{})
  end
end
