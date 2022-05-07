Sgoettschkes/sgoettschkes.github.io
===================================

sgoettschkes.me goes [still](https://github.com/still-ex/still)

## Development

Install the dependencies using `mix deps.get` for Elixir and `npm install --prefix priv/site/assets` for Javascript.

Run the dev server using `mix still.dev` and see the result at http://localhost:3000/

## Production

Generate the html using `mix still.compile`. The final page is published into the `_site` folder.

## Publish

To publish the generate page (see above) to Github Pages, the content from `_site` has to be pushed to the `main` branch. The command `mix publish` will take care of this. It's run within the Github Actions workflow.
