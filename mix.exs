defmodule Sgoettschkes.MixProject do
  use Mix.Project

  def project do
    [
      app: :sgoettschkes,
      version: "0.1.0",
      elixir: "~> 1.14",
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
      {:slime,
       git: "https://github.com/populimited/slime.git",
       ref: "0e92acd2f110b7d9d667069d19e077d8ee36721f",
       override: true},
      {:still, "~> 0.8.0"},
      {:timex, "~> 3.7"},
      {:yaml_elixir, "~> 2.8"},
      {:meeseeks, "~> 0.17.0"}
    ]
  end
end
