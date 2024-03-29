// #############################################################################
// ####    C U S T O M    E V E N T    H A N D L E R S
// #############################################################################

window.addEventListener('pyro:clear', (e) => {
  if (e?.target?.value != '') {
    e.target.value = '';
  }
});

window.addEventListener(`pyro:scroll-top`, (e) => {
  if (e && e.detail && e.detail.id) {
    let el = document.getElementById(e.detail.id);
    if (el) {
      maybeScrollParent(el);
    } else {
      console.error(
        `pyro:scroll-top requested for DOM ID #${e.detail.id} doesn't exist!`,
      );
    }
  } else if (e && e.detail && e.detail.selector) {
    let el = document.querySelector(e.detail.selector);
    if (el) {
      maybeScrollParent(el);
    } else {
      console.error(
        `pyro:scroll-top requested for DOM selector #${e.detail.selector} doesn't exist!`,
      );
    }
  } else {
    console.error(
      `pyro:scroll-top event doesn't contain e.detail.id or e.detail.selector!`,
    );
  }
});

// Scroll element or parents if already scrolled
export function maybeScrollParent(el, depth = 0) {
  if (el.scrollTop == 0 && el.parentElement && el.parentElement.scrollTop > 0) {
    el.parentElement.scrollTop = 0;
  } else if (
    el.scrollTop == 0 &&
    el.parentElement &&
    el.parentElement.scrollTop == 0 &&
    depth < 5
  ) {
    maybeScrollParent(el.parentElement, depth + 1);
  } else {
    el.scrollTop = 0;
  }
}

// #############################################################################
// ####    T I M E Z O N E    T O O L I N G
// #############################################################################
export function getTimezone() {
  return Intl.DateTimeFormat().resolvedOptions().timeZone;
}

export async function sendTimezoneToServer() {
  const timezone = getTimezone();
  let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute('content');

  // Skip if we sent the timezone already or the timezone changed since last time we sent
  if (
    typeof window.localStorage != 'undefined' &&
    (!localStorage['timezone'] || localStorage['timezone'] != timezone)
  ) {
    const response = await fetch('/session/set-timezone', {
      method: 'POST',
      mode: 'cors',
      cache: 'no-cache',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'x-csrf-token': csrfToken,
      },
      referrerPolicy: 'no-referrer',
      body: JSON.stringify({ timezone: timezone }),
    });

    if (response.status === 200) {
      localStorage['timezone'] = timezone;
    }
  }
}

// #############################################################################
// ####    H O O K S
// #############################################################################

export const PyroMaintainAttrs = {
  attrs() {
    return this.el.getAttribute('data-attrs').split(',');
  },
  mounted() {
    // validateDataset(['attrs'], this.el);
    // handleInputMountFlags(this.el);
  },
  beforeUpdate() {
    this.prevAttrs = this.attrs().map((name) => [
      name,
      this.el.getAttribute(name),
    ]);
  },
  updated() {
    this.prevAttrs.forEach(([name, val]) => this.el.setAttribute(name, val));
  },
};

export const PyroColorScheme = {
  mounted() {
    this.init(this.el.getAttribute('data-scheme'));
  },
  updated() {
    this.init();
  },
  init(scheme) {
    initScheme(scheme);
    this.el.addEventListener('click', window.toggleScheme);
  },
};

export const PyroFlashComponent = {
  mounted() {
    this.oldMessageHTML = document.querySelector(
      `#${this.el.id}-message`,
    ).innerHTML;
    if (this.el.dataset?.autoshow !== undefined) {
      window.liveSocket.execJS(
        this.el,
        this.el.getAttribute('data-show-exec-js'),
      );
    }
    resetHideTTL(this);
  },
  updated() {
    newMessageHTML = document.querySelector(`#${this.el.id}-message`).innerHTML;
    if (newMessageHTML !== this.oldMessageHTML) {
      this.oldEl = this.el;
      this.oldMessageHTML = newMessageHTML;
      resetHideTTL(this);
    } else {
      el.value = this.countdown;
    }
  },
  destroyed() {
    clearInterval(this.ttlInterval);
  },
};

export const PyroNudgeIntoView = {
  mounted() {
    nudge(this.el);
  },
  updated() {
    nudge(this.el);
  },
};

