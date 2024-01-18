defmodule PyroComponents do
  @moduledoc """
  `Pyro` is a component library for `Phoenix`.

  To learn more, check out the [About](about.html) page.

  To install, follow the [Get Started](get-started.html) guide.

   The easiest way to use PyroComponents is to import them into `my_app_web.ex` helpers to make the available in all views and components:

   ```elixir
   defp html_helpers do
     quote do
       # Import all PyroComponents
       use PyroComponents
       # ...
   ```

  Comprehensive installation instructions can be found in [Get Started](get-started.md).

  Pyro provides components that support deep customization through `Pyro.Overrides`, and also tooling to create your own via `Pyro.Component`.

  > #### Note: {: .warning}
  >
  > Pyro's component names conflict with the generated `CoreComponents`. You will need to remove `import MyAppWeb.CoreComponents`.
  """

  defmacro __using__(_) do
    quote do
      import PyroComponents.Components.Core
      import PyroComponents.Components.DataTable

      alias PyroComponents.Components.Autocomplete
    end
  end
end
