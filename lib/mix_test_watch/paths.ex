defmodule MixTestWatch.Path do
  @moduledoc """
  Decides if we should refresh for a path.
  """

  @elixir_source_pattern ~r/\.(erl|ex|exs|eex|xrl|yrl)\z/i

  @ignored_dirs ~w(
    deps/
    _build/
  )

  @spec watching?(String.t) :: boolean

  def watching?(config \\ %{include: []}, path) do
    _watching?( path ) || _watching?(config, path)
  end

  @spec excluded?(MixTestWatch.Config.t, String.t) :: boolean

  def excluded?(config, path) do
    config.exclude
    |> Enum.map(fn pattern -> Regex.match?(pattern, path)  end)
    |> Enum.any?()
  end

  defp _watching?(path) do
    watched_directory?( path ) && elixir_extension?( path )
  end

  defp _watching?(config, path) do
    String.ends_with?(path, config.include)
  end

  defp watched_directory?(path) do
    not String.starts_with?( path, @ignored_dirs )
  end

  defp elixir_extension?(path) do
    @elixir_source_pattern
    |> Regex.match?( path )
  end
end
