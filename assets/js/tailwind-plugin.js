const plugin = require('tailwindcss/plugin');
const fs = require('fs');
const path = require('path');

module.exports = plugin.withOptions(function (options = {}) {
  return function ({ addVariant, addBase, theme, matchComponents }) {
    addVariant('phx-click-loading', [
      '.phx-click-loading&',
      '.phx-click-loading &',
    ]);
    addVariant('phx-submit-loading', [
      '.phx-submit-loading&',
      '.phx-submit-loading &',
    ]);
    addVariant('phx-change-loading', [
      '.phx-change-loading&',
      '.phx-change-loading &',
    ]);
    addVariant('has-errors', '&.has-errors');
    addVariant('selected', '&[selected]');
    addVariant('aria-selected', '&[aria-selected]');
    addVariant('aria-checked', '&[aria-checked]');

    if (options.addBase) {
      addBase({
        var: {
          '@apply not-italic rounded font-mono text-sm font-semibold px-2 py-px mx-px bg-black text-white dark:bg-white dark:text-black':
            {},
        },
        'html, body': { '@apply text-black dark:text-white m-0  h-full': {} },
        html: { 'scrollbar-gutter': 'stable', '@apply p-0': {} },
        body: { '@apply antialiased bg-white dark:bg-black': {} },
      });
    }
  };
});
