import { hooks, getTimezone } from 'pyro_components'
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

;(function () {
  window.storybook = {
    Hooks: hooks,
    Params: { _csrf_token: csrfToken, timezone: getTimezone() },
  }
})()
