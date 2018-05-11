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
      "user" ->
        users = Repo.all(from p in Cda, select: p.username)|>:lists.usort
        [users -- Server.Repo.all(from p in Server.User, where: p.is_show == false, select: p.username), "读取成功"]
      "file" ->
        case val do
          "" ->
            [Repo.all(from p in Cda, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
          _ ->
          [Repo.all(from p in Cda, where: p.username == ^val, select: [p.username, p.name]) |> Enum.map(fn x -> Enum.join(x, "-") end), "读取成功"]
        end
      "filename" ->
        {filename, username} = val
        edit = Repo.all(from p in Cda, where: p.username == ^username and p.name == ^filename, select: %{content: p.content, is_show: p.is_show, is_change: p.is_change})
        edit = Repo.get_by(Cda, username: username, name: filename)
        cond do
          edit.is_show == false -> [[],["文件拥有者不允许他人查看,请联系文件拥有者"]]
          edit.is_change == false -> [[edit.content],["文件读取成功,但文件拥有者不允许修改"]]
          true -> [[edit.content],["文件读取成功"]]
        end
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
    attrs = Map.merge(%{"is_change" => false, "is_show" => false})
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
