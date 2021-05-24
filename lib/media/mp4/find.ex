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

  # TODO: make `find` the final function, with multi-arity; do away with find_all_children
  def find(%{info: i, children: c}, key) when is_atom(key) do
    IO.puts("find in #{i.type}")
    with {:ok, child} <- find_key(c, key) do
      Result.wrap(child)
    else
      {:error, _} ->
        find_in_children(c, key)
    end
  end

  def find(%{children: c} = child, key) when is_atom(key) do
    IO.puts("find in mp4")
    with {:ok, child} = r <- find_key(c, key) do
      r
    else
      {:error, _} ->
        find_in_children(c, key)
    end
  end

  @spec find_key([term()], atom()) :: Result.t()
  defp find_key(nil, key), do: Result.wrap_err(:no_children)
  defp find_key([], key), do: Result.wrap_err(:no_children)
  defp find_key(children, key) when is_list(children) do
    with true <- Keyword.has_key?(children, key) do
      Result.wrap(Keyword.fetch!(children, key))
    else
      _ ->
        Result.wrap_err(:key_not_found)
    end
  end

  @spec find_in_children([term()], atom()) :: Result.t()
  defp find_in_children([{box, %{children: c} = child} | tail], key) do
    IO.puts("\tsearching in #{box}")
    child
    |> find(key)
    |> case do
         {:ok, child} ->
           child

         _ ->
           IO.puts("\tsearching in #{box}")
           find_in_children(tail, key)
       end
    #    with {:ok, child} <- find_key(c, key) do
    #      child
    #    else
    #      {:error, _} -> find_in_children(tail, key)
    #    end
  end

  defp find_in_children([_ | tail], key), do: find_in_children(tail, key)
  defp find_in_children([], _), do: Result.wrap_err(:key_not_found)
  defp find_in_children(nil, _), do: Result.wrap_err(:key_not_found)
end
