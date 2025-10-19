/*

  PYRO TAILWIND PLUGIN

  Supports the following icon libraries:

  - Hero
  - Tabler
  - Feather
  - Lucide
  - custom svg icons

  In your CSS, import and configure the plugin:

  @plugin "../../deps/pyro_components/assets/tailwind-plugin.js" {
    addbase: true;
    icons: 'hero', 'custom';
  }

  Then, add the relevant icon libraries to your `mix.exs` file:

    {:heroicons,
     github: "tailwindlabs/heroicons",
     tag: "v2.2.0",
     sparse: "optimized",
     app: false,
     compile: false,
     depth: 1},
    {:tablericons,
     github: "tabler/tabler-icons",
     tag: "v3.31.0",
     sparse: "icons",
     app: false,
     compile: false,
     depth: 1},
    {:feathericons,
     github: "feathericons/feather",
     tag: "v4.29.2",
     sparse: "icons",
     app: false,
     compile: false,
     depth: 1},
    {:lucide,
     github: "lucide-icons/lucideicons",
     tag: "0.507.0",
     sparse: "icons",
     app: false,
     compile: false,
     depth: 1},

  Pyro's icon component will automatically detect available icon libraries.

*/
const plugin = require('tailwindcss/plugin');
const fs = require('fs');
const path = require('path');

