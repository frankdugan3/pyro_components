defmodule PyroComponents.Defaults.TailwindLayered do
  @moduledoc """
  A library containing a set of defaults for `PyroComponents` and a strategy using Tailwind and CSS layers.

  #### Examples

  ```elixir
  defmodule MyAppWeb.CoreComponents do
    use Pyro, component_libraries: [
      PyroComponents,
      PyroComponents.Defaults.TailwindLayered
    ]
  end
  ```
  """
  use Pyro, library?: true, css_strategy: :tailwind_layered

  @doc """
  A function to provide a color scheme. You can customize it by wrapping it, or reimplementing it. The templates will look up the colors by key to generate the CSS file.
  """
  def tailwind_color(color) do
    case color do
      "red" -> "@apply bg-red-500 text-white;"
    end
  end

  variables %{
    prefix: "pyro-",
    component_layer: "tailwind.components",
    variant_layer: "tailwind.variants",
    # colors: ~w[
    #   black white
    #   slate gray zinc neutral stone
    #   orange amber yellow
    #   lime green emerald
    #   teal cyan sky blue
    #   indigo violet purple fuchsia
    #   pink rose red
    # ],
    tailwind_color: &__MODULE__.tailwind_color/1,
    colors: ~w[red],
    sizes: ~w[xs sm base lg xl],
    button_variants: ~w[solid outline]
  }
end
