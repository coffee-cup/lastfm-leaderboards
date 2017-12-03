# elm-template

This is a simple static website template using [Elm](http://elm-lang.org). [Here is an example of this template](https://coffee-cup-elm-template.surge.sh/).

## Features 💥

- [Elm](http://elm-lang.org/)
- [ES6](https://github.com/lukehoban/es6features)
- [ESLint](http://eslint.org/)
- [Prettier](https://github.com/prettier/prettier)
- [Webpack](https://webpack.github.io/)
- [PostCSS](https://github.com/postcss/postcss)
- [SCSS](http://sass-lang.com/)
- [Tachyons](http://tachyons.io/)
- [Normalize](https://github.com/JohnAlbin/normalize-scss)
- Simple AF ☄

## Development ✨

1. Clone repo
2. `yarn install`
3. `npm run dev` for live reload server at [localhost:8080](http://localhost:8080)
4. `npm run build` for production ready static site

### Source 👼

- Elm in `src/`
- SCSS in `src/scss`
- Public files in `public/`
- Metadata for pages in `metadata/`

### Deployment 🚀

This template can easily be deployed with [surge.sh](https://surge.sh/). Just open up `package.json` and change `...` in the `deploy` script to your domain. Then run `npm run deploy` and your website will be built and deployed!

### A Note on Page Metadata

The problem with static single page apps is that metadata (title, description) is set after the page has initially loaded. This means it is not picked up in site previews, such as sharing to Slack, FB, Twitter, etc.

A solution I use in this template is to generate different `{route}/index.html` pages with the different metadata. It seems to work pretty well and prevents the need to stand up a server.

Page metadata is defined in `json` format in the `metadata/` directory. The `template.mustache` is used as a template when generating the `index.html` files. See `metadata/index.json` as an example. The pages are generated in the `postbuild` npm script.

_You should not edit `public/index.html`. Only `metadata/tempate.mustache`._
