defmodule Sgoettschkes.DataHelpers do
  def about_seenon(), do: read_yaml("about_seenon.yaml")

  def about_projects(), do: read_yaml("about_projects.yaml")

  def about_recent_talks() do
    "about_talks.yaml"
    |> read_yaml()
    |> Map.get("recent")
  end

  def about_upcoming_talks() do
    "about_talks.yaml"
    |> read_yaml()
    |> Map.get("upcoming")
  end

  def about_workshops(), do: read_yaml("about_workshops.yaml")

  def about_publications(), do: read_yaml("about_publications.yaml")

  def about_contributions() do
    "about_contributions.yaml"
    |> read_yaml()
    |> Enum.sort(&(String.downcase(&1["repo"]) <= String.downcase(&2["repo"])))
    |> Enum.sort(&(String.downcase(&1["org"]) <= String.downcase(&2["org"])))
  end

  def now_doing(), do: read_yaml("now_doing.yaml")

  def now_last_updated() do
    File.cwd!()
    |> Path.join("priv/site/_data/now_doing.yaml")
    |> File.lstat!()
    |> Map.get(:mtime)
    |> NaiveDateTime.from_erl!()
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.format!("%B %Y", :strftime)
  end

  defp read_yaml(filename) do
    File.cwd!()
    |> Path.join("priv/site/_data")
    |> Path.join(filename)
    |> YamlElixir.read_from_file!(atoms: true)
  end
end
