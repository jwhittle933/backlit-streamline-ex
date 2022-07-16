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
                 extend_to_eof: boolean,
                 context: %{
                   any() => any()
                 }
               }

  defstruct [
    offset: nil,
    size: nil,
    type: "unknown",
    header_size: nil,
    extend_to_eof: false,
    context: %{ }
  ]

  @spec from(BoxType.t(), Binary.u32(), Binary.u32(), %{}) :: t()
  def from(type, size, offset, context \\ %{})
  def from(type, size, offset, %{}) do
    %Info{ type: type, size: size, offset: offset }
  end

  def from(type, size, offset, context) do
    %Info{ type: type, size: size, offset: offset, context: context }
  end

  @spec read(Reader.t()) :: t()
  def read(%Reader{ } = r) do
    r
    |> Reader.read(8)
    |> Reader.last()
    |> parse()
  end

  def add_context(%Info{ context: c } = i, context) when is_map(context) do
    %Info{
      i |
      context: Map.merge(c, context)
    }
  end

  def add_context(%Info{ context: c } = i, key, value) do
    %Info{
      i |
      context: %{
        c |
        key => value
      }
    }
  end

  @spec parse(iodata() | nil | IO.nodata()) :: t()
  def parse(<< size :: size(32) - unsigned - big - integer, name :: bytes - size(4), _ :: binary >>) do
    # 32 bit header size
    %Info{ size: size, type: BoxType.from(name), header_size: @small_header, extend_to_eof: false }
  end

  def parse(nil) do
    #
  end

  def parse(:eof) do
    #
  end
end
