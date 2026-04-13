# Used by "mix format"
[
  import_deps: [:hologram, :phoenix, :phoenix_live_view, :pyro],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs,holo}"
  ]
]
