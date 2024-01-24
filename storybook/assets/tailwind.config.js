const path = require('path');

module.exports = {
  darkMode: 'class',
  content: [
    './js/**/*.js',
    '../lib/pyro_components_storybook_web.ex',
    '../lib/pyro_components_storybook_web/**/*.*ex',
    '../../lib/pyro_components/overrides/bem.ex',
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require(path.join(__dirname, '../../assets/js/tailwind-plugin.js'))({
      heroIconsPath: path.join(__dirname, '../deps/heroicons/optimized'),
      addBase: true,
    }),
  ],
};
