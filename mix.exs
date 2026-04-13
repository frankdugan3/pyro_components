if String.to_integer(System.otp_release()) < 28, do: Mix.raise("Pyro requires OTP 28+")

defmodule PyroComponents.MixProject do
  @moduledoc false
  use Mix.Project

  @source_url "https://github.com/frankdugan3/pyro_components"
  @version "0.1.1"
  @description """
  Ready-made Phoenix components, built with Pyro.
  """
  def project do
    [
      app: :pyro_components,
      version: @version,
      description: @description,
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      test_paths: ["test"],
      name: "PyroComponents",
      source_url: @source_url,
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      compilers: [:yecc] ++ pre_compilers() ++ Mix.compilers() ++ post_compilers(),
      dialyzer: [plt_add_apps: [:ecto, :mix]]
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs, "docs.watch": :docs]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp extras do
    "documentation/**/*.md"
    |> Path.wildcard()
    |> Enum.map(fn path ->
      title =
        path
        |> Path.basename(".md")
        |> String.split(~r/[-_]/)
        |> Enum.map_join(" ", &String.capitalize/1)

      {String.to_atom(path),
       [
         title: title,
         default: title == "Get Started"
       ]}
    end)
  end

  defp groups_for_extras do
    [
      Tutorials: [
        "documentation/tutorials/get-started.md",
        ~r'documentation/tutorials'
      ]
    ]
  end

  defp docs do
    [
      main: "about",
      source_ref: "v#{@version}",
      output: "doc",
      source_url: @source_url,
      extra_section: "GUIDES",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules(),
      groups_for_functions: [
        Components: &(&1[:type] == :component),
        Macros: &(&1[:type] == :macro)
      ]
    ]
  end

  defp package do
    [
      name: :pyro_components,
      maintainers: ["Frank Polasek Dugan III"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url},
      files:
        ~w(lib documentation) ++
          ~w(README* CHANGELOG* LICENSE* mix.exs .formatter.exs)
    ]
  end

  defp groups_for_modules do
    [
      Core: [
        PyroComponents,
        PyroComponents.Design
      ],
      Components: [~r/\.Components\./]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Code quality tooling
      {:credo, ">= 0.0.0", only: [:dev, :test, :docs], runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false},
      {:doctor, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_check, ">= 0.0.0",
       [env: :prod, hex: "ex_check", only: :dev, runtime: false, repo: "hexpm"]},
      {:usage_rules, ">= 0.0.0", only: :dev},
      {:lazy_html, "~> 0.1", only: :test},
      {:mix_audit, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_test_interactive, ">= 0.0.0", only: :dev, runtime: false},
      # Build tooling
      {:ex_doc, ">= 0.0.0", only: :docs, runtime: false},
      {:mix_watch_docs, ">= 0.0.0", only: :docs, runtime: false},
      {:git_ops, ">= 0.0.0", only: :dev},
      {:makeup, ">= 0.0.0", only: :docs},
      {:makeup_eex, ">= 0.0.0", only: :docs},
      {:makeup_html, ">= 0.0.0", only: :docs},
      {:makeup_elixir, ">= 0.0.0", only: :docs},
      # Core dependencies
      # {:pyro, "~> 0.4"},
      # {:pyro, github: "frankdugan3/pyro", branch: "main"},
      {:pyro, path: "../pyro"},
      # These dependencies add optional features if installed
      {:hologram, "~> 0.8", optional: true},
      {:phoenix_live_view, "~> 1.1", optional: true},
      {:tzdata, "~> 1.1", optional: true},
      {:tz_extra, "~> 0.45", optional: true}
    ]
  end

  defp pre_compilers, do: filter_installed([:phoenix_live_view])
  defp post_compilers, do: filter_installed([:hologram])

  defp filter_installed(compilers) do
    installed = Map.keys(Mix.Project.deps_paths())
    Enum.filter(compilers, &(&1 in installed))
  end

  defp aliases do
    [
      setup: [
        "deps.get",
        "compile",
        "docs"
      ],
      # Until we hit 1.0, ensure no major release!
      release: [
        "git_ops.release --no-major"
      ],
      publish: [
        "hex.publish"
      ]
    ]
  end
end
