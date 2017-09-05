defmodule MaximumJank.Mixfile do
  use Mix.Project

  #######
  # API #
  #######

  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  def project() do
    [
      app: :maximum_jank,
      description: description(),
      deps: deps(),
      elixir: "~> 1.5",
      package: package(),
      start_permanent: Mix.env == :prod,
      version: version(),
    ]
  end

  ###########
  # Private #
  ###########

  defp deps() do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp description(), do: "An unfocused collection of janky Elixir utilities"

  defp licenses() do
    [
      {"Apache 2.0", "https://www.apache.org/licenses/LICENSE-2.0"},
    ]
  end

  defp package() do
    [
      licenses: :proplists.get_keys(licenses()),
      links: %{"GitHub" => "https://github.com/amorphid/maximum-jank-elixir"},
      maintainers: ["Michael Pope"],
    ]
  end

  defp version(), do: "0.1.0"
end
