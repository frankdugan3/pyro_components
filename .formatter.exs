# Used by "mix format"
[
  # import_deps: [:phoenix, :pyro],
  import_deps: [:phoenix],
  # plugins: [Phoenix.LiveView.HTMLFormatter, Spark.Formatter],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}"
  ]
]
