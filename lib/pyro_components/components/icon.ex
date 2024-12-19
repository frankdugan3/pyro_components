defmodule PyroComponents.Icon do
  @moduledoc """
  A `Pyro` component libary containing an icon component. You will need to either import a set of default variables or define them yourself.

  #### Examples

  ```elixir
  defmodule MyAppWeb.CoreComponents do
    use Pyro, component_libraries: [
      PyroComponents.Icon,
      PyroComponents.Defaults.TailwindLayered
    ]
  end
  ```
  """
  use Pyro, library?: true, implements_css_strategies: [:tailwind_layered]

  component :button do
    doc """
    Renders an icon.

    You can write your own Tailwind plugin to support just about any icon system, but PyroComponents provides a plugin that supports:

    - [Heroicons](https://heroicons.com)
    - [Tabler Icons](https://tabler.io/icons)
    - [Lucide Icons](https://lucide.dev)

    ## Setup

    Add one or more of the libraries to your `mix.exs` deps:

    ```elixir
    [
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.3",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:tabler_icons,
       github: "tabler/tabler-icons",
       sparse: "icons",
       app: false,
       compile: false,
       depth: 1},
      {:lucide_icons,
       github: "lucide-icons/lucide",
       sparse: "icons",
       app: false,
       compile: false,
       depth: 1},
    ]
    ```

    Add the Tailwind plugin to your `tailwind.config.js`, including all the libraries you added to your deps:

    ```js
    plugins: [
      require(path.join(
        __dirname,
        '../deps/pyro_components/assets/js/tailwind-icons.js',
      ))({
        icons: ['heroicons', 'tabler_icons', 'lucide_icons'],
      }),
    ],
    ```

    ## Examples

    ```heex
    <.icon name="hero-x-circle" />
    ```
    """

    css_class :class, ~E|<%= vars.prefix %>icon| do
      strategy :tailwind_layered
    end

    attr :name, :string, doc: "the name of the icon to display", required: true

    template ~H"""
    <span class={[@name, @class]} />
    """
  end
end
