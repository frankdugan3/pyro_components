defmodule PyroComponents.Components.DataTable do
  @moduledoc """
  Tooling and components for rendering data tables.
  """
  use Pyro.Component

  import PyroComponents.Components.Core
  import PyroComponents.Components.Pagination

  @doc """
  A complex data table component, featuring streams, multi-column sorting and pagination.

  It is a functional component, so all emitted events are to be handled by the parent LiveView.
  """
  attr :overrides, :list, default: nil, doc: @overrides_attr_doc
  attr :id, :string, required: true

  attr :row_id, :any,
    default: nil,
    doc: "the function for generating the row id"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  attr :rows, :list, required: true
  attr :page_limit_options, :list, default: [10, 25, 50, 100, 250, 500, 1_000]
  attr :page, :map, default: nil
  attr :sort, :list, required: true
  attr :class, :css_classes, overridable: true
  attr :header_class, :css_classes, overridable: true
  attr :body_class, :css_classes, overridable: true
  attr :row_class, :css_classes, overridable: true
  attr :row_actions_class, :css_classes, overridable: true
  attr :footer_class, :css_classes, overridable: true
  attr :footer_wrapper_class, :css_classes, overridable: true

  slot :col, required: true do
    attr :label, :string
    attr :class, :string
    attr :cell_class, :string
    attr :sort_key, :atom
  end

  slot :header_action, doc: "the slot for showing user actions in the last table column header"
  slot :action, doc: "the slot for showing user actions in the last table column"

  def data_table(assigns) do
    assigns = assign_overridables(assigns)

    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <table id={@id} class={@class}>
      <thead class={@header_class}>
        <tr>
          <.th :for={col <- @col} table_id={@id} sort={@sort} {col} />
        </tr>
      </thead>
      <tbody class={@body_class}>
        <tr :for={row <- @rows} class={@row_class} id={@row_id && @row_id.(row)}>
          <.cell :for={col <- @col} class={col[:cell_class]}>
            <%= render_slot(col, @row_item.(row)) %>
          </.cell>
          <.cell :if={@action != []} class={@row_actions_class}>
            <%= render_slot(@action, @row_item.(row)) %>
          </.cell>
        </tr>
      </tbody>
      <tfoot>
        <tr>
          <td class={@footer_class} colspan={length(@col) + if @action != [], do: 1, else: 0}>
            <div class={@footer_wrapper_class}>
              <.pagination
                page={@page || %{count: length(@rows)}}
                page_limit_options={@page_limit_options}
                target_id={@id}
              />
            </div>
          </td>
        </tr>
      </tfoot>
    </table>
    """
  end

  attr :overrides, :list, default: nil, doc: @overrides_attr_doc
  attr :table_id, :string, required: true
  attr :sort, :list, required: true
  attr :label, :string, required: true
  attr :class, :css_classes, overridable: true
  attr :btn_class, :css_classes, overridable: true
  attr :sort_key, :atom, default: nil

  defp th(%{sort_key: sort_key} = assigns) when not is_nil(sort_key) do
    sort = assigns[:sort]

    {direction, position} =
      Enum.reduce_while(sort, {nil, 0}, fn
        {k, direction}, {_, i} when k == sort_key -> {:halt, {direction, i + 1}}
        _, {_, i} -> {:cont, {nil, i + 1}}
      end)

    assigns =
      assigns
      |> assign(:direction, direction)
      |> assign(:position, if(length(sort) > 1, do: position, else: 0))
      |> assign_overridables()

    ~H"""
    <th class={@class}>
      <button
        id={"#{@table_id}-#{@label}"}
        class={@btn_class}
        type="button"
        phx-click={
          JS.dispatch("pyro:scroll-top", detail: %{id: @table_id})
          |> JS.push("change-sort")
        }
        phx-value-sort-key={@sort_key}
        phx-value-component-id={@table_id}
      >
        <%= @label %>
        <.sort_icon direction={@direction} position={@position} />
      </button>
    </th>
    """
  end

  defp th(assigns) do
    assigns = assign_overridables(assigns)

    ~H"""
    <th id={"#{@table_id}-#{@label}"} class={@class}>
      <%= @label %>
    </th>
    """
  end

  attr :overrides, :list, default: nil, doc: @overrides_attr_doc
  attr :class, :css_classes, overridable: true
  slot :inner_block, required: true

  defp cell(assigns) do
    assigns = assign_overridables(assigns)

    ~H"""
    <td class={@class}>
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  attr :overrides, :list, default: nil, doc: @overrides_attr_doc
  attr :direction, :atom, required: true
  attr :position, :integer, required: true
  attr :sort_icon_name, :string, overridable: true
  attr :class, :css_classes, overridable: true
  attr :index_class, :css_classes, overridable: true

  defp sort_icon(%{direction: nil} = assigns) do
    assigns = assign_overridables(assigns)
    ~H""
  end

  defp sort_icon(%{position: 0} = assigns) do
    assigns = assign_overridables(assigns)

    ~H"""
    <.icon name={@sort_icon_name} class={@class} />
    """
  end

  defp sort_icon(assigns) do
    assigns = assign_overridables(assigns)

    ~H"""
    <.icon name={@sort_icon_name} class={@class} />
    <span class={@index_class}>
      <%= @position %>
    </span>
    """
  end

  @doc """
  Stringifies the columns to display for storage in a url param.
  """
  def encode_display(display) do
    Enum.map_join(display, ",", fn k -> "#{k}" end)
  end

  @doc """
  Stringifies the column sorting for storage in a url param.
  """
  def encode_sort(sort) do
    sort
    |> List.wrap()
    |> Enum.map_join(",", fn
      nil -> ""
      k when is_atom(k) -> "#{k}"
      k when is_binary(k) -> k
      {k, :asc} -> "#{k}"
      {k, :asc_nils_last} -> "#{k}"
      {k, :asc_nils_first} -> "++#{k}"
      {k, :desc} -> "-#{k}"
      {k, :desc_nils_first} -> "-#{k}"
      {k, :desc_nils_last} -> "--#{k}"
    end)
  end

  @doc """
  Toggles the column sorting.
  """
  def toggle_sort(sort, sort_key, ctrl?, shift?) do
    sort
    |> sanitize_sort()
    |> find_sort_key(sort_key)
    |> toggle_sort_key(sort_key, ctrl?, shift?)
    |> encode_sort()
  end

  defp sanitize_sort(sort) do
    Enum.map(sort, fn
      {k, v} when is_atom(k) -> {Atom.to_string(k), v}
      {k, v} -> {k, v}
    end)
  end

  defp find_sort_key(sort, sort_key) do
    {sort, Enum.find(sort, fn {k, _v} -> k == sort_key end)}
  end

  defp toggle_sort_key({sort, nil}, sort_key, _ctrl?, shift?) do
    added = [{sort_key, :asc}]
    if shift?, do: sort ++ added, else: added
  end

  defp toggle_sort_key({sort, {_key, _order}}, sort_key, ctrl?, shift?) when length(sort) > 1 and shift? do
    sort
    |> Enum.map(fn
      {k, order} when sort_key == k ->
        {k, toggle_sort_order(order, ctrl?, shift?)}

      other ->
        other
    end)
    |> Enum.filter(fn {_key, order} -> order != nil end)
  end

  defp toggle_sort_key({_sort, {_key, order}}, sort_key, ctrl?, _shift?) do
    [{sort_key, toggle_sort_order(order, ctrl?, false)}]
  end

  # args: column, change_nil_position?, multiple_columns?
  # don't change nil position, single sort
  defp toggle_sort_order(order, false, false) do
    case order do
      :asc -> :desc
      :asc_nils_last -> :desc
      :asc_nils_first -> :desc_nils_last
      :desc -> :asc
      :desc_nils_first -> :asc
      :desc_nils_last -> :asc_nils_first
    end
  end

  # don't change nil position, multi sort
  defp toggle_sort_order(order, false, true) do
    case order do
      :asc -> :desc
      :asc_nils_last -> :desc
      :asc_nils_first -> :desc_nils_last
      :desc -> nil
      :desc_nils_first -> nil
      :desc_nils_last -> nil
    end
  end

  # change nil position, any sort
  defp toggle_sort_order(order, true, _) do
    case order do
      :asc -> :asc_nils_first
      :asc_nils_last -> :asc_nils_first
      :asc_nils_first -> :asc
      :desc -> :desc_nils_last
      :desc_nils_first -> :desc_nils_last
      :desc_nils_last -> :desc
    end
  end
end
