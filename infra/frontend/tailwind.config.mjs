/** @type {import('tailwindcss').Config} */
export default {
	darkMode: "class",
	content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
	theme: {
		extend: { 
			animation: {
			fade: 'fadeOut 5s ease-in-out',
			}},
			keyframes: theme => ({
			fadeOut: {
			  '0%': { backgroundColor: theme('colors.purple.300') },
			  '100%': { backgroundColor: theme('colors.transparent') },
			},
		}),
	},
	plugins: [require("@tailwindcss/typography"),
			  require('tailwind-plugin-typed')]
};
