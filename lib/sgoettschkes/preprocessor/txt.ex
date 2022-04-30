defmodule Sgoettschkes.Preprocessor.Txt do
  use Still.Preprocessor

  @impl true
  def render(file) do
    %{file | extension: ".txt"}
  end
end
