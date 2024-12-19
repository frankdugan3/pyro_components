# Used by "mix format"
[
  import_deps: [:phoenix, :pyro],
  plugins: [Phoenix.LiveView.HTMLFormatter, Spark.Formatter],
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}"
  ]
]
