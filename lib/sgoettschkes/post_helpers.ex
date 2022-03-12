defmodule Sgoettschkes.PostHelpers do
  def format_datetime(datetime_string) do
    datetime_string
    |> Timex.parse!("%Y-%m-%d %H:%M:%S %Z", :strftime)
    |> Timex.format!("%b %d, %Y", :strftime)
  end
end
