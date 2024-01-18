defmodule Storybook.Components.A do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  def function, do: &PyroComponents.Components.Core.a/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{href: "#"},
        slots: [
          "An ordinary link"
        ]
      }
    ]
  end
end
