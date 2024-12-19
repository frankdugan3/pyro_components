defmodule PyroComponents.Defaults.HeadlessBem do
  @moduledoc """
  A library containing a set of defaults for `PyroComponents` using a BEM strategy.

  It scaffolds BEM classes for all the components, but expects you to provide the styles for each class.

  #### Examples

  ```elixir
  defmodule MyAppWeb.CoreComponents do
    use Pyro, component_libraries: [
      PyroComponents,
      PyroComponents.Defaults.HeadlessBem
    ]
  end
  ```
  """
  use Pyro, library?: true, css_strategy: :headless_bem

  variables %{
    prefix: "pyro-",
    colors: ~w[red green yellow],
    sizes: ~w[xs sm base lg xl],
    button_variants: ~w[solid outline]
  }
end
