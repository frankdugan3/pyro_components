# About

To install PyroComponents and use them in your Phoenix app, follow the [Get Started](get-started.html) guide. For the other features, please see the "Get Started" guide for the appropriate library instead.

There is a [full suite](suite.html) of `Pyro` libraries.

## What "problem" is it solving?

The default model of Phoenix is to generate, then customize. While this does provide great isolation, I have found it pretty tedious to repeatedly make very similar copy & paste boilerplate changes to the generated code every time I create a new Phoenix app. Additionally, some things (like timezone localization) are quite complicated and it would be nice for them to be handled by a library that is updated with future improvements. Copy & pasting boilerplate will lead to maintenance burdens down the road.

The tricky part is handling all the bespoke features in each app while sharing as much as possible. The goal is to provide a wide array of tooling, helpers and components with sane defaults, while allowing very granular overrides and optional libraries. By separating each level of features, you can choose which parts of Pyro to leverage, and which to implement yourself.

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
