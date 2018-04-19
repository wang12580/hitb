defmodule Library.CndrgRule do
  def getrule(query) do
    Library.Repo.all(query)
  end
end
