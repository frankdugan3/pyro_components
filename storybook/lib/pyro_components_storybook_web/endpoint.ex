defmodule PyroComponentsStorybookWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pyro_components_storybook

  @session_options [
    store: :cookie,
    key: "_pyro_components_storybook_key",
    signing_salt: "mZGOhVTW",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :pyro_components_storybook,
    gzip: false,
    only: PyroComponentsStorybookWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PyroComponentsStorybookWeb.Router
end