defmodule PyroComponents do
  @moduledoc """
  A `Pyro` component libary that includes a full suite of components. If you want a more à la carte approach, you can instead indidually import the components you want.
  """

  defmacro __using__(_opts) do
    quote do
      import PyroComponents.Core
    end
  end
end
