defmodule Streamline.Media.MP4.Recurse do
  @moduledoc """
  Module `recurse` for recursively reading MP4
  """
  alias Streamline.Result
  alias Streamline.Media.MP4
  alias MP4.Box.Info

  def all_boxes(%MP4{children: []}, _key), do: Result.wrap_err(:no_children)
  def all_boxes(%MP4{children: c}, _key) do
    #
  end

  def rprint(%{info: i, children: c}) do
    print(i)
    rprint(c)
  end

  def rprint(%{children: c} = child) do
    print(%Info{type: "mp4", size: 0, offset: 0})
    rprint(c)
  end

  def rprint([{_, %{info: i, children: c}} | tail]) do
    print(i)
    rprint(c)
    rprint(tail)
  end

  def rprint([{_, %{info: i}} | tail]) do
    print(i)
    rprint(tail)
  end

  def rprint([]), do: :ok

  def rprint(nil) do
    print(%Info{type: "unknown", size: "unknown", offset: "unknown"})
  end

  defp print(%Info{type: t, size: s, offset: o}) do
    IO.puts("[#{t}] offset=#{o} size=#{s} ")
  end

  defp print(nil), do: :ok
end
