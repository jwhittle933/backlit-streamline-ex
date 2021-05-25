defmodule Streamline.Media.MP4.Find do
  @moduledoc """
  Module `find` for mp4 searching
  """
  alias Streamline.Result
  alias Streamline.Media.MP4
  alias MP4.Box.Info
  alias MP4.Recurse

  @find_opts [:truncate]

  @doc """
  `find` recursively searches the mp4 for a box
  """
  @spec find(MP4.t(), String.t() | atom(), [atom()]) :: Result.t()
  def find(box, key, opts \\ [])
  def find(box, key, _opts) when is_atom(key), do: find(box, Atom.to_string(key))
  def find(box, key, _opts) when is_binary(key), do: Recurse.recurse(
    box,
    fn
      %{
        info: %{
          type: ^key
        }
      } = box, result -> Result.wrap(box)
      _box, result -> result
    end,
    Result.wrap_err(:key_not_found)
  )

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
  defp find_in_children([{ box, %{ children: c } = child } | tail], key) do
    child
    |> find(key)
    |> case do
         { :ok, child } ->
           child

         _ ->
           find_in_children(tail, key)
       end
  end

  defp find_in_children([_ | tail], key), do: find_in_children(tail, key)
  defp find_in_children([], _), do: Result.wrap_err(:key_not_found)
  defp find_in_children(nil, _), do: Result.wrap_err(:key_not_found)
end
