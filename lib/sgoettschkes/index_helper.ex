defmodule Sgoettschkes.IndexHelpers do
  def get_all_posts() do
    Sgoettschkes.Compiler.Post.get()
    |> Enum.sort_by(
      fn elem ->
        elem.metadata.date
        |> Timex.parse!("%Y-%m-%d %H:%M:%S %Z", :strftime)
      end,
      {:desc, Date}
    )
  end

  def format_post_date(post) do
    post.metadata.date
    |> Timex.parse!("%Y-%m-%d %H:%M:%S %Z", :strftime)
    |> Timex.format!("%b %d, %Y", :strftime)
  end

  def get_excerpt(post) do
    post.metadata.children
    |> Essence.Chunker.paragraphs()
    |> Enum.take(1)
    |> Earmark.as_html!(compact_output: true)
  end
end
