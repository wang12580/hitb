defmodule LibraryWeb.PageController do
  use LibraryWeb, :controller
  plug LibraryWeb.Access
  alias Library.RuleMdc
  alias Library.RuleAdrg
  alias Library.RuleDrg
  alias Library.RuleIcd9
  alias Library.RuleIcd10
  alias Library.LibWt4
  alias Library.Key

  def index(conn, _params) do
    render conn, "index.html"
  end
end
