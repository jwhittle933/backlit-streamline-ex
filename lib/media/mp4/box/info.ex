defmodule Streamline.Media.MP4.Box.Info do
  @moduledoc """
  Info represents an elementary read on the bytestream
  to extract the box size and type
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.BoxType
  alias Streamline.IO.Reader

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

  @spec read(Reader.t()) :: t()
  def read(%Reader{pos: p} = r) do
    %Reader{last_read: lr} = Reader.read(r, 8)

    parse(lr)
  end

  def parse(<<size :: size(32) - unsigned - big - integer, name :: bytes - size(4), _::binary>>) do
    # 32 bit header size
    %Info{size: size, type: BoxType.from(name), header_size: @small_header, extend_to_eof: false}
  end
end
