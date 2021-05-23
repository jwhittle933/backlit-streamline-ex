defmodule Streamline.Media.MP4.Find do
  @moduledoc """
  Module `find` for mp4 searching
  """
  alias Streamline.Result
  alias Streamline.Media.MP4

  @find_opts [:truncate]

  @doc """
  `find` recursively searches the mp4 for a box
  """
  @spec find(MP4.t(), String.t() | atom()) :: Result.t()
  def find(%MP4{children: []}, _key), do: Result.wrap_err(:no_children)
  def find(%MP4{children: c}, key) when is_binary(key), do: find(c, String.to_atom(key))

  def find(%{children: c}, key) when is_atom(key) do
    with {:ok, child} <- find_key(c, key) do
      child
    else
      {:error, _} ->
        find_in_children(c, key)
    end
  end

  @spec find_key([term()], atom()) :: Result.t()
  defp find_key(children, key) when is_list(children) do
    with true <- Keyword.has_key?(children, key) do
      Result.wrap(Keyword.fetch!(children, key))
    else
      _ -> Result.wrap_err(:key_not_found)
    end
  end

  @spec find_in_children([term()], atom()) :: Result.t()
  defp find_in_children([{_, %{children: c}} | tail], key) do
    with {:ok, child} <- find_key(c, key) do
      child
    else
      {:error, _} -> find_in_children(tail, key)
    end
  end

  defp find_in_children([_ | tail], key), do: find_in_children(tail, key)
  defp find_in_children([], _), do: Result.wrap_err(:key_not_found)
end
