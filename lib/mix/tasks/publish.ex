defmodule Mix.Tasks.Publish do
  use Mix.Task

  @deploy_branch "test"
  @github_reponame "Sgoettschkes/sgoettschkes.github.io.git"

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    case System.get_env("GITHUB_ACTIONS") do
      "true" -> compile_and_publish()
      _else -> Mix.raise("Not running on Github Actions")
    end
  end

  defp compile_and_publish() do
    Mix.Task.run("still.compile")

    timestamp = Timex.now() |> Timex.to_unix() |> Integer.to_string()
    cur_dir = File.cwd!()
    dest_dir = Path.join([System.tmp_dir!(), "still", timestamp])

    File.mkdir_p!(dest_dir)
    File.cp_r("./_site", dest_dir)
    File.cp("./README.md", dest_dir <> "/README.md")
    File.cd!(dest_dir)

    System.cmd("git", ["config", "--global", "init.defaultBranch", @deploy_branch],
      into: IO.stream()
    )

    System.cmd("git", ["config", "--global", "user.name", "'Sebastian Göttschkes'"],
      into: IO.stream()
    )

    System.cmd(
      "git",
      [
        "config",
        "--global",
        "user.email",
        "'sebastian.goettschkes@googlemail.com'"
      ],
      into: IO.stream()
    )

    System.cmd("git", ["init"], into: IO.stream())

    github_remote = "https://#{System.get_env("GH_TOKEN")}@github.com/#{@github_reponame}"

    System.cmd("git", ["add", "."], into: IO.stream())
    System.cmd("git", ["commit", "-m", "Site updated"], into: IO.stream())
    System.cmd("git", ["remote", "add", "origin", github_remote], into: IO.stream())
    System.cmd("git", ["push", "--quiet", "--force", "origin", @deploy_branch], into: IO.stream())

    File.cd!(cur_dir)
  end
end
