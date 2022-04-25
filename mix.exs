defmodule Filex.MixProject do
  use Mix.Project

  def project do
    [
      app: :filex,
      escript: escript_config(),
      elixirc_paths: elixirc_paths(Mix.env),
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Filex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.7.2"},
      {:postgrex, "~> 0.16.2"},
      {:ex_machina, "~> 2.7.0"}
    ]
  end

  defp escript_config do
    [main_module: Filex.CLI]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
