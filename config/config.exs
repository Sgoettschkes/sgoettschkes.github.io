import Config

config :still,
  dev_layout: false,
  ignore_files: ["assets"],
  input: Path.join(Path.dirname(__DIR__), "priv/site"),
  output: Path.join(Path.dirname(__DIR__), "_site"),
  pass_through_copy: ["css/app.css"],
  watchers: [
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../css/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("../priv/site/assets", __DIR__)
    ]
  ]

import_config("#{Mix.env()}.exs")
