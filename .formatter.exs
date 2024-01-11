# Used by "mix format"
[
  import_deps: [:phoenix, :pyro],
  plugins: [Phoenix.LiveView.HTMLFormatter, Styler],
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib}/**/*.{heex,ex,exs}",
    "storybook/*.{heex,ex,exs}",
    "storybook/{config,lib,storybook}/**/*.{heex,ex,exs}"
  ]
]