module.exports = plugin.withOptions(function (options = {}) {
  const projectDir = options?.projectDir || process.cwd();
  return function ({ addUtilities, addVariant, addBase, theme, matchComponents }) {
    addUtilities({
      '.base-colors': {
        backgroundColor: 'var(--color-base-bg)',
        color: 'var(--color-base-bg)',
      },
      '.pattern-tiny-checkers': {
        'background-image': `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='8' viewBox='0 0 8 8'%3E%3Cg fill='%23000000' fill-opacity='0.4'%3E%3Cpath fill-rule='evenodd' d='M0 0h4v4H0V0zm4 4h4v4H4V4z'/%3E%3C/g%3E%3C/svg%3E")`,
      },
    });
    addVariant('phx-click-loading', ['.phx-click-loading&', '.phx-click-loading &']);
    addVariant('phx-submit-loading', ['.phx-submit-loading&', '.phx-submit-loading &']);
    addVariant('phx-change-loading', ['.phx-change-loading&', '.phx-change-loading &']);

    // addVariant('selected', '&[selected]');
    // addVariant('aria-selected', '&[aria-selected]');
    // addVariant('aria-checked', '&[aria-checked]');

    addVariant('dark', ['&:where([data-color-scheme^="dark"]', '[data-color-scheme^="dark"] *']);
    addVariant('color-scheme-system', ['&:where([data-color-scheme*="-system"]', '[data-color-scheme*="-system"] *']);
    addVariant('color-scheme-dark', ['&:where([data-color-scheme="dark"]', '[data-color-scheme="dark"] *']);
    addVariant('color-scheme-light', ['&:where([data-color-scheme="light"]', '[data-color-scheme="light"] *']);

    addVariant('editor-mode-vscode', ['&:where([data-editor-mode="vscode"]', '[data-editor-mode="vscode"] *']);
    addVariant('editor-mode-vim', ['&:where([data-editor-mode="vim"]', '[data-editor-mode="vim"] *']);
    addVariant('editor-mode-emacs', ['&:where([data-editor-mode="emacs"]', '[data-editor-mode="emacs"] *']);

    addBase({
      ':root': {
        colorScheme: 'light',
        '@variant dark': { colorScheme: 'dark' },
        '--scrollbar-width': '0.7rem',
        '--scrollbar-thumb-color': '#888888',
        scrollbarWidth: 'var(--scrollbar-width)',
        scrollbarHeight: 'var(--scrollbar-width)',
      },
      '::selection,\n::-moz-selection': {
        backgroundColor: 'var(--color-base-bg)',
        color: 'var(--color-base-fg)',
      },
      '::-webkit-scrollbar': {
        width: 'var(--scrollbar-width)',
        height: 'var(--scrollbar-width)',
      },
      '::-webkit-scrollbar-track': { marginBlock: '0.5em' },
      '::-webkit-scrollbar-button,\n::-webkit-scrollbar-track-piece,\n::-webkit-scrollbar-corner': {
        background: 'transparent',
        height: 0,
        widith: 0,
      },
      '::-webkit-scrollbar-thumb': {
        backgroundColor: 'var(--scrollbar-thumb-color)',
        minHeight: '4em',
        borderRadius: '100vw',
      },
      // Firefox
      '@supports (scrollbar-color: black white)': {
        '*': {
          scrollbarColor: 'var(--scrollbar-thumb-color transparent)',
          scrollbarWidth: 'auto',
        },
      },
      'html, body': {
        backgroundColor: 'var(--color-base-bg)',
        color: 'var(--color-base-fg)',
        padding: 0,
        margin: 0,
      },
      html: { scrollbarGutter: 'stable' },
      body: {
        '-webkit-font-smoothing': 'antialiased',
        '-moz-osx-font-smoothing': 'grayscale',
      },
    });

    if (options?.icons.includes('custom')) {
      let iconsDir = path.join(projectDir, 'assets/svg-icons/');
      let values = {};
      fs.readdirSync(iconsDir).forEach((file) => {
        const name = path.basename(file, '.svg');
        values[name] = { name, fullPath: path.join(iconsDir, file) };
      });
      matchComponents(
        {
          svgicon: ({ name, fullPath }) => {
            const content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '');

            return {
              [`--svgicon-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--svgicon-${name})`,
              mask: `var(--svgicon-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: theme('spacing.5'),
              height: theme('spacing.5'),
            };
          },
        },
        { values },
      );
    }
    if (options?.icons.includes('hero')) {
      let iconsDir = path.join(projectDir, 'deps/heroicons/optimized');
      let values = {};
      let icons = [
        ['', '/24/outline'],
        ['-solid', '/24/solid'],
        ['-mini', '/20/solid'],
        ['-micro', '/16/solid'],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, '.svg') + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '');
            let size = theme('spacing.6');
            if (name.endsWith('-mini')) {
              size = theme('spacing.5');
            } else if (name.endsWith('-micro')) {
              size = theme('spacing.4');
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: size,
              height: size,
            };
          },
        },
        { values },
      );
    }
    if (options?.icons.includes('tabler')) {
      let iconsDir = path.join(projectDir, 'deps/tablericons/icons');
      let values = {};
      const icons = [
        ['', '/outline'],
        ['-filled', '/filled'],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          const name = path.basename(file, '.svg') + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          tabler: ({ name, fullPath }) => {
            const content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '')
              .replace(/width="[^"]*"/, '')
              .replace(/height="[^"]*"/, '');

            return {
              [`--tabler-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--tabler-${name})`,
              mask: `var(--tabler-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: theme('spacing.5'),
              height: theme('spacing.5'),
            };
          },
        },
        { values },
      );
    }
    if (options?.icons.includes('lucide')) {
      let iconsDir = path.join(projectDir, 'deps/lucideicons/icons');
      let values = {};
      fs.readdirSync(iconsDir).forEach((file) => {
        if (path.extname(file) != '.svg') return;

        let name = path.basename(file, '.svg');
        values[name] = { name, fullPath: path.join(iconsDir, file) };
      });
      matchComponents(
        {
          lucide: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '')
              .replace(/stroke-width="2"/g, 'stroke-width="1.5"')
              .replace(/(?:width|height)="24"\s?/g, '');
            let size = theme('spacing.6');

            return {
              [`--lucide-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--lucide-${name})`,
              mask: `var(--lucide-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: size,
              height: size,
            };
          },
        },
        { values },
      );
    }
    if (options?.icons.includes('feather')) {
      let iconsDir = path.join(projectDir, 'deps/feathericons/icons');
      let values = {};
      fs.readdirSync(iconsDir).forEach((file) => {
        if (path.extname(file) != '.svg') return;

        let name = path.basename(file, '.svg');
        values[name] = { name, fullPath: path.join(iconsDir, file) };
      });
      matchComponents(
        {
          feather: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '')
              .replace(/stroke-width="2"/g, 'stroke-width="1.5"')
              .replace(/(?:width|height)="24"\s?/g, '');
            let size = theme('spacing.6');

            return {
              [`--feather-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--feather-${name})`,
              mask: `var(--feather-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: size,
              height: size,
            };
          },
        },
        { values },
      );
    }
  };
});
