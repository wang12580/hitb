defmodule HitbserverWeb.ClinetHelpView do
    use HitbserverWeb, :view
    alias HitbserverWeb.ClinetHelpView

    def render("index.json", %{clinet_help: clinet_help}) do
      %{data: render_many(clinet_help, ClinetHelpView, "clinet_help.json")}
    end

    def render("show.json", %{clinet_help: clinet_help}) do
      %{data: render_one(clinet_help, ClinetHelpView, "clinet_help.json")}
    end

    def render("clinet_help.json", %{clinet_help: clinet_help}) do
      %{
        name: clinet_help.name,
        content: clinet_help.content}
    end
  end
