defmodule PyroComponents.Components.Pagination do
  @moduledoc false
  use Pyro.Component

  import PyroComponents.Components.Core

  attr :overrides, :list, default: nil, doc: @overrides_attr_doc
  attr :target_id, :string, required: true
  attr :page, :map, default: nil
  attr :page_limit_options, :list, default: [10, 25, 50, 100, 250, 500, 1_000]
  attr :class, :css_classes, overridable: true
  attr :first_class, :css_classes, overridable: true
  attr :first_icon, :string, overridable: true, required: true
  attr :first_icon_class, :css_classes, overridable: true
  attr :previous_class, :css_classes, overridable: true
  attr :previous_icon, :string, overridable: true, required: true
  attr :previous_icon_class, :css_classes, overridable: true
  attr :next_class, :css_classes, overridable: true
  attr :next_icon, :string, overridable: true, required: true
  attr :next_icon_class, :css_classes, overridable: true
  attr :last_class, :css_classes, overridable: true
  attr :last_icon, :string, overridable: true, required: true
  attr :last_icon_class, :css_classes, overridable: true
  attr :reset_class, :css_classes, overridable: true
  attr :top_class, :css_classes, overridable: true
  attr :top_icon, :string, overridable: true, required: true
  attr :top_icon_class, :css_classes, overridable: true
  attr :limit_form_class, :css_classes, overridable: true
  attr :limit_form_label_class, :css_classes, overridable: true
  attr :limit_form_input_class, :css_classes, overridable: true
  attr :limit_form_input_option_class, :css_classes, overridable: true

  def pagination(assigns) do
    assigns = assign_overridables(assigns)

    ~H"""
    <div class={@class}>
      <button
        :if={@page[:offset]}
        class={@first_class}
        disabled={!prev_page?(@page)}
        title="First Page"
        phx-click={
          JS.dispatch("pyro:scroll-top", detail: %{id: @target_id})
          |> JS.push("change-page-number")
        }
        phx-value-target-id={@target_id}
        phx-value-offset={0}
      >
        <.icon name={@first_icon} class={@first_icon_class} />
      </button>
      <button
        :if={@page[:offset]}
        class={@previous_class}
        disabled={!prev_page?(@page)}
        title="Previous Page"
        phx-click={
          JS.dispatch("pyro:scroll-top", detail: %{id: @target_id})
          |> JS.push("change-page-number")
        }
        phx-value-target-id={@target_id}
        phx-value-offset={max(0, @page.offset - @page.limit)}
      >
        <.icon name={@previous_icon} class={@previous_icon_class} />
      </button>
      <button
        :if={@page[:offset]}
        class={@next_class}
        disabled={!next_page?(@page)}
        title="Next Page"
        phx-click={
          JS.dispatch("pyro:scroll-top", detail: %{id: @target_id})
          |> JS.push("change-page-number")
        }
        phx-value-target-id={@target_id}
        phx-value-offset={@page.offset + @page.limit}
      >
        <.icon name={@next_icon} class={@next_icon_class} />
      </button>
      <button
        :if={@page[:offset]}
        class={@last_class}
        disabled={!next_page?(@page)}
        title="Last Page"
        phx-click={
          JS.dispatch("pyro:scroll-top", detail: %{id: @target_id})
          |> JS.push("change-page-number")
        }
        phx-value-target-id={@target_id}
        phx-value-offset={page_count(@page) * @page.limit}
      >
        <.icon name={@last_icon} class={@last_icon_class} />
      </button>
      <form :if={@page[:offset]} phx-change="change-page-limit" class={@limit_form_class}>
        <input type="hidden" name="pagination_form[target-id]" value={@target_id} />
        <label class={@limit_form_label_class}>Limit:</label>
        <select name="pagination_form[limit]" class={@limit_form_input_class}>
          <option selected value={@page.limit} class={@limit_form_input_option_class}>
            <%= delimit_integer(@page.limit) %>
          </option>
          <option
            :for={limit <- @page_limit_options}
            value={limit}
            class={@limit_form_input_option_class}
          >
            <%= delimit_integer(limit) %>
          </option>
        </select>
      </form>
      <span :if={@page[:count]}><%= page_info(@page) %></span>
      <button
        class={@reset_class}
        title="Reset Page/Filter/Sort"
        phx-click={
          JS.dispatch("pyro:scroll-top", detail: %{id: @target_id})
          |> JS.push("reset-list")
        }
        phx-value-target-id={@target_id}
      >
        Reset
      </button>
      <button
        class={@top_class}
        title="Scroll to top of page"
        phx-click={JS.dispatch("pyro:scroll-top", detail: %{id: @target_id})}
        phx-value-target-id={@target_id}
      >
        <.icon name={@top_icon} class={@top_icon_class} />
      </button>
    </div>
    """
  end

  defp prev_page?(%{offset: 0}), do: false
  defp prev_page?(%{after: nil}), do: false
  defp prev_page?(_), do: true

  defp next_page?(%{more?: true}), do: true

  defp next_page?(%{offset: offset, count: count, limit: limit})
       when is_integer(offset) and is_integer(count) and is_integer(limit) do
    if offset + limit < count do
      true
    else
      false
    end
  end

  defp page_number(%{offset: 0}), do: 0

  defp page_number(%{offset: offset, limit: limit}) do
    if rem(offset, limit) == 0 do
      div(offset, limit)
    else
      div(offset, limit) + 1
    end
  end

  defp page_number(_), do: raise("Need to implement keyset pagination!")

  defp page_count(%{count: 0}), do: 0

  defp page_count(%{count: count, limit: limit}) do
    if_result =
      if rem(count, limit) == 0 do
        div(count, limit)
      else
        div(count, limit) + 1
      end

    Kernel.-(if_result, 1)
  end

  defp page_count(_), do: raise("Need to implement keyset pagination!")

  defp page_info(%{offset: _} = page) do
    n =
      page
      |> page_number()
      |> Kernel.+(1)
      |> delimit_integer()

    c =
      page
      |> page_count()
      |> Kernel.+(1)
      |> delimit_integer()

    t = delimit_integer(page.count)
    "Page #{n} of #{c} (#{t} total)"
  end

  defp page_info(%{count: count}) when is_integer(count) do
    "(#{delimit_integer(count)} total)"
  end

  defp delimit_integer(number), do: floor(number)
end
