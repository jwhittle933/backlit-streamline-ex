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
  `find` recursively searches the mp4 for a box and returns a Result
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

  @doc """
  `find!` recursively searches the mp4 for a box.
  The result is unwrapped, either with the value
  or raising an error
  """
  @spec find!(MP4.t(), String.t() | atom(), [atom()]) :: Result.t()
  def find!(box, key, opts \\ [])
  def find!(box, key, opts) when is_atom(key) do
    box
    |> find(Atom.to_string(key), opts)
    |> Result.expect("Box #{key} not found")
  end

  def find!(box, key, opts) do
    box
    |> find(key, opts)
    |> Result.expect("Box #{key} not found")
  end
end
