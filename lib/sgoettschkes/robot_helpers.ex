defmodule Sgoettschkes.RobotHelpers do
  def get_sitemap_url() do
    site_url = Application.get_env(:sgoettschkes, :site_url)

    site_url <> "sitemap.xml"
  end
end
