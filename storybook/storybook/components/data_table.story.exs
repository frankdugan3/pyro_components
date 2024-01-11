defmodule Storybook.Components.DataTable do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  def function, do: &PyroComponents.DataTable.data_table/1

  @characters [
    %{name: "Luke Skywalker", homeworld: "Tatooine", weapon: "Lightsaber"},
    %{name: "Princess Leia Organa", homeworld: "Alderaan", weapon: "Blaster"},
    %{name: "Han Solo", homeworld: "Corellia", weapon: "Blaster"},
    %{name: "Chewbacca", homeworld: "Kashyyyk", weapon: "Bowcaster"},
    %{name: "Obi-Wan Kenobi", homeworld: "Stewjon", weapon: "Lightsaber"},
    %{name: "Darth Vader", homeworld: "Tatooine", weapon: "Lightsaber"},
    %{name: "Emperor Palpatine", homeworld: "Naboo", weapon: "Lightsaber"},
    %{name: "Yoda", homeworld: "Dagobah", weapon: "Lightsaber"}
  ]

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          rows: @characters,
          sort: []
        },
        slots: [
          ~s|<:col :let={row} sort_key="name" label="Name"><%= row.name %></:col>|,
          ~s|<:col :let={row} label="Homeworld"><%= row.homeworld %></:col>|,
          ~s|<:col :let={row} label="Weapon"><%= row.weapon %></:col>|
        ]
      }
    ]
  end
end
