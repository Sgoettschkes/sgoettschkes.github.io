import Config

config :sgoettschkes,
  site_url: ""

config :still,
  dev_layout: false,
  ignore_files: ["assets"],
  input: Path.join(Path.dirname(__DIR__), "priv/site"),
  output: Path.join(Path.dirname(__DIR__), "_site"),
  pass_through_copy: ["CNAME", "css/app.css"],
  template_helpers: [Sgoettschkes.DataHelpers, Sgoettschkes.PostHelpers],
  preprocessors: %{
    ~r/\.html\.eex$/ => [
      Still.Preprocessor.AddContent,
      Still.Preprocessor.EEx,
      Still.Preprocessor.Frontmatter,
      Still.Preprocessor.OutputPath,
      Still.Preprocessor.AddLayout,
      Sgoettschkes.Preprocessor.Sitemap,
      Still.Preprocessor.Save
    ]
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
