defmodule Storybook.Components.Button do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  def function, do: &PyroComponents.Core.button/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          "Make Components Great Again"
        ]
      }
    ]
  end
end