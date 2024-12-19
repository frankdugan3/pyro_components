# About

[![hex.pm](https://img.shields.io/hexpm/l/pyro_components.svg)](https://hex.pm/packages/pyro_components)
[![hex.pm](https://img.shields.io/hexpm/v/pyro_components.svg)](https://hex.pm/packages/pyro_components)
[![hex.pm](https://img.shields.io/hexpm/dt/pyro_components.svg)](https://hex.pm/packages/pyro_components)
[![github.com](https://img.shields.io/github/last-commit/frankdugan3/pyro_components.svg)](https://github.com/frankdugan3/pyro_components)

> Extensible Phoenix components, built with Pyro.

Pyro is a suite of libraries for building UI in Phoenix.

> #### Experimental Library {: .warning}
>
> PyroComponents is in early development, expect breaking changes.

To install PyroComponents and learn how it works, start at the [Get Started](get-started.html) guide and work your way through the tutorials. They are ordered in a sensible way to explain the various features Pyro offers, and point toward other tools in the Pyro suite when appropriate.

## What "problem" is it solving?

Component libraries generally suffer from a lack of extensibility. Because of this, there tends to be a substantial churn to add features and configuration options that leads to bloat and maintenance pain. On the other hand, minimalist libraries tend to leave a lot of boilerplate work for the consumer. Symptoms like this are why `phx.new` opts to generate a `core_components.ex` file for you customize. It's a great start, but requires a ton of customization to do much of anything.

Pyro aims to provide a middle ground: Components that can be *extended*. It leverages a DSL to describe how a component should be built (it's a superset of `Phoenix.Component`'s DSL), and wraps it with "transformers" that merge component libraries together with your customizations to produce a bespoke component library.

## General Principles

PyroComponents is under-developed. Not all components adhere to every principle, but eventually these principles should prevail:

- Maximal flexibility
  - Application defaults through presets & custom overrides
  - Components allow overriding defaults through props
- Clean, standards-compliant HTML markup
  - Favor semantic HTML elements
  - Avoid excessive `div` tags
  - Adhere to [accessibility guidelines](https://www.w3.org/WAI/ARIA/apg/)
- Progressive enhancement
  - No external JS dependencies
  - No needless JS
  - Sensibly enhance UX with JS
- Responsive
- Internationalization support via `gettext`

## But wait, there's more!

In addition to these extensible components, there is a [full suite](suite.html) of libraries that build on the foundation Pyro provides.
