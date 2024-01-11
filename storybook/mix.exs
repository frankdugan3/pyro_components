defmodule PyroComponentsStorybook.MixProject do
  use Mix.Project

  def project do
    [
      app: :pyro_components_storybook,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: ["lib"],
      start_permanent: false,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PyroComponentsStorybook.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:bandit, ">= 0.0.0"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:gettext, "~> 0.20"},
      {:heroicons,
       github: "tailwindlabs/heroicons", tag: "v2.1.1", app: false, compile: false, sparse: "optimized", override: true},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_storybook, "~> 0.6.0"},
      {:pyro_components, path: "../"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:tz, "~> 0.26"},
      {:tz_extra, "~> 0.26"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"]
    ]
  end
end
