defmodule Streamline.Media.MP4.Box.Info do
  @moduledoc """
  Info represents an elementary read on the byte stream
  to extract the box size and type
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.IO.Reader
  alias Streamline.Media.MP4.Box.BoxType

  @small_header 8
  @large_header 16

  @type t() :: %Info {
                 offset: integer,
                 size: integer,
                 type: BoxType.t(),
                 header_size: integer,
                 extend_to_eof: boolean
               }

  defstruct [:offset, :size, :type, :header_size, :extend_to_eof]

  @spec from(BoxType.t(), Binary.u32(), Binary.u32()) :: t()
  def from(type, size, offset) do
    %Info{type: type, size: size, offset: offset}
  end

  @spec read(Reader.t()) :: t()
  def read(%Reader{} = r) do
    r
    |> Reader.read(8)
    |> (&parse(&1.last_read)).()
  end

  @spec parse(iodata() | nil | IO.nodata()) :: t()
  def parse(<<size :: size(32) - unsigned - big - integer, name :: bytes - size(4), _::binary>>) do
    # 32 bit header size
    %Info{size: size, type: BoxType.from(name), header_size: @small_header, extend_to_eof: false}
  end

  def parse(nil) do
    #
  end

  def parse(:eof) do
    #
  end
end
