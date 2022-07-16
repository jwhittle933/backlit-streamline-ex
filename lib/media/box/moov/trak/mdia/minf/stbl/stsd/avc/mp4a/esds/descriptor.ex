defmodule Streamline.Media.MP4.Box.Esds.Descriptor do
  @moduledoc """
  `esds` Descriptor
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Esds.{ ESDescriptor, DecoderConfigDescriptor }

  @es_descriptor_tag 0x03

  @type t :: %Descriptor{
               tag: Binary.i8(),
               size: Binary.u32(),
               es_descriptor: ESDescriptor.t(),
               data: iodata()
             }

  defstruct [
    tag: @es_descriptor_tag,
    size: 0,
    es_descriptor: nil,
    data: nil
  ]

  def write(<< data :: binary >>) do
    write_descriptors([], data)
  end

  def write_descriptors(desc, << >>), do: desc
  def write_descriptors(
        desc,
        <<
          tag :: size(8),
          size :: size(32) - unsigned - big - integer,
          rest :: binary,
        >>
      ) do
    { es_desc, rest } = ESDescriptor.write(rest)

    desc ++ [%Descriptor{ tag: tag, size: size, es_descriptor: es_desc, data: rest }]
    |> write_descriptors(rest)
  end
end
