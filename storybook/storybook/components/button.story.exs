defmodule Storybook.Components.Button do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  def function, do: &PyroComponents.Components.Core.button/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          "Default Button"
        ]
      }
    ]
  end
end
