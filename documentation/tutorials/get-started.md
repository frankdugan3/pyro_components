# Get Started

This guide steps through the installation process for PyroComponents.

## Installation

The installation process is pretty straightforward, and many of the steps can be customized depending on how you want to use PyroComponents.

### Steps

These steps assume you are adding PyroComponents to an existing Phoenix LiveView app, as generated from the most recent version of `phx.new`.

1. Add `:pyro` to your dependencies:

   ```elixir
   def deps do
     [
      {:pyro_components, "~> 0.1.1"},

      # Heroicon support in components
      {:heroicons,
        github: "tailwindlabs/heroicons",
        tag: "v2.1.3",
        app: false,
        compile: false,
        sparse: "optimized"},

      ### OPTIONAL DEPS BELOW ###

      # Date/Time/Zone components & tooling
      {:tz_extra, "~> 0.26"},
      #   or
      {:tzdata, "~> 1.1"},

      # Code highlighting components:
      {:makeup, "~> 1.1"},
      {:makeup_eex, "~> 0.1"},
      {:makeup_elixir, "~> 0.16"},
      {:makeup_html, "~> 0.1"},
      {:makeup_js, "~> 0.1"},
      {:makeup_json, "~> 0.1"},
     ]
   end
   ```

2. Add `:pyro` to your `.formatter.exs`:

   ```elixir
   [
     import_deps: [:ecto, :ecto_sql, :phoenix, :pyro],
     subdirectories: ["priv/*/migrations"],
     plugins: [Phoenix.LiveView.HTMLFormatter],
     inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
   ]
   ```

3. Add the following lines to `assets/js/app.js`:

   ```js
   import { hooks, getTimezone } from 'pyro';

   let liveSocket = new LiveSocket('/live', Socket, {
     params: { _csrf_token: csrfToken, timezone: getTimezone() },
     hooks: { ...hooks },
   });
   ```

4. (Optional) Add the color scheme JS to your `root.html.heex` template (prevents [FOUC](https://en.wikipedia.org/wiki/Flash_of_unstyled_content)):

   ```heex
   <head>
     <.color_scheme_switcher_js />
     <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
   </head>
   ```
That's it! You're ready to rock.

## Next Steps

You might be interested in setting up [Pyro's DSL formatter](https://hexdocs.pm/pyro/formatter.html).

The rest of the tutorials are sorted in a way to step you through how everything fits together, so go ahead and mash that "Next Page" link below.
