defmodule Streamline.Media.MP4.Box.Chnl do
  @moduledoc """
  `chnl` Channel Layout Box

  This box may appear in an audio sample entry to document the assignment of channels in the audio stream.

  The channelcount field in the AudioSampleEntry must be correct; an AudioSampleEntryV1 is therefore required
  to signal values other than 2. The channel layout can be all or part of a standard layout (from an enumerated
  list), or a custom layout (which also allows a track to contribute part of an overall layout).

  A stream may contain channels, objects, neither, or both. A stream that is neither channel nor object structured
  can implicitly be rendered in a variety of ways.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @channel_structured 1
  @object_structured 2

  @type t :: %Chnl{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: << _ :: 24 >>,
               # `stream_structure` is a field of flags that define whether the stream has
               # channel or object structure (or both, or neither); the following flags are
               # defined, all other values are reserved:
               #    1 the stream carries channels
               #    2 the stream carries objects
               stream_structure: Binary.u8(),
               # definedLayout is a ChannelConfiguration from ISO/IEC 23001‐8;
               defined_layout: Binary.u8(),
               channels: [%{
                 speaker_position: Binary.u8(),
                 azimuth: Binary.i16(),
                 elevation: Binary.i8()
               }],
               omitted_channels_map: Binary.u64(),
               object_count: Binary.u8()
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    stream_structure: 0,
    defined_layout: 0,
    channels: [],
    omitted_channels_map: 0,
    object_count: 0
  ]

  def write(
        %Info{ } = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          structure :: size(8) - unsigned - big - integer,
          rest :: binary
        >>
      ) do
    %Chnl{ version: v, flags: flags, stream_structure: structure }
    |> write_structure(rest)
  end

  @doc """
  `write_structure` matches on the structure of the Box
  and reads appropriate data into %Chn1{}
  """
  def write_structure(
        %Chnl{ stream_structure: @channel_structured } = c,
        << layout :: size(8) - unsigned - big - integer, rest :: binary >>
      ) do
    %Chnl{ c | defined_layout: layout }
    |> write_channel(rest)
  end

  def write_structure(
        %Chnl{ stream_structure: @object_structured } = c,
        << object_count :: size(8) - unsigned - big - integer >>
      ) do
    %Chnl{ c | object_count: object_count }
  end

  def write_structure(%Chnl{ stream_structure: _ } = c, << _ :: binary >>), do: c

  @doc """
  `write_channel` matches on the layout of
  channel-structured Box and reads appropriate
  data into %Chn1{}
  """
  def write_channel(%Chnl{ defined_layout: 0 } = c, << rest :: binary >>) do
    #
  end

  def write_channel(%Chnl{ defined_layout: _ } = c, << omitted_channels :: size(64) - unsigned - big - integer, rest :: binary >>) do
    %Chnl{ c | omitted_channels_map: omitted_channels }
  end
end
