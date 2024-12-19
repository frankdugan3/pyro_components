defmodule PyroComponents do
  @moduledoc """
  A `Pyro` component libary that includes a full suite of components. You will need to either import a set of default variables or define them yourself. If you want a more à la carte approach, you can instead indidually import the components you want.

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

  use Pyro, component_libraries: [PyroComponents.Button, PyroComponents.Icon], library?: true
end
