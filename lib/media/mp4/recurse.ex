defmodule Streamline.Media.MP4.Recurse do
  @moduledoc """
  Module `recurse` for recursively reading MP4
  """
  alias Streamline.Result
  alias Streamline.Media.MP4
  alias MP4.Box.Info

  def recurse(mp4, fun, acc \\ [])
  def recurse(_, fun, _acc) when not is_function(fun, 1), do: Result.wrap_err(:invalid_callback)
  def recurse(%{children: c} = box, fun, acc), do: recurse(c, fun, acc ++ [fun.(box)])
  def recurse(box, fun, acc) when is_map(box), do: acc ++ [fun.(box)]

  def recurse([{_, %{children: c} = box} | tail], fun, acc) do
    recurse(tail, fun, acc ++ [fun.(box)] ++ recurse(c, fun, acc))
  end

  def recurse([{name, box} | tail], fun, acc), do: recurse(tail, fun, acc ++ [fun.(box)])
  def recurse([], _fun, acc), do: acc
  def recurse(nil, _fun, acc), do: acc

  def print_all(%MP4{} = m) do
    recurse(m, &print/1)
  end

  defp print(
         %{
           info: %Info{
             type: t,
             size: s,
             offset: o
           }
         }
       ) do
    IO.puts("[#{t}] offset=#{o} size=#{s} ")
    nil
  end

  defp print(_), do: nil
end
