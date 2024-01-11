[![hex.pm](https://img.shields.io/hexpm/l/pyro_components.svg)](https://hex.pm/packages/pyro_components)
[![hex.pm](https://img.shields.io/hexpm/v/pyro_components.svg)](https://hex.pm/packages/pyro_components)
[![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/pyro_components)
[![hex.pm](https://img.shields.io/hexpm/dt/pyro_components.svg)](https://hex.pm/packages/pyro_components)
[![github.com](https://img.shields.io/github/last-commit/frankdugan3/pyro_components.svg)](https://github.com/frankdugan3/pyro_components)

# Pyro

Pyro is a suite of libraries for building UI in Phoenix.

- [Pyro](https://hexdocs.pm/pyro)

  Component tooling for Phoenix.

  - Customizable "overrides" system for granularly customizable themes
  - Extended component attributes, e.g. CSS merging

- [PyroComponents](https://hexdocs.pm/pyro_components)

  Ready-made Phoenix components, built with pyro.

  - Heex component library
  - Overrides presets to get started quickly while allowing deep customization

- [AshPyro](https://hexdocs.pm/ash_pyro)

  Declarative UI for Ash Framework.

  - Ash extensions providing a declarative UI DSL

- [AshPyroComponents](https://hexdocs.pm/ash_pyro_components)

  Components that automatically render PyroComponents declaratively via AshPyro.

## About

For more details on PyroComponents, check out the [About](https://hexdocs.pm/pyro_components/about.html) page.

## Installation

To install PyroComponents and use them in your Phoenix app, follow the [Get Started](get-started.html) guide. For the other features, please see the "Get Started" guide for the appropriate library instead.

## Development

As long as Elixir is already installed:

```sh
git clone git@github.com:frankdugan3/pyro_components.git
cd pyro
mix setup
```

For writing docs, there is a handy watcher script that automatically rebuilds/reloads the docs locally: `./watch_docs.sh`

## Prior Art

- [Petal](https://petal.build/components): Petal is an established project with a robust set of components, and served as a substantial inspiration for this project.
- [Doggo](https://github.com/woylie/doggo): Headless UI components for Phoenix, with an emphasis on semantic HTML and APG guidelines.
