defmodule Streamline.Media.MP4.Box.Sample.Visual do
  @moduledoc """
  `VisualSampleEntry`

  In video tracks, the frame_count field must be 1 unless the specification for the media
  format explicitly documents this template field and permits larger values. That specification
  must document both how the individual frames of video are found (their size information)
  and their timing established. That timing might be as simple as dividing the sample duration
  by the frame count to establish the frame duration.

  The width and height in the video sample entry document the pixel counts that the codec will
  deliver; this enables the allocation of buffers. Since these are counts they do not take into
  account pixel aspect ratio.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Sample

  @type t :: %Visual {
               sample: Sample.t(),
               predefined: Binary.u16(),
               reserved: Binary.u16(),
               # width and height are the maximum visual width and height of the stream
               # described by this sample description, in pixels
               width: Binary.u16(),
               height: Binary.u16(),
               # `resolution` fields give the resolution of the image in pixels‐per‐inch,
               # as a fixed 16.16 number
               horiz_resolution: Binary.u32(), # 0x00480000
               vert_resolution: Binary.u32(), # 0x00480000
               reserved2: Binary.u32(),
               # `frame_count` indicates how many frames of compressed video are stored in
               # each sample. The default is 1, for one frame per sample; it may be more
               # than 1 for multiple frames per sample
               frame_count: Binary.u16(), # 1
               # `compressor_name` is a name, for informative purposes. It is formatted in a
               # fixed 32‐byte field, with the first byte set to the number of bytes to be
               # displayed, followed by that number of bytes of displayable data, and then
               # padding to complete 32 bytes total (including the size byte). The field
               # may be set to 0.
               compressor_name: String.t(), # 32 bytes
               # `depth` takes one of the following values
               #    0x0018 – images are in color with no alpha
               depth: Binary.u16(), # 0x0018
               predefined3: Binary.i16(),
             }

  defstruct [
    sample: nil,
    predefined: 0,
    reserved: 0,
    width: 0,
    height: 0,
    horiz_resolution: 0x00480000,
    vert_resolution: 0x00480000,
    reserved2: 0,
    frame_count: 0,
    compressor_name: "",
    depth: 0x0018,
    predefined3: 0,
  ]

  def write(<< data :: binary >>) do
    data
    |> Sample.write()
    |> write_self()
  end

  def write_self(
        {
          %Sample{ } = s,
          <<
            pre :: size(16) - unsigned - big - integer,
            r1 :: size(16) - unsigned - big - integer,
            _ :: size(32) - unsigned - big - integer,
            _ :: size(32) - unsigned - big - integer,
            _ :: size(32) - unsigned - big - integer,
            width :: size(16) - unsigned - big - integer,
            height :: size(16) - unsigned - big - integer,
            hor_res :: size(32) - unsigned - big - integer,
            vert_res :: size(32) - unsigned - big - integer,
            r2 :: size(32) - unsigned - big - integer,
            frame_count :: size(16) - unsigned - big - integer,
            compressor :: bytes - size(32),
            depth :: size(16) - unsigned - big - integer,
            pre3 :: size(16),
            rest :: binary
          >>
        }
      ) do
    {
      %Visual{
        sample: s,
        predefined: pre,
        reserved: r1,
        width: width,
        height: height,
        horiz_resolution: hor_res,
        vert_resolution: vert_res,
        reserved2: r2,
        frame_count: frame_count,
        compressor_name: compressor,
        depth: depth,
        predefined3: pre3
      },
      rest
    }
  end

  def write_compressor(%Visual{ } = v, _size, << 0, 0, 0 >>) do
    %Visual{ v | compressor_name: "" }
  end

  def write_compressor(%Visual{ } = v, size, << data :: binary >>) do
    %Visual{ v | compressor_name: binary_part(data, 0, size) }
  end
end
