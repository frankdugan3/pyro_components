const plugin = require('tailwindcss/plugin')
const fs = require('fs')
const path = require('path')

module.exports = plugin.withOptions(function (options = {}) {
  return function ({ addVariant, addBase, theme, matchComponents }) {
    if (options.heroIconsPath) {
      let iconsDir = options.heroIconsPath
      let values = {}
      let icons = [
        ['', '/24/outline'],
        ['-solid', '/24/solid'],
        ['-mini', '/20/solid'],
        ['-micro', '/20/solid'],
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, '.svg') + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '')
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: theme('spacing.5'),
              height: theme('spacing.5'),
            }
          },
        },
        { values },
      )
    }

    addVariant('phx-no-feedback', ['.phx-no-feedback&', '.phx-no-feedback &'])
    addVariant('phx-click-loading', [
      '.phx-click-loading&',
      '.phx-click-loading &',
    ])
    addVariant('phx-submit-loading', [
      '.phx-submit-loading&',
      '.phx-submit-loading &',
    ])
    addVariant('phx-change-loading', [
      '.phx-change-loading&',
      '.phx-change-loading &',
    ])
    addVariant('has-errors', '&.has-errors')
    addVariant('aria-selected', '&[aria-selected]')
    addVariant('aria-checked', '&[aria-checked]')

    if (options.addBase) {
      addBase({
        '::selection, ::-moz-selection': {
          '@apply text-white bg-sky-500 bg-opacity-100': {},
        },

        ':root': { '--scrollbar-width': '0.5rem' },

        // Firefox
        '*': {
          'scrollbar-width': 'auto',
          'scrollbar-height': 'auto',
          'scrollbar-color': 'theme(colors.sky.500) transparent',
        },

        // Chrome, Edge, and Safari
        '*::-webkit-scrollbar': {
          width: 'var(--scrollbar-width)',
          height: 'var(--scrollbar-width)',
        },
        '*::-webkit-scrollbar-button': {
          '@apply bg-transparent h-0 w-0': {},
        },
        '::-webkit-scrollbar-corner': { '@apply bg-transparent': {} },
        '*::-webkit-scrollbar-track': { background: 'transparent' },
        '*::-webkit-scrollbar-track-piece': { '@apply bg-transparent': {} },
        '*::-webkit-scrollbar-thumb': {
          '@apply bg-sky-500 border-none rounded-full': {},
        },

        var: {
          '@apply not-italic rounded font-mono text-sm font-semibold px-2 py-px mx-px bg-slate-900 text-white dark:bg-white dark:text-slate-900':
            {},
        },

        'html, body': {
          '@apply text-slate-900 dark:text-white m-0  h-full': {},
        },

        html: { 'scrollbar-gutter': 'stable', '@apply p-0': {} },
        body: {
          '@apply antialiased bg-white dark:bg-gradient-to-tr dark:from-slate-900 dark:to-slate-800':
            {},
        },
      })
    }
  }
})
