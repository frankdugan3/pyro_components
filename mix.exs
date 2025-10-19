defmodule PyroComponents.MixProject do
  @moduledoc false
  use Mix.Project

  @source_url "https://github.com/frankdugan3/pyro_components"
  @version "0.1.1"
  @description """
  Extensible Phoenix components, built with Pyro.
  """
  def project do
    [
      app: :pyro_components,
      version: @version,
      description: @description,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      test_paths: ["test"],
      name: "PyroComponents",
      source_url: @source_url,
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      compilers: [:yecc] ++ Mix.compilers(),
      dialyzer: [plt_add_apps: [:ecto, :mix]],
      preferred_cli_env: [
        "test.watch": :test,
        docs: :docs
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "about",
      source_ref: "v#{@version}",
      output: "doc",
      source_url: @source_url,
      extra_section: "Guides",
      extras: extras(),
      groups_for_extras: [
        Tutorials: [~r'documentation/tutorials'],
        Cheatsheets: [~r'documentation/cheatsheets'],
        LiveBooks: [~r'documentation/livebooks']
      ],
      groups_for_modules: [
        "Component Bundles": [
          PyroComponents,
          ~r/(^PyroComponents.Defaults)/
        ],
        "Individual Components": [
          ~r/(^PyroComponents)/
        ]
      ],
      nest_modules_by_prefix: [
        PyroComponents,
        PyroComponents.Defaults
      ],
      groups_for_docs: [
        Components: &(&1[:type] == :component),
        Macros: &(&1[:type] == :macro)
      ]
    ]
  end

  defp extras do
    ordered =
      [
        {"documentation/about.md", [default: true]},
        "documentation/suite.md",
        "CHANGELOG.md",
        "documentation/tutorials/get-started.md"
      ]

    unordered = Path.wildcard("documentation/**/*.{md,cheatmd,livemd}")

    Enum.uniq_by(ordered ++ unordered, fn
      {file, _opts} -> file
      file -> file
    end)
  end

  defp package do
    [
      name: :pyro_components,
      maintainers: ["Frank Dugan III"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url},
      files: ~w(
        lib documentation
        README* CHANGELOG* LICENSE*
        mix.exs .formatter.exs
        package.json
      )
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Code quality tooling
      {:credo, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false},
      {:doctor, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_check, "~> 0.15",
       [env: :prod, hex: "ex_check", only: :dev, runtime: false, repo: "hexpm"]},
      {:faker, "~> 0.17", only: [:test, :dev]},
      {:floki, ">= 0.30.0", only: :test},
      {:mix_audit, ">= 0.0.0", only: :dev, runtime: false},
      # Build tooling
      {:ex_doc, ">= 0.0.0", only: :docs, runtime: false},
      {:git_ops, "~> 2.6", only: :dev},
      {:makeup_eex, ">= 0.1.2", only: :docs},
      # Core dependencies
      {:ecto, "~> 3.11"},
      {:phoenix_live_view, "~> 1.0"},
      # {:pyro, "~> 0.4"},
      # {:pyro, path: "../pyro"},
      # These dependencies add optional features if installed
      # {:makeup, "~> 1.1", optional: true},
      {:tzdata, "~> 1.1.0", optional: true},
      {:tz_extra, "~> 0.26", optional: true}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "compile", "docs"],
      # until we hit 1.0, we will ensure no major release!
      release: [
        "git_ops.release --no-major"
      ],
      publish: [
        "hex.publish"
      ]
    ]
  end
end
