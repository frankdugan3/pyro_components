defmodule PyroComponents.Core do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [tabler](https://tabler.io/icons). See `icon/1` for usage.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  def is(variants), do: variant_classes(variants, "is-")
  def has(variants), do: variant_classes(variants, "has-")
  def size(variants), do: variant_classes(variants, "SZ-")
  def color(variants), do: variant_classes(variants, "CLR-")

  defp variant_classes(nil, _prefix), do: []

  defp variant_classes(variants, prefix) do
    variants
    |> List.wrap()
    |> Enum.reduce([], fn
      nil, acc -> acc
      :base, acc -> acc
      "base", acc -> acc
      variant, acc when is_atom(variant) -> [prefix <> Atom.to_string(variant) | acc]
      variant, acc when is_binary(variant) -> [prefix <> variant | acc]
    end)
  end

  @variadic_colors ~w[
    gray neutral stone zinc slate
    red rose
    yellow amber orange
    green lime emerald
    blue teal cyan sky
    purple indigo violet
    pink fuchsia
  ]
  @solid_colors ~w[black white]
  @theme_colors ~w[base primary secondary success warning danger]
  @colors @variadic_colors ++ @solid_colors ++ @theme_colors
  @color_opts [values: @colors, default: "secondary"]

  @sizes ~w[xs sm base lg xl]
  @size_opts [values: @sizes, default: "base"]

  attr :value, :boolean, required: true

  def boolean(%{value: true} = assigns) do
    ~H"""
    ✔
    """
  end

  def boolean(%{value: false} = assigns) do
    ~H"""
    ❌
    """
  end

  def boolean(assigns) do
    ~H"""
    """
  end

  attr :id, :string, doc: "ID for tooltip"
  attr :icon, :string, default: "tabler-help", doc: "icon name for tooltip"
  attr :rest, :global
  slot :inner_block, required: true

  def tooltip(assigns) do
    assigns = assign_new_uuid(assigns)

    ~H"""
    <span id={@id} data-pyro-component="tooltip" {@rest}>
      <.icon name={@icon} />
      <div id={@id <> "-tooltip-text"} class="tooltip-text" phx-hook="NudgeIntoView">
        {render_slot(@tooltip)}
      </div>
    </span>
    """
  end

  @doc """
  A badge.
  """

  attr :class, :any, default: nil, doc: "extra CSS classes"
  attr :color, :string, @color_opts ++ [doc: "The color of the badge"]
  attr :rest, :global
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <div data-pyro-component="badge" class={[color(@color), @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  A dropdown menu.
  """

  attr :id, :string
  attr :rest, :global

  slot :trigger, required: true do
    attr :title, :string
    attr :class, :any
    attr :action, :string, values: ~w[show hide toggle]
  end

  slot :inner_block, required: true

  def dropdown(assigns) do
    assigns = assign_new_uuid(assigns)

    ~H"""
    <.button
      :for={trigger <- @trigger}
      popovertarget={@id}
      popovertargetaction={Map.get(trigger, :action)}
      class={[Map.get(trigger, :class)]}
      title={Map.get(trigger, :title)}
    >
      {render_slot(@trigger)}
    </.button>
    <div data-pyro-component="dropdown" popover id={@id} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :target, :string, required: true, doc: "the id of the popover target"

  attr :action, :any,
    default: "hide",
    values: ~w[show hide toggle],
    doc: "the popover action to trigger"

  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def dropdown_action(assigns) do
    ~H"""
    <.button popovertarget={@target} popovertargetaction={@action} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @doc """
  Dropdown to control user settings.
  """

  attr :id, :string
  attr :current_user, :map

  def user_settings_menu(assigns) do
    assigns = assign_new_uuid(assigns)

    # TODO: Figure out proper aria for button group labels.
    ~H"""
    <.dropdown id={@id} class="text-center">
      <:trigger title="change user settings"><.icon name="tabler-user-cog" /></:trigger>
      <p :if={@current_user} class="text-black dark:text-white font-black text-sm">
        {@current_user.employee.name_full}
      </p>
      <p :if={@current_user} class="text-black dark:text-white font-black text-xs">
        {@current_user.email}
        <div class="grid justify-center">
          <.link href="/sign-out" class="pyro-button CLR-secondary SZ-sm">
            Log Out <.icon name="tabler-logout" class="size-4" />
          </.link>
        </div>
      </p>
      <p :if={!@current_user}>
        <.link href="/sign-in" class="whitespace-nowrap font-black hover:underline">
          Log In <.icon name="tabler-login" />
        </.link>
      </p>
      <span class="font-black">Color Scheme</span>
      <div class="grid grid-flow-col gap-2 content-center">
        <.dropdown_action
          target={@id}
          phx-click={JS.dispatch("set-color-scheme", detail: %{scheme: "system"})}
          title="system"
          action="show"
          class={~W[
            color-scheme-system:bg-primary
            color-scheme-system:border-primary-accent
            color-scheme-system:text-primary-contrast
          ]}
        >
          <.icon name="tabler-device-desktop" />
        </.dropdown_action>
        <.dropdown_action
          target={@id}
          phx-click={JS.dispatch("set-color-scheme", detail: %{scheme: "dark"})}
          title="dark"
          action="show"
          class={~W[
            color-scheme-dark:bg-primary
            color-scheme-dark:border-primary-accent
            color-scheme-dark:text-primary-contast
          ]}
        >
          <.icon name="tabler-moon-stars" />
        </.dropdown_action>
        <.dropdown_action
          target={@id}
          phx-click={JS.dispatch("set-color-scheme", detail: %{scheme: "light"})}
          title="light"
          action="show"
          class={~W[
            color-scheme-light:bg-primary
            color-scheme-light:border-primary-accent
            color-scheme-light:text-primary-contrast
          ]}
        >
          <.icon name="tabler-sun" />
        </.dropdown_action>
      </div>
      <span class="font-black">Text Editor Mode</span>
      <div class="control-group">
        <.dropdown_action
          target={@id}
          phx-click={JS.dispatch("set-editor-mode", detail: %{mode: "vscode"})}
          title="VS Code"
          action="show"
          class={~W[
            editor-mode-vscode:bg-primary
            editor-mode-vscode:border-primary-accent
            editor-mode-vscode:text-primary-contrast
          ]}
        >
          <.icon name="tabler-brand-vscode" />
        </.dropdown_action>
        <.dropdown_action
          target={@id}
          phx-click={JS.dispatch("set-editor-mode", detail: %{mode: "vim"})}
          title="Vim"
          action="show"
          class={~W[
            editor-mode-vim:bg-primary
            editor-mode-vim:border-primary-accent
            editor-mode-vim:text-primary-contrast
          ]}
        >
          <.icon name="svgicon-brand-vim" />
        </.dropdown_action>
        <.dropdown_action
          target={@id}
          phx-click={JS.dispatch("set-editor-mode", detail: %{mode: "emacs"})}
          title="Emacs"
          action="show"
          class={~W[
            editor-mode-emacs:bg-primary
            editor-mode-emacs:border-primary-accent
            editor-mode-emacs:text-primary-contrast
          ]}
        >
          <.icon name="svgicon-brand-emacs" />
        </.dropdown_action>
      </div>
    </.dropdown>
    """
  end

  @doc """
  Javascript to manage switching user settings with `user_settins_menu/1`.

  > #### Note: {: .info}
  >
  > This needs to be added in the page's head before `app.js` to prevent FOUC:

  ```heex
  <%# root.html.heex %>
  <head>
    <.user_settings_js />
    <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
  </head>
  ```
  """
  def user_settings_js(assigns) do
    ~H"""
    <script>
      window.applyColorScheme = function (scheme) {
        let dark = scheme === 'dark';
        if (scheme === "system") {
          if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
            document.documentElement.setAttribute("data-color-scheme", "dark-system");
            dark = true;
          } else {
            document.documentElement.setAttribute("data-color-scheme", "light-system");
          }
        } else {
            document.documentElement.setAttribute("data-color-scheme", scheme);
        }
        localStorage.scheme = scheme;
        document.documentElement.dispatchEvent(
          new CustomEvent('color-scheme-changed', {
            bubbles: true,
            detail: {scheme, dark},
          })
        );
      };

      window.applyEditorMode = function (mode) {
        document.documentElement.setAttribute("data-editor-mode", mode);
        localStorage.editor_mode = mode;
        document.documentElement.dispatchEvent(
          new CustomEvent('editor-mode-changed', {
            bubbles: true,
            detail: {mode},
          })
        );
      };

      // Initialize
      applyColorScheme(localStorage.scheme || "system");
      applyEditorMode(localStorage.editor_mode || "vscode");

      // Watch preferred scheme
      window
        .matchMedia("(prefers-color-scheme: dark)")
        .addEventListener("change", (_) => {
          if (localStorage.scheme === "system") {
            applyColorScheme("system");
          }
        });

      // Watch changes made from different tab/window/browser
      window.addEventListener("storage", (_) => {
        applyColorScheme(localStorage.scheme);
        applyEditorMode(localStorage.editor_mode);
      })

      // Listen for set events
      window.addEventListener("set-color-scheme", (e) => {
       applyColorScheme(e?.detail?.scheme || "system");
      })

      window.addEventListener("set-editor-mode", (e) => {
       applyEditorMode(e?.detail?.mode || "vscode");
      })
    </script>
    """
  end

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label="close"
                >
                  <.icon name="tabler-x" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                {render_slot(@inner_block)}
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="tabler-info-circle" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="tabler-exclamation-circle" class="h-4 w-4" /> {@title}
      </p>
      <p class="mt-2 text-sm leading-5">{msg}</p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label="close">
        <.icon name="tabler-x" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title="Success!" flash={@flash} />
      <.flash kind={:error} title="Error!" flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title="We can't find the internet"
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        Attempting to reconnect
        <.icon name="tabler-circle-dotted" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title="Something went wrong!"
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        Hang in there while we get back on track
        <.icon name="tabler-circle-dotted" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.field field={@form[:email]} label="Email"/>
        <.field field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :title, doc: "the title of the form"
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} data-pyro-component="simple_form" {@rest}>
      <h1>{render_slot(@title)}</h1>
      {render_slot(@inner_block, f)}
      <div :for={action <- @actions} class="action">
        {render_slot(action, f)}
      </div>
    </.form>
    """
  end

  @doc """
  Renders a loading spinner.
  """
  def spinner(assigns) do
    ~H"""
    <svg
      class="animate-spin h-4 w-4 text-white inline-block"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :any, default: nil
  attr :color, :string, @color_opts ++ [doc: "the color of the button"]
  attr :size, :string, @size_opts ++ [doc: "the size of the button"]
  attr :rest, :global, include: ~w(disabled form name value popovertarget popovertargetaction)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      data-pyro-component="button"
      type={@type}
      class={[color(@color), size(@size), @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  A group of checkboxes
  """
  attr :id, :any
  attr :name, :any
  attr :label, :string, default: nil
  attr :field, Phoenix.HTML.FormField
  attr :errors, :list
  attr :required, :boolean, default: false
  attr :options, :list
  attr :rest, :global, include: ~w(disabled form readonly)
  attr :class, :string, default: nil

  def checkgroup(assigns) do
    assigns
    |> assign(:multiple, true)
    |> assign(:type, "checkgroup")
    |> field()
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.field field={@form[:email]} type="email" />
      <.field name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :input_class, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week checkgroup hidden)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def field(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> field()
  end

  def field(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          disabled={@rest[:disabled]}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        /> {@label}
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def field(%{type: "hidden"} = assigns) do
    ~H"""
    <input id={@id} type="hidden" name={@name} value={@value} />
    """
  end

  def field(%{options: [], type: "checkgroup"} = assigns) do
    ~H"""
    <input id={@id} type="hidden" name={@name} value="" />
    """
  end

  def field(%{type: "checkgroup"} = assigns) do
    ~H"""
    <fieldset data-pyro-component="checkgroup">
      <legend>{@label}</legend>
      <input type="hidden" name={@name} value="" />
      <div class={["items", @errors != [] && "has-errors", @input_class]}>
        <span
          :for={%{value: value, preselected?: true, description: description} <- @options}
          title={"Always selected by this action.\n\n#{description}"}
          data-preselected
        >
          {value}
        </span>
        <label :for={%{value: value, preselected?: false} = opt <- @options}>
          <input
            type="checkbox"
            id={"#{@name}-#{value}"}
            name={@name}
            value={value}
            checked={value in @value}
            {@rest}
          /> {opt[:label] || value}
        </label>
      </div>
      <.error :for={msg <- @errors}>{msg}</.error>
    </fieldset>
    """
  end

  def field(%{type: "select"} = assigns) do
    ~H"""
    <div>
      <.label :if={@label} for={@id}>{@label}</.label>
      <select
        data-pyro-component="input"
        id={@id}
        name={@name}
        class={[@errors != [] && "has-errors", @input_class]}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def field(%{type: "textarea"} = assigns) do
    ~H"""
    <div>
      <.label :if={@label} for={@id}>{@label}</.label>
      <textarea
        data-pyro-component="input"
        id={@id}
        name={@name}
        class={[@errors != [] && "has-errors", @input_class]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def field(assigns) do
    ~H"""
    <div>
      <.label :if={@label} for={@id}>{@label}</.label>
      <input
        data-pyro-component="input"
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[@errors != [] && "has-errors", @input_class]}
        {@rest}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label data-pyro-component="label" for={@for} {@rest}>
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """

  attr :rest, :global
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p data-pyro-component="error" {@rest}>
      <.icon name="tabler-exclamation-circle" class="mt-0.5 h-5 w-5 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rest, :global
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  attr :row_color, :any, default: nil, doc: "the function for mapping the row to a color"

  slot :col, required: true do
    attr :label, :string
  end

  slot :caption, doc: "the caption for the table"
  slot :action, doc: "the slot for showing user actions in the last table column"
  slot :inner_block

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <table data-pyro-component="table" {@rest}>
      <caption :for={caption <- @caption}>{render_slot(caption)}</caption>
      <thead>
        <tr>
          <th :for={col <- @col}>{col[:label]}</th>
          <th :if={@action != []}>
            <span class="sr-only">Actions</span>
          </th>
        </tr>
      </thead>
      <tbody id={@id} phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}>
        <tr
          :for={row <- @rows}
          id={@row_id && @row_id.(row)}
          class={[@row_color && color(@row_color.(row))]}
        >
          <td :for={col <- @col} phx-click={@row_click && @row_click.(row)}>
            {render_slot(col, @row_item.(row))}
          </td>
          <td :if={@action != []}>
            <span :for={action <- @action}>{render_slot(action, @row_item.(row))}</span>
          </td>
        </tr>
        {render_slot(@inner_block)}
      </tbody>
    </table>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500">{item.title}</dt>
          <dd class="text-zinc-700">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="tabler-arrow-left" class="h-3 w-3" /> {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Tabler Icon](https://tabler.io/icons).

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/feathericons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tablericons.tailwind.plugin.js`.

  ## Examples

      <.icon name="tabler-x" />
      <.icon name="tabler-arrow-narrow-right" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the icon"

  # @tabler_path Mix.Project.deps_paths()[:tablericons]
  #
  # @tabler_outline @tabler_path
  #                 |> Path.join("outline")
  #                 |> File.ls!()
  #                 |> Enum.map(&Path.basename(&1, ".svg"))
  #
  # @tabler_filled @tabler_path
  #                |> Path.join("filled")
  #                |> File.ls!()
  #                |> Enum.map(&(Path.basename(&1, ".svg") <> "-filled"))
  #
  # @tabler_icon_names MapSet.new(@tabler_outline ++ @tabler_filled)

  def icon(%{name: "tabler-" <> _name} = assigns) do
    # if Mix.env() in [:dev, :test] && !MapSet.member?(@tabler_icon_names, name) do
    #   raise "#{name} is not a valid Tabler icon"
    # end

    ~H"""
    <span class={[@name, @class]} {@rest} />
    """
  end

  # @svg_icon_names __DIR__
  #                 |> Path.join("../../../assets/svg-icons/")
  #                 |> File.ls!()
  #                 |> Enum.map(&Path.basename(&1, ".svg"))
  #                 |> MapSet.new()
  def icon(%{name: "svgicon-" <> _name} = assigns) do
    # if Mix.env() in [:dev, :test] && !MapSet.member?(@svg_icon_names, name) do
    #   raise "#{name} is not a valid Tabler icon"
    # end

    ~H"""
    <span class={[@name, @class]} {@rest} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, _opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    # if count = opts[:count] do
    #   Gettext.dngettext(Hsm.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(Hsm.Gettext, "errors", msg, opts)
    # end
    msg
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  defp assign_new_uuid(assigns, key \\ :id) do
    assign_new(assigns, key, &Ecto.UUID.generate/0)
  end
end
