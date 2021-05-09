defmodule Streamline.Media.MP4.Box.Info do
  @moduledoc """
  Info represents an elementary read on the bytestream
  to extract the box size and type
  """
  alias Streamline.Media.MP4.Box
  alias Streamline.Media.MP4.Box.BoxType
  alias __MODULE__

  @type t() :: %__MODULE__ {
                  offset: integer,
                  size: integer,
                  type: BoxType.t(),
                  header_size: integer,
                  extend_to_eof: boolean
               }

  defstruct [:offset, :size, :type, :header_size, :extend_to_eof]

  defimpl Box.Write, for: __MODULE__ do
    @doc """
    write parses boxes with 4 byte sizes
    """
    def write(<<size::4, name::4, rest::binary>>) do
      {%Info{}, rest}
    end

    @doc """
    write parses boxes with 8 byte sizes
    """
    def write(<<size::8, name::4, rest::binary>>) do
      {%Info{}, rest}
    end
  end
end
