defmodule Sgoettschkes.MixProject do
  use Mix.Project

  def project do
    [
      app: :sgoettschkes,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Sgoettschkes.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:earmark, "~> 1.4.24"},
      {:neotoma, "~> 1.7.3", manager: :rebar3, override: true},
      {:still, git: "https://github.com/still-ex/still.git", branch: "master"},
      {:timex, "~> 3.7"},
      {:yaml_elixir, "~> 2.8"},
      {:meeseeks, "~> 0.17.0"}
    ]
  end
end
