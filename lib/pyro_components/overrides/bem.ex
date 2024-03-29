defmodule PyroComponents.Overrides.BEM do
  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity
  @moduledoc """
  This overrides file adds [BEM](https://getbem.com/) classes to all Pyro components. It does not define any style.

  This is great if you want to fully customize your own styles; all you have to do is define the classes in your CSS file.

  ## Configuration

  As with any Pyro overrides, you need to include the override file in your `config.exs` file:

  ```elixir
  config :pyro, :overrides, [PyroComponents.Overrides.BEM]
  ```

  Then, just implement the component classes listed in [Overrides](#module-overrides) in your CSS file.

  In addition to the component classes, Pyro also expects the following utility classes to be implemented:

  ```css
  .hidden {
    display: none;
  }
  ```

  You can override specific settings by merging in your own overrides file, as described [here](`Pyro.Overrides`). Additionally, the BEM overrides file supports a few application config options:

  ```elixir
  # Prefix applied to all BEM classes, useful for namespacing Pyro's components in a brownfield project.
  # Defaults to `""`
  config :pyro_components, :bem_prefix, "pyro-"

  # Specify color variants. Defaults to all Tailwind colors families.
  config :pyro_components, :bem_color_variants, ["red", "green", "brand"]

  # Specify flash variants. Defaults to `~w[info error warning success]`
  config :pyro_components, :bem_flash_variants, ["danger", "warning"]

  # Specify size variants. Defaults to `~w[xs sm base lg xl]`
  config :pyro_components, :bem_size_variants, ["normal", "huge"]

  # Specify button variants. Defaults to `~w[solid outline]`
  config :pyro_components, :bem_button_variants, ["normal", "ghost"]
  ```

  ## Using with Tailwind

  The class names are built dynamically, so if you want to use Tailwind, you will need to implement your styles *without* the layer directive to ensure they are always included, and you will need to ensure you put them before the utilities import for correct precedence:

  ```css
  @tailwind base;
  @tailwind components;

  /* This will always be included in your compiled CSS */
  .button {
    /* ... */
  }

  @tailwind utilities;
  ```

  Also, be sure to remove any Pyro-related files from your `content` list in `tailwind.config.js`, otherwise you will be including unused classes from other override skins.
  """

  ##############################################################################
  ####    S T Y L E    S E T T I N G S
  ##############################################################################

  use Pyro.Overrides

  @prefix Application.compile_env(:pyro_components, :bem_prefix, "pyro_")
  @color_variants Application.compile_env(
                    :pyro_components,
                    :bem_color_variants,
                    ~w[slate gray zinc neutral stone red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose]
                  )
  @flash_variants Application.compile_env(
                    :pyro_components,
                    :bem_flash_variants,
                    ~w[info error warning success]
                  )
  @size_variants Application.compile_env(:pyro_components, :bem_size_variants, ~w[xs sm base lg xl])

  @button_variants Application.compile_env(
                     :pyro_components,
                     :bem_button_variants,
                     ~w[solid outline]
                   )

  ##############################################################################
  ####    C O R E    C O M P O N E N T S
  ##############################################################################

  override PyroComponents.Components.Core, :a do
    set :class, @prefix <> "a"
    set :replace, false
  end

  @prefixed_button @prefix <> "button"
  @button_icon_class @prefixed_button <> "__icon"
  override PyroComponents.Components.Core, :button do
    set :class, &__MODULE__.button_class/1
    set :ping_class, @prefixed_button <> "__ping"
    set :ping_animation_class, @prefixed_button <> "__ping_animation"
    set :icon_class, @button_icon_class
    set :colors, @color_variants
    set :color, "slate"
    set :variant, "solid"
    set :variants, @button_variants
    set :size, "base"
    set :sizes, @size_variants
  end

  def button_class(passed_assigns) do
    size =
      case passed_assigns[:size] do
        "base" -> nil
        size -> @prefixed_button <> "--" <> size
      end

    [
      @prefixed_button,
      size,
      @prefixed_button <> "--" <> passed_assigns[:color],
      @prefixed_button <> "--" <> passed_assigns[:variant]
    ]
  end

  @prefixed_code @prefix <> "code"
  override PyroComponents.Components.Core, :code do
    set :class, @prefixed_code <> " makeup"
    set :copy_class, @prefixed_code <> "__copy"
    set :copy, true
    set :copy_icon, "hero-code-bracket"
    set :copy_label, "Copy"
  end

  override PyroComponents.Components.Core, :color_scheme_switcher do
    set :class, @prefix <> "color_scheme_switcher"
    set :scheme, &__MODULE__.color_scheme_switcher_scheme/1
    set :label_system, "System"
    set :label_light, "Light"
    set :label_dark, "Dark"
    set :icon_system, "hero-computer-desktop-mini"
    set :icon_light, "hero-sun-solid"
    set :icon_dark, "hero-moon-solid"
  end

  def color_scheme_switcher_scheme(passed_assigns) do
    passed_assigns[:scheme] || :system
  end

  override PyroComponents.Components.Core, :copy_to_clipboard do
    set :class, &__MODULE__.button_class/1
    set :icon_class, @button_icon_class
    set :colors, @color_variants
    set :color, "slate"
    set :variant, "solid"
    set :variants, @button_variants
    set :size, "base"
    set :sizes, @size_variants
    set :message, "Copied! 📋"
    set :ttl, 3_000
  end

  @prefixed_error @prefix <> "error"
  override PyroComponents.Components.Core, :error do
    set :class, @prefixed_error
    set :wrapper_class, @prefixed_error <> "__wrapper"
    set :icon_class, @prefixed_error <> "__icon"
    set :icon_name, "hero-exclamation-circle-mini"
  end

  @prefixed_flash @prefix <> "flash"
  override PyroComponents.Components.Core, :flash do
    set :class, @prefixed_flash
    set :control_class, @prefixed_flash <> "__control"
    set :close_button_class, @prefixed_flash <> "__close_button"
    set :close_icon_class, @prefixed_flash <> "__close_icon"
    set :message_class, @prefixed_flash <> "__message"
    set :progress_class, @prefixed_flash <> "__progress"
    set :title_class, @prefixed_flash <> "__title"
    set :title__icon_class, @prefixed_flash <> "__title_icon"
    set :icon_name, &__MODULE__.flash_icon_name/1
    set :close_icon_name, "hero-x-mark-mini"
    set :kind, "info"
    set :kinds, @flash_variants
    set :title, &__MODULE__.flash_title/1
    set :autoshow, true
    set :close, true
    set :ttl, 10_000
    set :show_js, &__MODULE__.hide_modal/2
    set :hide_js, &__MODULE__.show_modal/2
  end

  def flash_title(passed_assigns) do
    case passed_assigns[:kind] do
      "info" -> "Information"
      "error" -> "Error"
      "warning" -> "Warning"
      "success" -> "Success"
      _ -> nil
    end
  end

  def flash_icon_name(passed_assigns) do
    case passed_assigns[:kind] do
      "info" -> "hero-information-circle-mini"
      "error" -> "hero-exclamation-circle-mini"
      "warning" -> "hero-exclamation-triangle-mini"
      "success" -> "hero-check-circle-mini"
      _ -> "hero-bell-mini"
    end
  end

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "#{id}")
    |> JS.show(
      to: "#{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "#{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("#{id}-container")
    |> JS.hide(to: "#{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  override PyroComponents.Components.Core, :flash_group do
    set :class, @prefix <> "flash_group"
    set :include_kinds, @flash_variants
  end

  @prefixed_header @prefix <> "header"
  override PyroComponents.Components.Core, :header do
    set :class, @prefixed_header
    set :title_class, @prefixed_header <> "__title"
    set :subtitle_class, @prefixed_header <> "__subtitle"
    set :actions_class, @prefixed_header <> "__actions"
  end

  override PyroComponents.Components.Core, :icon do
    set :class, @prefix <> "icon"
  end

  @prefixed_input @prefix <> "input"
  override PyroComponents.Components.Core, :input do
    set :class, @prefixed_input
    set :input_class, &__MODULE__.input_class/1
    set :input_check_label_class, @prefixed_input <> "__input_check_label"
    set :input_datetime_zoned_wrapper_class, @prefixed_input <> "__input_datetime_zoned_wrapper"
    set :description_class, @prefixed_input <> "__description"
    set :clear_on_escape, true
    set :get_tz_options, &Pyro.Component.Helpers.all_timezones/0
  end

  def input_class(passed_assigns) do
    [@prefixed_input <> "__input", "has-errors": passed_assigns[:errors] != []]
  end

  override PyroComponents.Components.Core, :label do
    set :class, @prefix <> "label"
  end

  @prefixed_list @prefix <> "list"
  override PyroComponents.Components.Core, :list do
    set :class, @prefixed_list
    set :dt_class, @prefixed_list <> "__dt"
    set :dd_class, @prefixed_list <> "__dd"
  end

  @prefixed_modal @prefix <> "modal"
  override PyroComponents.Components.Core, :modal do
    set :class, @prefixed_modal
    set :backdrop_class, @prefixed_modal <> "__backdrop"
    set :dialog_class, @prefixed_modal <> "__dialog"
    set :wrapper_class, @prefixed_modal <> "__wrapper"
    set :container_class, @prefixed_modal <> "__container"
    set :focus_class, @prefixed_modal <> "__focus"
    set :close_button_class, @prefixed_modal <> "__close_button"
    set :close_button_icon, "hero-x-mark-solid"
    set :title_class, @prefixed_modal <> "__title"
    set :subtitle_class, @prefixed_modal <> "__subtitle"
    set :actions_class, @prefixed_modal <> "__actions"
    set :show_js, &__MODULE__.modal_show_js/2
    set :hide_js, &__MODULE__.modal_hide_js/2
  end

  def modal_show_js(js \\ %JS{}, id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(to: "##{id}-bg")
    |> JS.show(to: "##{id}-container")
    |> JS.focus_first(to: "##{id}-content")
  end

  def modal_hide_js(js \\ %JS{}, id) do
    js
    |> JS.hide(to: "##{id}-bg")
    |> JS.hide(to: "##{id}-container")
    |> JS.hide(to: "##{id}")
    |> JS.pop_focus()
  end

  @prefixed_nav_link @prefix <> "nav_link"
  override PyroComponents.Components.Core, :nav_link do
    set :class, &__MODULE__.nav_link_class/1
  end

  def nav_link_class(passed_assigns) do
    [@prefixed_nav_link, {:"#{@prefixed_nav_link}--current", passed_assigns[:is_current]}]
  end

  @prefixed_progress @prefix <> "progress"
  override PyroComponents.Components.Core, :progress do
    set :class, &__MODULE__.progress_class/1
    set :size, "base"
    set :sizes, @size_variants
    set :color, "slate"
    set :colors, @color_variants
  end

  def progress_class(passed_assigns) do
    size =
      case passed_assigns[:size] do
        "base" -> nil
        size -> @prefixed_progress <> "--" <> size
      end

    case_result =
      case passed_assigns[:color] do
        "error" -> "red"
        "info" -> "slate"
        "warning" -> "yellow"
        "success" -> "green"
        color -> color
      end

    color =
      then(case_result, &(@prefixed_progress <> "--" <> &1))

    [@prefixed_progress, color, size]
  end

  @prefixed_simple_form @prefix <> "simple_form"
  override PyroComponents.Components.Core, :simple_form do
    set :class, @prefixed_simple_form
    set :actions_class, @prefixed_simple_form <> "__actions"
  end

  @prefixed_slide_over @prefix <> "slide_over"
  override PyroComponents.Components.Core, :slide_over do
    set :class, &__MODULE__.slide_over_class/1
    set :overlay_class, @prefixed_slide_over <> "__overlay"
    set :wrapper_class, &__MODULE__.slide_over_wrapper_class/1
    set :header_class, @prefixed_slide_over <> "__header"
    set :header_inner_class, @prefixed_slide_over <> "__header_inner"
    set :header_title_class, @prefixed_slide_over <> "__header_title"
    set :header_close_button_class, @prefixed_slide_over <> "__header_close_button"
    set :content_class, @prefixed_slide_over <> "__content"
    set :close_icon_class, @prefixed_slide_over <> "__close_icon"
    set :close_icon_name, "hero-x-mark-solid"
    set :origin, "left"
    set :origins, ~w[left right top bottom]
    set :max_width, "base"
    set :max_widths, ~w[sm md lg xl 2xl full]
    set :hide_js, &__MODULE__.slide_over_hide_js/5
  end

  def slide_over_class(passed_assigns) do
    [
      "w-full max-h-full overflow-auto",
      "bg-white dark:bg-gradient-to-tr dark:from-slate-900 dark:to-slate-800 text-slate-900 dark:text-white",
      slide_over_width_class(passed_assigns),
      passed_assigns[:origin] == "left" && "transition translate-x-0",
      passed_assigns[:origin] == "right" && "transition translate-x-0 absolute right-0 inset-y-0",
      passed_assigns[:origin] == "top" && "transition translate-y-0 absolute inset-x-0",
      passed_assigns[:origin] == "bottom" &&
        "transition translate-y-0 absolute inset-x-0 bottom-0",
      passed_assigns[:class]
    ]
  end

  def slide_over_width_class(%{origin: origin, max_width: max_width}) do
    case origin do
      x when x in ["left", "right"] ->
        case max_width do
          "sm" -> "max-w-sm"
          "md" -> "max-w-xl"
          "lg" -> "max-w-3xl"
          "xl" -> "max-w-5xl"
          "2xl" -> "max-w-7xl"
          "full" -> "max-w-full"
        end

      x when x in ["top", "bottom"] ->
        ""
    end
  end

  def slide_over_wrapper_class(passed_assigns) do
    [
      "fixed inset-0 z-50 flex overflow-hidden transform",
      passed_assigns[:origin] == "left" && "mr-10",
      passed_assigns[:origin] == "right" && "ml-10",
      passed_assigns[:origin] == "top" && "mb-10",
      passed_assigns[:origin] == "bottom" && "mt-10",
      passed_assigns[:wrapper_class]
    ]
  end

  def slide_over_hide_js(js \\ %JS{}, id, origin, close_event_name, close_slide_over_target) do
    origin_class =
      case origin do
        x when x in ["left", "right"] -> "translate-x-0"
        x when x in ["top", "bottom"] -> "translate-y-0"
      end

    destination_class =
      case origin do
        "left" -> "-translate-x-full"
        "right" -> "translate-x-full"
        "top" -> "-translate-y-full"
        "bottom" -> "translate-y-full"
      end

    js =
      js
      |> JS.remove_class("overflow-hidden", to: "body")
      |> JS.hide(
        transition: {
          "ease-in duration-200",
          "opacity-100",
          "opacity-0"
        },
        to: "##{id}-overlay"
      )
      |> JS.hide(
        transition: {
          "ease-in duration-200",
          origin_class,
          destination_class
        },
        to: "##{id}-content"
      )

    if close_slide_over_target do
      JS.push(js, close_event_name, close_slide_over_target)
    else
      JS.push(js, close_event_name)
    end
  end

  @prefixed_spinner @prefix <> "spinner"
  override PyroComponents.Components.Core, :spinner do
    set :class, &__MODULE__.spinner_class/1
    set :size, "base"
    set :sizes, @size_variants
  end

  def spinner_class(passed_assigns) do
    size =
      case passed_assigns[:size] do
        "base" -> nil
        size -> @prefixed_spinner <> "--" <> size
      end

    [
      @prefixed_spinner,
      size,
      hidden: !passed_assigns[:show]
    ]
  end

  @prefixed_table @prefix <> "table"
  override PyroComponents.Components.Core, :table do
    set :class, @prefixed_table
    set :thead_class, @prefixed_table <> "__thead"
    set :th_label_class, @prefixed_table <> "__th_label"
    set :th_action_class, @prefixed_table <> "__th_action"
    set :tbody_class, @prefixed_table <> "__tbody"
    set :tr_class, @prefixed_table <> "__tr"
    set :td_class, @prefixed_table <> "__td"
    set :action_td_class, @prefixed_table <> "__action_td"
    set :action_wrapper_class, @prefixed_table <> "__action_wrapper"
    set :action_class, @prefixed_table <> "__action"
  end

  @prefixed_tooltip @prefix <> "tooltip"
  override PyroComponents.Components.Core, :tooltip do
    set :class, @prefixed_tooltip
    set :tooltip_class, @prefixed_tooltip <> "__tooltip"
    set :tooltip_text_class, @prefixed_tooltip <> "__text"
    set :icon_name, "hero-question-mark-circle-solid"
    set :vertical_offset, "2.25rem"
    set :horizontal_offset, "0"
  end

  ##############################################################################
  ####    D A T A    T A B L E    C O M P O N E N T
  ##############################################################################

  @prefixed_data_table @prefix <> "data_table"
  override PyroComponents.Components.DataTable, :data_table do
    set :class, @prefixed_data_table
    set :header_class, @prefixed_data_table <> "__header"
    set :body_class, @prefixed_data_table <> "__body"
    set :row_class, @prefixed_data_table <> "__row"
    set :row_actions_class, @prefixed_data_table <> "__row_actions"
    set :footer_class, @prefixed_data_table <> "__footer"
    set :footer_wrapper_class, @prefixed_data_table <> "__footer_wrapper"
  end

  override PyroComponents.Components.DataTable, :th do
    set :class, &__MODULE__.data_table_th_class/1
    set :btn_class, &__MODULE__.data_table_sort_btn_class/1
  end

  def data_table_th_class(passed_assigns) do
    if passed_assigns[:sort_key] == nil do
      @prefixed_data_table <> "__th--unsortable"
    else
      @prefixed_data_table <> "__th--sortable"
    end
  end

  def data_table_sort_btn_class(passed_assigns) do
    if passed_assigns[:direction] == nil do
      @prefixed_data_table <> "__sort_btn--inactive"
    else
      @prefixed_data_table <> "__sort_btn--active"
    end
  end

  override PyroComponents.Components.DataTable, :cell do
    set :class, @prefixed_data_table <> "__cell"
  end

  override PyroComponents.Components.DataTable, :sort_icon do
    set :class, @prefixed_data_table <> "__sort_icon"
    set :index_class, @prefixed_data_table <> "__sort_icon_index"
    set :sort_icon_name, &__MODULE__.data_table_sort_icon_name/1
  end

  def data_table_sort_icon_name(passed_assigns) do
    case passed_assigns[:direction] do
      :asc -> "hero-chevron-up-solid"
      :asc_nils_last -> "hero-chevron-up-solid"
      :asc_nils_first -> "hero-chevron-double-up-solid"
      :desc -> "hero-chevron-down-solid"
      :desc_nils_first -> "hero-chevron-down-solid"
      :desc_nils_last -> "hero-chevron-double-down-solid"
      _ -> nil
    end
  end

  ##############################################################################
  ####    P A G I N A T I O N    C O M P O N E N T
  ##############################################################################

  @prefixed_pagination @prefix <> "pagination"
  override PyroComponents.Components.Pagination, :pagination do
    set :class, @prefixed_pagination
    set :first_class, @prefixed_pagination <> "__first"
    set :first_icon, "hero-chevron-double-left-solid"
    set :first_icon_class, @prefixed_pagination <> "__first_icon"
    set :previous_class, @prefixed_pagination <> "__previous"
    set :previous_icon, "hero-chevron-left-solid"
    set :previous_icon_class, @prefixed_pagination <> "__previous_icon"
    set :next_class, @prefixed_pagination <> "__next"
    set :next_icon, "hero-chevron-right-solid"
    set :next_icon_class, @prefixed_pagination <> "__next_icon"
    set :last_class, @prefixed_pagination <> "__last"
    set :last_icon, "hero-chevron-double-right-solid"
    set :last_icon_class, @prefixed_pagination <> "__last_icon"
    set :reset_class, @prefixed_pagination <> "__reset"
    set :top_class, @prefixed_pagination <> "__top"
    set :top_icon, "hero-chevron-double-up-solid"
    set :top_icon_class, @prefixed_pagination <> "__top_icon"
    set :limit_form_class, @prefixed_pagination <> "__limit_form"
    set :limit_form_label_class, @prefixed_pagination <> "__limit_form_label"
    set :limit_form_input_class, @prefixed_pagination <> "__limit_form_input"
    set :limit_form_input_option_class, @prefixed_pagination <> "__limit_form_input_option"
  end

  ##############################################################################
  ####    L I V E    C O M P O N E N T S
  ##############################################################################

  @prefixed_autocomplete @prefix <> "autocomplete"
  override PyroComponents.Components.Autocomplete, :render do
    set :class, @prefixed_autocomplete
    set :input_class, &__MODULE__.input_class/1
    set :description_class, @prefixed_input <> "__description"
    set :listbox_wrapper_class, @prefixed_autocomplete <> "__listbox_wrapper"
    set :listbox_class, @prefixed_autocomplete <> "__listbox"
    set :listbox_option_class, @prefixed_autocomplete <> "__listbox_option"
    set :throttle_time, 212
    set :option_label_key, :label
    set :option_value_key, :id
    set :prompt, "Search options"
  end

  def autocomplete_listbox_option_class(passed_assigns) do
    base = @prefixed_autocomplete <> "__listbox_option"

    if passed_assigns[:results] == [] do
      base
    else
      [base, "has-results"]
    end
  end
end
