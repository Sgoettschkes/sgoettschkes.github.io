defmodule Sgoettschkes.TemplateHelpers do
  def about_seenon() do
    read_yaml("priv/site/_data/about_seenon.yaml")
  end

  def about_projects() do
    read_yaml("priv/site/_data/about_projects.yaml")
  end

  def about_recent_talks() do
    read_yaml("priv/site/_data/about_talks.yaml")
    |> Map.get("recent")
  end

  def about_upcoming_talks() do
    read_yaml("priv/site/_data/about_talks.yaml")
    |> Map.get("upcoming")
  end

  def about_workshops() do
    read_yaml("priv/site/_data/about_workshops.yaml")
  end

  def about_publications() do
    read_yaml("priv/site/_data/about_publications.yaml")
  end

  def about_contributions() do
    read_yaml("priv/site/_data/about_contributions.yaml")
    |> Enum.sort(&(String.downcase(&1["repo"]) <= String.downcase(&2["repo"])))
    |> Enum.sort(&(String.downcase(&1["org"]) <= String.downcase(&2["org"])))
  end

  def now_doing() do
    read_yaml("priv/site/_data/now_doing.yaml")
  end

  def now_last_updated() do
    File.cwd!()
    |> Path.join("priv/site/_data/now_doing.yaml")
    |> File.lstat!()
    |> Map.get(:mtime)
    |> NaiveDateTime.from_erl!()
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.format!("%B %Y", :strftime)
  end

  defp read_yaml(path) do
    File.cwd!()
    |> Path.join(path)
    |> YamlElixir.read_from_file!(atoms: true)
  end
end
