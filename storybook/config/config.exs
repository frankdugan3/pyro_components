import Config

config :pyro,
  gettext: PyroComponentsStorybookWeb.Gettext,
  overrides: [PyroComponents.Overrides.BEM]

config :pyro_components_storybook, dev_routes: true

config :pyro_components_storybook, PyroComponentsStorybookWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: PyroComponentsStorybookWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PyroComponentsStorybook.PubSub,
  live_view: [signing_salt: "PkgkFEYY"],
  http: [ip: {127, 0, 0, 1}, port: 9001],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "lFKHsjKHiHfoQo54UezG0q23/zZMlGB9gANXk9tI43rgmLVx/DSROMJCsovQrGkD",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
    tailwind: {Tailwind, :install_and_run, [:storybook, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|j/g|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/pyro_components_storybook_web/(controllers|live|components)/.*(ex|heex)$",
      ~r"storybook/.*(exs)$"
    ]
  ]

config :esbuild,
  version: "0.20.2",
  default: [
    args:
      ~w(js/app.js js/storybook.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.1",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ],
  storybook: [
    args: ~w(
      --config=storybook.tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/storybook.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "[$level] $message\n",
  metadata: [:request_id]

config :phoenix,
  json_library: Jason,
  stacktrace_depth: 20,
  plug_init_mode: :runtime
