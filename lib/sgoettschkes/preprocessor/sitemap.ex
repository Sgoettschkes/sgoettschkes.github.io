defmodule Sgoettschkes.Preprocessor.Sitemap do
  use Still.Preprocessor

  @impl true
  def render(file) do
    Sgoettschkes.Compiler.Sitemap.add(file)

    file
  end
end
