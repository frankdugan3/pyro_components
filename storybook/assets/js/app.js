import 'phoenix_html';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import { hooks, getTimezone, sendTimezoneToServer } from 'pyro_components';

sendTimezoneToServer();

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken, timezone: getTimezone() },
  hooks: { ...hooks },
  metadata: {
    click: (e, el) => {
      return {
        shiftKey: e.shiftKey,
        ctrlKey: e.ctrlKey,
        // detail: e.detail || 1,
      };
    },
    // keydown: (e, el) => {
    //   return {
    //     altKey: e.altKey,
    //     code: e.code,
    //     ctrlKey: e.ctrlKey,
    //     key: e.key,
    //     shiftKey: e.shiftKey,
    //   }
    // },
    // keyup: (e, el) => {
    //   return {
    //     altKey: e.altKey,
    //     code: e.code,
    //     ctrlKey: e.ctrlKey,
    //     key: e.key,
    //     shiftKey: e.shiftKey,
    //   }
    // },
  },
});

liveSocket.connect();
