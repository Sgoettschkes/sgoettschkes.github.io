defmodule Sgoettschkes.Application do
  use Application

  def start(_type, _args) do
    children = [
      Sgoettschkes.Compiler.Post,
      Sgoettschkes.Compiler.Sitemap
    ]

    opts = [strategy: :one_for_one]

    Supervisor.start_link(children, opts)
  end
end
