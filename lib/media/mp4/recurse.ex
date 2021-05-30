defmodule Streamline.Media.MP4.Recurse do
  @moduledoc """
  Module `recurse` for recursively reading MP4
  """
  alias Streamline.Result
  alias Streamline.Media.MP4
  alias MP4.Box.Info

  @spec recurse(MP4.t(), (term(), term() -> term()), [term()]) :: [term()]
  def recurse(box, fun, acc \\ [])
  def recurse(_, fun, _acc) when not is_function(fun, 2), do: Result.wrap_err(:invalid_callback)
  def recurse(%{ children: c } = box, fun, acc), do: recurse(c, fun, fun.(box, acc))
  def recurse(box, fun, acc) when is_map(box), do: fun.(box, acc)

  def recurse([{ _, %{ children: c } = box } | tail], fun, acc) do
    box
    |> fun.(acc)
    |> (&recurse(c, fun, &1)).()
    |> (&recurse(tail, fun, &1)).()
  end

  def recurse([{ _, box } | tail], fun, acc), do: recurse(tail, fun, fun.(box, acc))
  def recurse([], _fun, acc), do: acc
  def recurse(nil, _fun, acc), do: acc

  @doc """
  `print_all` recurses the mp4 and prints every box's info
  """
  def print_all(%MP4{ } = m), do: recurse(m, &print/2, :ok)

  @doc """
  Built-in linear printer for `recurse`. Used by `print_all`
  """
  defp print(
         %{
           info: %Info{
             type: t,
             size: s,
             offset: o
           }
         },
         acc
       ) do
    IO.puts("[#{t}] offset=#{o} size=#{s} ")
    acc
  end

  defp print(_box, acc), do: acc
end
