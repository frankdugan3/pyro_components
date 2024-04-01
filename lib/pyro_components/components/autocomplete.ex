defmodule PyroComponents.Components.Autocomplete do
  @moduledoc """
  A flexible autocomplete component for Phoenix forms.
  """
  use Pyro.LiveComponent

  import PyroComponents.Components.Core, only: [error: 1, label: 1, input: 1]
  # import Pyro.Gettext

  @doc """
  A simple autocomplete component.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.live_component
          module={PyroComponents.Components.Autocomplete}
          id="fiend_id_autocomplete"
          field={@form[:friend_id]}
          label="Friend"
          search_fn={&search_friends/1}
          lookup_fn={&lookup_friend/1} />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """

  attr :overrides, :list, default: nil, doc: @overrides_attr_doc
  attr :type, :atom, values: [:map, :id], default: :id
  attr :throttle_time, :integer, overridable: true, required: true
  attr :option_label_key, :atom, overridable: true, required: true
  attr :option_value_key, :atom, overridable: true, required: true
  attr :prompt, :string, overridable: true, required: true, doc: "the prompt for search input"
  attr :description, :string, default: nil
  attr :errors, :list, default: []
  attr :label, :string, default: nil, doc: "the label for the input (not the label key value of the record)"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :required, :boolean, default: false

  attr :search_fn, :any,
    required: true,
    doc: "the arity-1 function to get options from search term"

  attr :lookup_fn, :any,
    required: true,
    doc: "the arity-1 function to get lookup/convert value to option"

  attr :no_results_message, :string,
    default: "[no results]",
    doc: "the message to display if there are no results for the search phrase"

  attr :field, Phoenix.HTML.FormField, doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :autofocus, :boolean,
    default: false,
    doc: "enable autofocus hook to reliably focus input on mount"

  attr :class, :css_classes, overridable: true

  attr :input_class, :css_classes,
    overridable: true,
    doc: "class of the input element"

  attr :listbox_wrapper_class, :css_classes,
    overridable: true,
    doc: "class of the listbox wrapper element"

  attr :listbox_class, :css_classes,
    overridable: true,
    doc: "class of the listbox element"

  attr :listbox_option_class, :css_classes,
    overridable: true,
    doc: "class of the listbox option element"

  attr :description_class, :css_classes,
    overridable: true,
    doc: "class of the field description"

  slot :option_template

  def render(assigns) do
    assigns = assign_overridables(assigns)

    ~H"""
    <div
      id={@id}
      class={@class}
      phx-click-away={expanded?(@results, @search, @saved_label) && "cancel"}
      phx-target={@myself}
    >
      <.input
        :if={@type == :id}
        type="hidden"
        data-autocomplete-id={@id <> "search"}
        data-value-key={@option_value_key}
        field={@field}
        value={@value}
      />
      <%= if @type == :map do %>
        <input
          type="hidden"
          name={"#{@field.name}[#{@option_value_key}]"}
          data-autocomplete-id={@id <> "search"}
          data-value-key={@option_value_key}
          value={@value}
        />
        <input
          type="hidden"
          name={"#{@field.name}[#{@option_label_key}]"}
          data-autocomplete-id={@id <> "search"}
          data-label-key={@option_label_key}
          value={@saved_label}
        />
      <% end %>
      <.label for={@id <> "-search"} overrides={@overrides}><%= @label %></.label>
      <input
        id={@id <> "-search"}
        type="text"
        name={@id <> "-search"}
        value={@search}
        class={@input_class}
        role="combobox"
        aria-expanded={expanded?(@results, @search, @saved_label)}
        aria-controls={@id <> "-listbox"}
        placeholder={@prompt}
        phx-hook="PyroAutocompleteComponent"
        phx-target={@myself}
        data-myself={@myself}
        data-type={@type}
        data-option-value-key={@option_value_key}
        data-option-label-key={@option_label_key}
        data-selected-index={@selected_index}
        data-results-count={length(@results)}
        data-saved-label={@saved_label}
        data-autofocus={@autofocus}
        data-throttle-time={@throttle_time}
        data-select-on-focus
        autocomplete="off"
      />
      <div :if={expanded?(@results, @search, @saved_label)} class={@listbox_wrapper_class}>
        <ul id={@id <> "-listbox"} role="listbox" class={@listbox_class}>
          <li
            :for={{option, i} <- Enum.with_index(@results)}
            id={"#{@id}-search-result-#{Map.get(option, @option_value_key)}"}
            role="option"
            aria-selected={i == @selected_index}
            data-value={Map.get(option, @option_value_key)}
            data-label={Map.get(option, @option_label_key)}
            data-index={i}
            class={@listbox_option_class}
            phx-click={JS.dispatch("pick", to: "##{@id}-search")}
          >
            <%= render_slot(@option_template, option) || Map.get(option, @option_label_key) %>
          </li>
          <li
            :if={@results == []}
            id={"#{@id}-search-result-none"}
            role="option"
            tabindex="-1"
            class={@listbox_option_class}
          >
            <%= @no_results_message %>
          </li>
        </ul>
      </div>
      <p :if={@description} class={@description_class}>
        <%= @description %>
      </p>
      <.error errors={@errors} overrides={@overrides} />
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:search, nil)
     |> assign(:field, :unset)
     |> assign(:saved_label, nil)
     |> assign(:saved_value, nil)
     |> assign(:selected_index, -1)
     |> assign(:results, [])}
  end

  @impl true
  def update(%{field: %{value: value} = field, type: :id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
     |> assign(:value, value)
     |> assign(:saved_value, value)
     |> assign(:selected_index, -1)
     |> assign(:results, [])
     |> assign_label()}
  end

  @impl true
  def update(
        %{
          field: %{value: [%{data: data, params: params}]} = field,
          type: :map,
          option_label_key: option_label_key,
          option_value_key: option_value_key
        } = assigns,
        socket
      ) do
    label = Map.get(params, Atom.to_string(option_label_key)) || Map.get(data, option_label_key)
    value = Map.get(params, Atom.to_string(option_value_key)) || Map.get(data, option_value_key)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
     |> assign(:saved_label, label)
     |> assign(:search, label)
     |> assign(:value, value)
     |> assign(:saved_value, value)
     |> assign(:selected_index, -1)
     |> assign(:results, [])}
  end

  @impl true
  def handle_event("search", search, %{assigns: %{search_fn: search_fn}} = socket) do
    {:noreply,
     socket
     |> assign(:search, search)
     |> assign(:results, search_fn.(search))
     |> case do
       %{assigns: %{results: []}} = socket ->
         assign(socket, :selected_index, -1)

       %{assigns: %{search: search}} = socket when search == "" or is_nil(search) ->
         assign(socket, :selected_index, -1)

       socket ->
         assign(socket, :selected_index, 0)
     end}
  end

  @impl true
  def handle_event("cancel", _, %{assigns: %{results: results}} = socket) when results != [] do
    {:noreply,
     socket
     |> assign(:selected_index, -1)
     |> assign(:search, socket.assigns.saved_label)
     |> assign(:results, [])}
  end

  def handle_event("cancel", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("pick", %{"label" => label, "value" => value}, socket) do
    {:noreply,
     socket
     |> assign(:search, label)
     |> assign(:value, value)
     |> assign(:saved_value, value)
     |> assign(:saved_label, label)
     |> assign(:selected_index, -1)
     |> assign(:results, [])}
  end

  defp assign_label(%{assigns: %{value: nil}} = socket) do
    socket
    |> assign(:search, nil)
    |> assign(:saved_value, nil)
  end

  defp assign_label(
         %{assigns: %{value: value, saved_value: saved_value, lookup_fn: lookup_fn, option_label_key: option_label_key}} =
           socket
       )
       when value != saved_value do
    label = Map.get(lookup_fn.(value), option_label_key)

    socket
    |> assign(:saved_label, label)
    |> assign(:search, label)
    |> assign(:saved_value, value)
  end

  defp assign_label(socket), do: socket

  defp expanded?(results, _search, _saved_label) when results != [], do: true

  defp expanded?(_results, search, saved_label) when is_binary(search) and search != "" and search !== saved_label,
    do: true

  defp expanded?(_results, _search, _saved_label), do: false
end
