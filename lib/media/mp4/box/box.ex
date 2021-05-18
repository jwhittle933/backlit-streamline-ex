defmodule Streamline.Media.MP4.Box do
  @moduledoc """
  Box module parses box data and distributes it to the
  appropriate module for writing
  """
  alias Streamline.Media.MP4.Box.{Info, BoxType}
  alias Streamline.IO.Reader
  alias __MODULE__

  @behaviour Streamline.Media.MP4.Box.Boxed

  defprotocol Typeable do
    @spec type(t) :: String.t()
    def type(box)
  end

  defprotocol Writeable do
    @spec write(t, iodata()) :: t
    def write(box, src)
  end

  defprotocol Infoable do
    @spec info(t) :: Info.t()
    def info(box)
  end

  ####### Behaviors ######
  # Each behavior below should operate on a box
  # that implements the protocols above
  def type(box) do
    Box.Typeable.type(box)
  end

  def write(box, iodata) do
    Box.Writeable.write(box, iodata)
  end

  def stringify(box) do
    String.Chars.to_string(box)
  end

  def info(box) do
    Box.Infoable.info(box)
  end

  @spec box_module(String.t()) :: module()
  def box_module(box_name) do
    box_name
    |> String.trim()
    |> :string.titlecase()
    |> (&:"Elixir.Streamline.Media.MP4.Box.#{&1}").()
  end

  @spec write_box(String.t(), iodata()) :: module()
  def write_box(%Info{type: t} = i, data) do
    t
    |> box_module()
    |> apply(:write, [i, data])
  end

  ######## EXPERIMENTAL (Successful) ########
  @spec read(iodata, [term()]) :: [term()]
  def read(data, acc \\ [], offset \\ 0)
  def read(
        <<
          size :: size(32) - unsigned - big - integer,
          name :: bytes - size(4),
          data :: binary
        >>,
        acc,
        offset
      ) do
    {box, rest} = box_from(data, size - 8)

    name
    |> BoxType.from()
    |> (&%Info{size: size, type: &1, offset: offset}).()
    |> write_box(box)
    |> (&read(rest, Keyword.put(acc, :"#{name}", &1), size + offset)).()
  end

  def read("", acc, _offset), do: acc

  defp box_from(<<data :: binary>>, n_bytes) do
    <<box :: bytes - size(n_bytes), rest :: binary>> = data
    {box, rest}
  end
end
