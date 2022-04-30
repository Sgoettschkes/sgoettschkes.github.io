defmodule Sgoettschkes.RobotHelpers do
  def get_sitemap_url(), do: Application.get_env(:sgoettschkes, :site_url) <> "sitemap.xml"
end
