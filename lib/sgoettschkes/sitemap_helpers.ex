defmodule Sgoettschkes.SitemapHelpers do
  def get_sitemap_collection() do
    site_url = Application.get_env(:sgoettschkes, :site_url)

    Sgoettschkes.Compiler.Sitemap.get()
    |> Enum.map(fn entry -> site_url <> entry end)
  end
end
