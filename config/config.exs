import Config

config :sgoettschkes,
  site_url: ""

config :still,
  dev_layout: false,
  ignore_files: ["assets"],
  input: Path.join(Path.dirname(__DIR__), "priv/site"),
  output: Path.join(Path.dirname(__DIR__), "_site"),
  pass_through_copy: ["CNAME", "css/app.css"],
  preprocessors: %{
    ~r/\.html\.eex$/ => [
      Still.Preprocessor.AddContent,
      Still.Preprocessor.EEx,
      Still.Preprocessor.Frontmatter,
      Still.Preprocessor.OutputPath,
      Still.Preprocessor.AddLayout,
      Sgoettschkes.Preprocessor.Post,
      Sgoettschkes.Preprocessor.Sitemap,
      Still.Preprocessor.Save
    ],
    ~r/\.xml\.eex$/ => [
      Still.Preprocessor.AddContent,
      Still.Preprocessor.EEx,
      Still.Preprocessor.Frontmatter,
      Still.Preprocessor.OutputPath,
      Sgoettschkes.Preprocessor.Xml,
      Still.Preprocessor.Save
    ],
    ~r/\.txt\.eex$/ => [
      Still.Preprocessor.AddContent,
      Still.Preprocessor.EEx,
      Still.Preprocessor.Frontmatter,
      Still.Preprocessor.OutputPath,
      Sgoettschkes.Preprocessor.Txt,
      Still.Preprocessor.Save
    ]
  },
  template_helpers: [
    Sgoettschkes.DataHelpers,
    Sgoettschkes.FeedHelpers,
    Sgoettschkes.IndexHelpers,
    Sgoettschkes.PostHelpers,
    Sgoettschkes.RobotHelpers,
    Sgoettschkes.SitemapHelpers
  ],
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
