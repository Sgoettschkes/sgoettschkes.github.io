defmodule Sgoettschkes.Preprocessor.Post do
  use Still.Preprocessor

  @impl true
  def render(file) do
    Sgoettschkes.Compiler.Post.add(file)

    file
  end
end