export const PyroAutocompleteComponent = {
  mounted() {
    this.lastValueSent = null;
    const expanded = () => {
      return booleanDataset(this.el.getAttribute('aria-expanded'));
    };

    const updateSearchThrottled = throttle(() => {
      if (this.lastValueSent !== this.el.value || !expanded()) {
        this.lastValueSent = this.el.value;
        this.pushEventTo(this.el.dataset.myself, 'search', this.el.value);
      }
    }, this.el.dataset.throttleTime);

    if (this.el.dataset.autofocus) {
      focusAndSelect(this.el);
    }

    const selectedIndex = () => {
      return parseInt(this.el.dataset.selectedIndex);
    };
    const options = () => {
      const listbox = document.getElementById(
        this.el.getAttribute('aria-controls'),
      );

      if (listbox?.children) {
        return Array.from(listbox.children);
      } else {
        return [];
      }
    };

    const setSelectedIndex = (selectedIndex) => {
      // Loop selectedIndex back to first or last result if out of bounds
      const rc = parseInt(this.el.dataset.resultsCount);
      selectedIndex = ((selectedIndex % rc) + rc) % rc;
      this.el.dataset.selectedIndex = selectedIndex;

      options().forEach((option, i) => {
        if (i === selectedIndex) {
          option.setAttribute('aria-selected', true);
        } else {
          option.removeAttribute('aria-selected');
        }
      });
    };

    const pick = (e) => {
      e.preventDefault();
      e.stopPropagation();
      const i = selectedIndex();
      let label = '';
      let value = '';

      if (i > -1) {
        const option = options()[i];
        label = option.dataset.label;
        value = option.dataset.value;
      }

      this.el.value = label;
      this.el.focus();

      id = this.el.id;
      valueKey = this.el.dataset.optionValueKey;
      labelKey = this.el.dataset.optionLabelKey;

      selectValue(this.el);

      const labelEl = document.querySelector(
        `input[type=hidden][data-label-key=${labelKey}]`,
      );

      if (labelEl) {
        labelEl.value = label;
      }
      const valueEl = document.querySelector(
        `input[type=hidden][data-value-key=${valueKey}]`,
      );
      valueEl.value = value;

      this.pushEventTo(this.el.dataset.myself, 'pick', {
        label,
        value,
      });

      valueEl.dispatchEvent(new Event('input', { bubbles: true }));

      return false;
    };

    this.el.addEventListener('keydown', (e) => {
      switch (e.key) {
        case 'Tab':
          if (expanded()) {
            return pick(e);
          } else {
            return true;
          }
        case 'Esc': // IE/Edge
        case 'Escape':
          if (this.el.value !== '' || !expanded()) {
            e.preventDefault();
            e.stopPropagation();
            this.el.value = '';
            this.el.dataset.selectedIndex = -1;
            options().forEach((option, i) => {
              option.removeAttribute('aria-selected');
            });
            updateSearchThrottled();
            return false;
          } else if (expanded()) {
            e.preventDefault();
            e.stopPropagation();
            this.el.value = this.el.dataset.savedLabel || '';
            selectValue(this.el);
            this.pushEventTo(this.el.dataset.myself, 'cancel');
            this.lastValueSent = null;
            return false;
          } else {
            return true;
          }
        case 'Enter':
          if (expanded()) {
            return pick(e);
          } else {
            this.el.value = '';
            e.preventDefault();
            e.stopPropagation();
            updateSearchThrottled();
            return false;
          }
        case 'Up': // IE/Edge
        case 'Down': // IE/Edge
        case 'ArrowUp':
        case 'ArrowDown':
          if (expanded()) {
            e.preventDefault();
            e.stopPropagation();

            let i = selectedIndex();
            i = e.key === 'ArrowUp' || e.key === 'Up' ? i - 1 : i + 1;
            setSelectedIndex(i);

            return false;
          } else {
            return true;
          }
        default:
          return true;
      }
    });
    this.el.addEventListener('focus', (e) => {
      selectValue(this.el);
    });
    this.el.addEventListener('input', (e) => {
      switch (e.inputType) {
        case 'insertText':
        case 'deleteContentBackward':
        case 'deleteContentForward':
          updateSearchThrottled();
          return true;
        default:
          return false;
      }
    });
    this.el.addEventListener('pick', (e) => {
      setSelectedIndex(e.detail.dispatcher.dataset.index);
      return pick(e);
    });
  },
};

export const PyroCopyToClipboard = {
  mounted() {
    this.content = this.el.innerHTML;
    let { value, message, ttl } = this.el.dataset;
    this.el.addEventListener('click', (e) => {
      e.preventDefault();
      navigator.clipboard.writeText(value);
      this.el.innerHTML = message || 'Copied to clipboard!';
      this.timeout = window.setTimeout(() => {
        this.el.innerHTML = this.content;
      }, ttl);
    });
  },
  updated() {
    window.clearTimeout(this.timeout);
  },
  destroyed() {
    window.clearTimeout(this.timeout);
  },
};

export const hooks = {
  PyroColorScheme,
  PyroFlashComponent,
  PyroNudgeIntoView,
  PyroAutocompleteComponent,
  PyroCopyToClipboard,
  PyroMaintainAttrs,
};

export function nudge(el) {
  let width = window.innerWidth;
  let height = window.innerHeight;
  let rect = el.getBoundingClientRect();

  hOffset = el.dataset?.horizontalOffset || 0;
  vOffset = el.dataset?.verticalOffset || 0;

  // Nudge left if offscreen
  if (rect.right + 24 > width) {
    el.style.right = hOffset;
    el.style.left = null;
  } else {
    el.style.left = hOffset;
    el.style.right = null;
  }

  // Nudge up if offscreen
  if (rect.bottom + 24 > height) {
    el.style.bottom = vOffset;
    el.style.top = null;
  } else {
    el.style.top = vOffset;
    el.style.bottom = null;
  }
}

export function resetHideTTL(self) {
  clearInterval(self.ttlInterval);
  if (self.el.dataset?.ttl > 0) {
    self.countdown = self.el.dataset?.ttl;
    self.ttlInterval = setInterval(() => {
      self.countdown = self.countdown - 16.7;
      if (self.countdown <= 0) {
        window.liveSocket.execJS(
          self.el,
          self.el.getAttribute('data-hide-exec-js'),
        );
      } else {
        el = document.querySelector(`#${self.el.id}>section>progress`);
        if (el) {
          el.value = self.countdown;
        } else {
          clearInterval(self.ttlInterval);
        }
      }
    }, 16.7);
  }
}

export function throttle(callback, limit) {
  let waiting = false;
  return function () {
    if (!waiting) {
      callback.apply(this, arguments);
      waiting = true;
      setTimeout(function () {
        callback.apply(this, arguments);
        waiting = false;
      }, limit);
    }
  };
}

export function selectValue(el) {
  if (typeof el.select === 'function') {
    el.select();
  }
}

export function focusAndSelect(el) {
  el.focus();
  selectValue(el);
}

export function booleanDataset(value) {
  return ![null, undefined, false, 'false'].includes(value);
}
