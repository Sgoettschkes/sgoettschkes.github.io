Sgoettschkes/sgoettschkes.github.io
===================================

sgoettschkes.me goes [still](https://github.com/still-ex/still)

## Development

Install the dependencies using `mix deps.get` for Elixir and `npm install --prefix priv/site/assets` for Javascript.

Run the dev server using `mix still.dev` and see the result at http://localhost:3000/

### Update dependencies

To update mix dependencies and see the ones which can't be updated automatically, run `mix deps.update --all && mix hex.outdated`.

To update npm dependencies and see the ones which can't be updated automatically, run `npm update --prefix priv/site/assets --all && npm outdated --prefix priv/site/assets`

## Production

Generate the html using `mix still.compile`. The final page is published into the `_site` folder.

### Publishing

To publish the generate page (see above) to Github Pages, the content from `_site` has to be pushed to the `main` branch. The command `mix publish` will take care of this. It's run within the Github Actions workflow.
