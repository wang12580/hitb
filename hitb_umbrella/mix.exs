defmodule Hitb.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [{:distillery, "~> 1.5", runtime: false}]
  end
end
