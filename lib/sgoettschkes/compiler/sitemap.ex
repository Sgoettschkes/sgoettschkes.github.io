defmodule Sgoettschkes.Compiler.Sitemap do
  @moduledoc """
  Keeps track of all files that should be added to sitemap.
  """

  alias Still.SourceFile

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Resets the collection.
  """
  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  @doc """
  Returns all files that should be inserted into the sitemap
  """
  def get() do
    GenServer.call(__MODULE__, {:get}, :infinity)
  end

  @doc """
  Adds a file to the collection.
  """
  @spec add(SourceFile.t()) :: any()
  def add(file = %{output_file: output_file, metadata: %{sitemap: true}}) do
    case String.match?(output_file, ~r/^_/) do
      true -> :ok
      false -> GenServer.call(__MODULE__, {:add, file}, :infinity)
    end
  end

  def add(file = %{metadata: %{output_file: output_file}}) do
    case String.match?(output_file, ~r/^p\//) do
      true -> GenServer.call(__MODULE__, {:add, file}, :infinity)
      false -> :ok
    end
  end

  def add(_file), do: :ok

  @impl true
  def init(_) do
    {:ok, %{files: []}}
  end

  @impl true
  def handle_call({:add, file}, _, state) do
    files = insert_file(file, state.files)

    {:reply, :ok, %{state | files: files}}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, %{files: []}}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state.files, state}
  end

  defp insert_file(file, files) do
    output_file = Map.get(file.metadata, :output_file, file.output_file)

    case Enum.member?(files, output_file) do
      true -> files
      false -> [output_file | files]
    end
  end
end
