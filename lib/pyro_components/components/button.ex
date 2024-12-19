defmodule PyroComponents.Button do
  @moduledoc """
  A `Pyro` component libary containing a button component. You will need to either import a set of default variables or define them yourself.

  #### Examples

  ```elixir
  defmodule MyAppWeb.CoreComponents do
    use Pyro, component_libraries: [
      PyroComponents.Button,
      PyroComponents.Defaults.TailwindLayered
    ]
  end
  ```
  """
  use Pyro, library?: true, implements_css_strategies: [:tailwind_layered]

  component :button do
    doc """
    Renders a button.

    Supports:

    - Any button type
    - Any anchor type
    - LivePatch
    - LiveRedirect
    - External href links

    ## Examples

    ```heex
    <.button>Send!</.button>
    <.button phx-click="go" class="ml-2">Send!</.button>
    <.button navigate={~p"/home"}>Home</.button>
    ```
    """

    css_class :class, ~E|<%= vars.prefix %>btn| do
      variants [:variant, :size, :color]

      strategy :tailwind_layered do
        template ~E"""
        @layer <%= vars.component_layer %> {
          .<%= base_class %> {
            @apply appearance-none select-none focus:outline-none;
            @apply relative inline-block;
            @apply text-base text-center whitespace-nowrap;
            @apply cursor-pointer disabled:cursor-not-allowed;
            @apply disabled:opacity-50 active:opacity-50;
            @apply focus:ring-4 border-solid border-2 rounded
            @apply shadow shadow-slate-700/10 dark:shadow-slate-950/100;
            @apply px-5 py-1.5;
          }
        }
        @layer <%= vars.variant_layer %> {<%= for color <- variants[:color] do %>
          .<%= base_class %>.<%= color %> {
            <%= apply(vars.tailwind_color, [color]) %>
          }<% end %>
        }
        """
      end
    end

    # css_class :icon_class
    # css_class :ping_class
    #
    # css_class :ping_animation_class do
    #   template ~E"""
    #   .<%= vars.prefix %><%= css.base_class %> {
    #     @apply bg-red-500;
    #   }
    #   """
    # end

    attr :confirm, :string, doc: "text to display in a confirm dialog before emitting click event"

    attr :csrf_token, :string
    attr :disabled, :boolean, default: false
    attr :href, :any

    attr :icon_name, :string,
      doc: "the name of the icon to display (nil for none); see `icon/1` for details"

    attr :loading, :boolean, default: false, doc: "display a loading spinner"
    attr :method, :string, default: "get"
    attr :navigate, :string
    attr :patch, :string
    attr :ping, :boolean, default: false, doc: "show a ping indicator"
    attr :replace, :boolean, default: false
    # include: ~w[download hreflang referrerpolicy rel target form name value]
    attr :rest, :global

    attr :type, :string,
      default: "button",
      values: ~w[button reset submit],
      doc: "type of the button"

    attr :color, :string,
      required: true,
      values: {:var, :colors},
      doc: "the color of the button"

    attr :size, :string, required: true, values: {:var, :sizes}, doc: "the size of the button"

    attr :variant, :string,
      required: true,
      values: {:var, :button_variants},
      doc: "style of button"

    attr :template_type, :atom do
    end

    slot :inner_block, required: true, doc: "the content of the button"

    template ~H"""
    <%= case @template_type do %>
      <% :href -> %>
        <.link
          href={@href}
          replace={@replace}
          method={@method}
          csrf_token={@csrf_token}
          data-confirm={@confirm}
          data-submit={!!@confirm}
          class={@class}
          {@rest}
        >
          <.spinner :if={@loading} size={@size} />
          <.icon :if={!@loading && @icon_name} name={@icon_name} class={@icon_class} />
          <%= render_slot(@inner_block) %>
          <%= if @ping do %>
            <span class={@ping_animation_class} />
            <span class={@ping_class} />
          <% end %>
        </.link>
      <% :patch -> %>
        <.link
          patch={@patch}
          replace={@replace}
          data-confirm={@confirm}
          data-submit={!!@confirm}
          class={@class}
          {@rest}
        >
          <.spinner :if={@loading} size={@size} />
          <.icon :if={!@loading && @icon_name} name={@icon_name} class={@icon_class} />
          <%= render_slot(@inner_block) %>
          <%= if @ping do %>
            <span class={@ping_animation_class} />
            <span class={@ping_class} />
          <% end %>
        </.link>
      <% :navigate -> %>
        <.link
          navigate={@navigate}
          replace={@replace}
          data-confirm={@confirm}
          data-submit={!!@confirm}
          class={@class}
          {@rest}
        >
          <.spinner :if={@loading} size={@size} />
          <.icon :if={!@loading && @icon_name} name={@icon_name} class={@icon_class} />
          <%= render_slot(@inner_block) %>
          <%= if @ping do %>
            <span class={@ping_animation_class} />
            <span class={@ping_class} />
          <% end %>
        </.link>
      <% _ -> %>
        <button
          type={@type}
          disabled={@disabled}
          data-confirm={@confirm}
          data-submit={!!@confirm}
          class={@class}
          {@rest}
        >
          <.spinner :if={@loading} size={@size} />
          <.icon :if={!@loading && @icon_name} name={@icon_name} class={@icon_class} />
          <%= render_slot(@inner_block) %>
          <%= if @ping do %>
            <span class={@ping_animation_class} />
            <span class={@ping_class} />
          <% end %>
        </button>
    <% end %>
    """
  end
end
