---
layout: _post.html.eex
category: dev
tags: [elixir, phoenix, javascript, cypress, testing]
title: "Phoenix UI testing with Cypress, Part 1"
author: Sebastian
date: 2021-02-03 17:30:00 UTC
permalink: p/phoenix-testing-with-cypress.html
---

I still remember the days I tried to achieve UI testing with Selenium, PhantomJS and various other tools. It was a hassle. It didn't run on CI because it needed some kind of window manager. It was unstable.

## Introducing Cypress

Cypress has solved these issues, hiding the complexity of UI testing and leaving you with the task of writing the tests. It comes with it's own UI where you can run tests and see what the test does in realtime. Cypress can do screenshots, videos of the tests and more.

In this tutorial, we'll mostly use `cypress run`. This command acts like `mix test` does: Running your tests and displaying the result within your terminal window. I encourage you to check out the other features of Cypress on your own.

## Cypress Setup

I assume you have an existing Elixir/Phoenix project you want to start using Cypress with. Your frontend files are located at `assets/` while your elixir tests are stored within `test/`. 

To install Cypress, we use npm: `cd assets/ && npm install cypress --save-dev`. Cypress installs itself and is afterwards available as a command line tool at `assets/node_modules/cypress/bin/cypress`.

Cypress by default expects all test files and support files to be located at `cypress/`. I'd argue a much better place for these files is in `test/cypress`, so this is where we're going to place them. If you like your Cypress tests to live someplace else, you'll find this guide helpful to figure out which adjustments you need to make.

## Config and support files

Let's start with the config file `cypress.json` in your root directory:

```json
{
  "componentFolder": false,
  "downloadsFolder": "tmp/cypress/downloads",
  "fixturesFolder": "test/cypress/fixtures",
  "integrationFolder": "test/cypress/integration",
  "pluginsFile": false,
  "screenshotOnRunFailure": false,
  "screenshotsFolder": "tmp/cypress/screenshots",
  "supportFile": false,
  "testFiles": "**/*.*",
  "video": false,
  "videosFolder": "tmp/cypress/videos"
}
```

As you can see, we overwrite all folders, either pointing to `test/cypress` or `tmp/cypress` (for files to be ignored). We also don't use support files or plugins and deactivate screenshots and videos.

## The first test

Now it's time to write the first test, a simple request to our homepage. Tests for Cypress are placed in the integrations folder which means creating the file `test/cypress/integration/index_spec.js`:

```js
describe('Homepage', () => {
  it('Visit homepage without interaction', () => {
    cy.visit('http://localhost:4000/')
  })
})
```

You can run this test using the command `./assets/node_modules/cypress/bin/cypress run` but it will fail if your Phoenix server does not run. Try it again after starting the server with `mix phx.serer` in another terminal window.

## The All-in-one shell file

We want to run the tests with one command, both locally and on a CI server. I used the shell script suggested by https://www.alanvardy.com/post/phoenix-cypress-tests and modified them a bit. Create a file `cypress-run.sh`, make it executable (`chmod +x cypress-run.sh`) and put the following code into it:

```sh
 #!/bin/sh

MIX_ENV=cypress mix ecto.reset
echo "===STARTING PHX SERVER==="
echo "===IF STARTING CYPRESS FAILS==="
echo "===RUN npm install cypress --save-dev ==="
echo "===IN THE assets/ FOLDER==="
MIX_ENV=cypress mix phx.server &
pid=$! # Store server pid
echo "===WAITING FOR PHX SERVER==="
until $(curl --output /dev/null --silent --head --fail http://localhost:4002); do
    printf '.'
    sleep 5
done
echo ""
echo "===PHX SERVER RUNNING==="
echo "===STARTING CYPRESS==="
./assets/node_modules/.bin/cypress run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
```

As you might have noticed, the `MIX_ENV` is set to `cypress`. To create this env, we need the new configuration file `config/cypress.exs`:

```elixir
use Mix.Config

# Configure your database
config :phonix, Phonix.Repo,
  username: "postgres",
  password: "postgres",
  database: "phonix_cypress",
  hostname: "localhost",
  pool_size: 10

config :phonix, PhonixWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
```

This approach is also copied from https://www.alanvardy.com/post/phoenix-cypress-tests. It's a great idea to separate the test environment from the ui test environment. As Alan suggests, you could use a tool like `ex_check` which can run your normal tests and your ui tests in parallel, which is only possible if you use different databases and thus different environments.

We are using a different port in the cypress env (`4002`), so make sure to adjust your tests accordingly.

Now you can run your UI tests by executing `./cypress-run.sh`. This script should run on your CI environment as well as locally. Just make sure to run `npm install` in your CI run!

## What else?

I intend to write a second part, figuring out how to use fixtures or reset the database between tests. I saw a few blog posts on how to do this, utilizing sockets in phoenix to take commands. I don't really like the approach and might come up with a way to work with the database directly. We'll see!
