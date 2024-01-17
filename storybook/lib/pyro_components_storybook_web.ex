defmodule PyroComponentsStorybookWeb do
  @moduledoc false
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def live_view do
    quote do
      use Pyro.LiveView,
        layout: {PyroComponentsStorybookWeb.Layouts, :app},
        container: {:div, class: "grid overflow-hidden grid-rows-[auto,1fr]"}

      unquote(html_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import Plug.Conn
    end
  end

  def html do
    quote do
      use Pyro.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      use PyroComponents

      import Phoenix.HTML
      import PyroComponentsStorybookWeb.Gettext

      # HTML escaping functionality
      # Core UI components and translation

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
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
        formats: [:html, :json]

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
