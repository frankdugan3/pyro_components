defmodule PyroComponentsStorybookWeb do
  @moduledoc false
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import Plug.Conn
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: PyroComponentsStorybookWeb.Layouts]

      import Plug.Conn
      import PyroComponentsStorybookWeb.Gettext

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PyroComponentsStorybookWeb.Endpoint,
        router: PyroComponentsStorybookWeb.Router,
        statics: PyroComponentsStorybookWeb.static_paths()
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
