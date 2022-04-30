defmodule Sgoettschkes.FeedHelpers do
  def get_link(), do: Application.get_env(:sgoettschkes, :site_url)

  def get_datetime() do
    "Etc/UTC"
    |> DateTime.now!()
    |> Timex.format!("%a, %d %b %Y %H:%M:%S %z", :strftime)
  end

  def get_feed_url(), do: Application.get_env(:sgoettschkes, :site_url) <> "feed.xml"

  def get_posts() do
    Sgoettschkes.Compiler.Post.get()
    |> Enum.sort_by(
      fn elem ->
        elem.metadata.date
        |> Timex.parse!("%Y-%m-%d %H:%M:%S %Z", :strftime)
      end,
      {:desc, Date}
    )
    |> Enum.take(10)
  end

  def get_pub_date(post) do
    post.metadata.date
    |> Timex.parse!("%Y-%m-%d %H:%M:%S %Z", :strftime)
    |> Timex.format!("%a, %d %b %Y %H:%M:%S %z", :strftime)
  end

  def get_post_url(post) do
    site_url = Application.get_env(:sgoettschkes, :site_url)

    site_url <> post.metadata.output_file
  end
end
