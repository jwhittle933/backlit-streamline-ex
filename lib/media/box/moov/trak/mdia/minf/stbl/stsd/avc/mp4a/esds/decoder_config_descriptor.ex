defmodule Streamline.Media.MP4.Box.Esds.DecoderConfigDescriptor do
  @moduledoc """
  `esds` Decoder Config Descriptor
  """
  alias __MODULE__
  alias Streamline.Binary

  @type t() :: %DecoderConfigDescriptor{
                 object_type_indication: Binary.u8(),
                 stream_type: Binary.i8(),
                 up_stream: << _ :: 1 >>,
                 reserved: << _ :: 1 >>,
                 buffer_size_db: Binary.u32(),
                 max_bitrate: Binary.u32(),
                 avg_bitrate: Binary.u32(),
               }

  defstruct [
    object_type_indication: 0,
    stream_type: 0,
    up_stream: 0,
    reserved: 0,
    buffer_size_db: 0,
    max_bitrate: 0,
    avg_bitrate: 0,
  ]

  @oti [
    # Forbidden
    0x00,
    # Systems ISO/IEC 14496-1
    0x01,
    # Systems ISO/IEC 14496-1
    0x02,
    # reserved for ISO use
    0x03 - 0x1F,
    # Visual ISO/IEC 14496-2
    0x20,
    # reserved for ISO use
    0x21-0x3F,
  ]

  def write(
        <<
          oti :: size(8) - unsigned - big - integer,
          stream_type :: size(6),
          up_stream :: 1,
          _ :: 1,
          buffer_size :: size(24) - unsigned - big - integer,
          max_br :: size(32) - unsigned - big - integer,
          avg_br :: size(32) - unsigned - big - integer,
          rest :: binary,
        >>
      ) do
    {
      %DecoderConfigDescriptor{
        object_type_indication: oti,
        stream_type: stream_type,
        up_stream: Binary.bool(up_stream),
        buffer_size_db: buffer_size,
        max_bitrate: max_br,
        avg_bitrate: avg_br,
      },
      rest
    }
  end
end
