defmodule Streamline.Media.MP4.Box.Info do
  @moduledoc """
  Info represents an elementary read on the bytestream
  to extract the box size and type
  """
  alias Streamline.Media.MP4.Box
  alias Streamline.Media.MP4.Box.BoxType
  alias __MODULE__

  @behavior Streamline.Media.MP4.Box.Written
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

  def write(%Info{}, <<0x00 :: size(32), size :: bytes - size(4), name :: bytes - size(4), _ :: bytes>>) do
    # 8 byte size header
    %Info{}
  end

  def write(%Info{}, <<size :: bytes - size(4), name :: bytes - size(4), _ :: binary>>) do
    # 4 byte size header
    %Info{}
  end
end
