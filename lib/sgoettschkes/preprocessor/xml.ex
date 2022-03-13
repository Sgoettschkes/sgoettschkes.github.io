defmodule Sgoettschkes.Preprocessor.Xml do
  use Still.Preprocessor

  @impl true
  def render(file) do
    %{file | extension: ".xml"}
  end
end
