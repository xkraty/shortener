const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        display: ['Outfit', ...defaultTheme.fontFamily.sans],
        sans: ['Nunito', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        paper: 'var(--paper)',
        'paper-lift': 'var(--paper-lift)',
        ink: 'var(--ink)',
        txt: 'var(--txt)',
        'txt-dim': 'var(--txt-dim)',
        green: {
          DEFAULT: 'var(--green)',
          ink: 'var(--green-ink)',
          lift: 'var(--green-lift)',
          tint: 'var(--green-tint)',
        },
        'on-green': 'var(--on-green)',
        dark: {
          DEFAULT: 'var(--dark)',
          2: 'var(--dark-2)',
        },
        'on-dark': 'var(--on-dark)',
        'on-dark-dim': 'var(--on-dark-dim)',
        hair: 'var(--hair)',
      },
      // Radii and elevation from campoli's DESIGN.md tokens (`rounded`,
      // `elevation`) — crisp and small, not the bubbly Tailwind defaults.
      borderRadius: {
        plate: '3px',
        panel: '4px',
      },
      boxShadow: {
        board: '0 6px 14px rgba(32, 30, 29, 0.16)',
        'board-sm': '0 2px 8px rgba(32, 30, 29, 0.10)',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
