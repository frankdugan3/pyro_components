const plugin = require('tailwindcss/plugin');
const fs = require('fs');
const path = require('path');

module.exports = plugin.withOptions(function (options = {}) {
  return function ({ theme, matchComponents }) {
    if (options.icons.includes('heroicons')) {
      const iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {};
      const icons = [
        ['', '/24/outline'],
        ['-solid', '/24/solid'],
        ['-mini', '/20/solid'],
        ['-micro', '/20/solid'],
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
            };
          },
        },
        { values },
      );
    }
    if (options.icons.includes('tabler_icons')) {
      const iconsDir = path.join(__dirname, "../deps/tabler_icons/icons")
      let values = {}
      const icons = [
        ["", "/outline"],
        ["-filled", "/filled"],
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          const name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents({
        "tabler": ({ name, fullPath }) => {
          const content = fs.readFileSync(fullPath).toString()
            .replace(/\r?\n|\r/g, "")
            .replace(/width="[^"]*"/, "")
            .replace(/height="[^"]*"/, "");

          return {
            [`--tabler-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--tabler-${name})`,
            "mask": `var(--tabler-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, { values })
    })
    }
    if (options.icons.includes('lucide_icons')) {
      const iconsDir = path.join(__dirname, "../deps/lucide_icons/icons")
      let values = {}
        fs.readdirSync(iconsDir).forEach(file => {
          const name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      matchComponents({
        "lucide": ({ name, fullPath }) => {
          const content = fs.readFileSync(fullPath).toString()
            .replace(/\r?\n|\r/g, "")
            .replace(/width="[^"]*"/, "")
            .replace(/height="[^"]*"/, "");

          return {
            [`--lucide-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--lucide-${name})`,
            "mask": `var(--lucide-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, { values })
    })
    }
  };
});
