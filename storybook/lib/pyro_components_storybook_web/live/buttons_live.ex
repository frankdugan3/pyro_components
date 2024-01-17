defmodule PyroComponentsStorybookWeb.ButtonsLive do
  @moduledoc false
  use PyroComponentsStorybookWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <article class="grid gap-4 p-4">
      <%= for color <- Pyro.Overrides.override_for(PyroComponents.Core, :button, :colors) do %>
        <.button_color_examples color={color} />
      <% end %>
    </article>
    """
  end

  attr(:color, :string, required: true)

  def button_color_examples(assigns) do
    ~H"""
    <section class="grid gap-4">
      <%= for variant <- Pyro.Overrides.override_for(PyroComponents.Core, :button, :variants) do %>
        <.button_size_examples color={@color} variant={variant} />
        <.button_size_examples color={@color} variant={variant} opts={[loading: true]} />
        <.button_size_examples color={@color} variant={variant} opts={[ping: true]} />
        <.button_size_examples color={@color} variant={variant} opts={[disabled: true]} />
        <.button_size_examples color={@color} variant={variant} icon_name="hero-cpu-chip-solid" />
      <% end %>
    </section>
    """
  end

  attr :color, :string, required: true
  attr :variant, :string, required: true
  attr :icon_name, :string, default: nil
  attr :opts, :list, default: []

  def button_size_examples(assigns) do
    ~H"""
    <section class="flex flex-wrap gap-4 justify-start items-end">
      <%= for size <- Pyro.Overrides.override_for(PyroComponents.Core, :button, :sizes) do %>
        <.button color={@color} size={size} icon_name={@icon_name} variant={@variant} {@opts}>
          <%= [size | [@variant | Keyword.keys(@opts)]] |> Enum.join(" · ") %>
        </.button>
      <% end %>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "<.button>")}
  end
end
