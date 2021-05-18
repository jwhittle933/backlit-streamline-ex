defmodule Streamline.Media.MP4.Box.Box.Tkhd do
  @moduledoc false
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Info
  alias __MODULE__

  @matrix_size 32 * 9
  @default_matrix {0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000}

  @type t() :: %Tkhd{
                 info: Info.t(),
                 # `version` is an integer that specifies the version of this
                 # box (0 or 1 in this specification)
                 version: Binary.u8(),
                 # `flags` is a 24‐bit integer with flags; the following values
                 # are defined:
                 # `Track_enabled`: Indicates that the track is enabled. Flag
                 # value is 0x000001. A disabled track (the low bit is zero)
                 # is treated as if it were not present.
                 # `Track_in_movie`: Indicates that the track is used in the
                 # presentation. Flag value is 0x000002.
                 # `Track_in_preview`: Indicates that the track is used when
                 # previewing the presentation. Flag value is 0x000004.
                 # `Track_size_is_aspect_ratio`: Indicates that the width and height
                 # fields are not expressed in pixel units. The values have the same
                 # units but these units are not specified. The values are only an
                 # indication of the desired aspect ratio. If the aspect ratios of this
                 # track and other related tracks are not identical, then the respective
                 # positioning of the tracks is undefined, possibly defined by external
                 # contexts. Flag value is 0x000008.
                 flags: <<_ :: 24>>,
                 # creation_time is an integer that declares the creation time of this
                 # track (in seconds since midnight, Jan. 1, 1904, in UTC time).
                 creation_time: Binary.usize(),
                 # modification_time is an integer that declares the most recent time
                 # the track was modified (in seconds since midnight, Jan. 1, 1904,
                 # in UTC time).
                 modification_time: Binary.usize(),
                 # track_ID is an integer that uniquely identifies this track over
                 # the entire life‐time of this presentation. Track IDs are never
                 # re‐used and cannot be zero.
                 track_id: Binary.u32(),
                 # duration is an integer that indicates the duration of this track
                 # (in the timescale indicated in the Movie Header Box). The value
                 # of this field is equal to the sum of the durations of all of the
                 # track’s edits. If there is no edit list, then the duration is the
                 # sum of the sample durations, converted into the timescale in the
                 # Movie Header Box. If the duration of this track cannot be determined
                 # then duration is set to all 1s.
                 duration: Binary.usize(),
                 # layer specifies the front‐to‐back ordering of video tracks; tracks
                 # with lower numbers are closer to the viewer. 0 is the normal value,
                 # and ‐1 would be in front of track 0, and so on.
                 layer: Binary.u16(),
                 # alternate_group is an integer that specifies a group or collection
                 # of tracks. If this field is 0 there is no information on possible
                 # relations to other tracks. If this field is not 0, it should be the
                 # same for tracks that contain alternate data for one another and different
                 # for tracks belonging to different such groups. Only one track within an
                 # alternate group should be played or streamed at any one time, and must
                 # be distinguishable from other tracks in the group via attributes such as
                 # bitrate, codec, language, packet size etc. A group may have only one member.
                 alternate_group: Binary.u16(),
                 # volume is a fixed 8.8 value specifying the track's relative audio volume.
                 # Full volume is 1.0 (0x0100) and is the normal value. Its value is irrelevant
                 # for a purely visual track. Tracks may be composed by combining them according
                 # to their volume, and then using the overall Movie Header Box volume setting;
                 # or more complex audio composition (e.g. MPEG‐4 BIFS) may be used.
                 volume: Binary.u16(),
                 # matrix provides a transformation matrix for the video; (u,v,w) are restricted
                 # here to (0,0,1), hex (0,0,0x40000000).
                 matrix: {
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                 },
                 # width and height fixed‐point 16.16 values are track‐dependent as follows:
                 #
                 # For text and subtitle tracks, they may, depending on the coding
                 # format, describe the suggested size of the rendering area. For
                 # such tracks, the value 0x0 may also be used to indicate that the
                 # data may be rendered at any size, that no preferred size has been
                 # indicated and that the actual size may be determined by the external
                 # context or by reusing the width and height of another track.
                 # For those tracks, the flag track_size_is_aspect_ratio may also be used.
                 #
                 # For non‐visual tracks (e.g. audio), they should be set to zero.
                 #
                 # For all other tracks, they specify the track's visual presentation
                 # size. These need not be the same as the pixel dimensions of the
                 # images, which is documented in the sample description(s); all images
                 # in the sequence are scaled to this size, before any overall transformation
                 # of the track represented by the matrix. The pixel dimensions of the images
                 # are the default values.
                 height: Binary.u32(),
                 width: Binary.u32()
               }

  defstruct [
    :info,
    :version,
    :flags,
    :creation_time,
    :modification_time,
    :track_id,
    :duration,
    :layer,
    :alternate_group,
    :volume,
    :matrix,
    :height,
    :width
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          0 :: 8,
          flags :: bitstring - size(24),
          create :: size(32) - unsigned - big - integer,
          modification :: size(32) - unsigned - big - integer,
          track_id :: size(32) - unsigned - big - integer,
          _ :: size(32) - unsigned - big - integer,
          duration :: size(32) - unsigned - big - integer,
          _ :: size(64) - unsigned - big - integer,
          layer :: size(16) - integer,
          alt_group :: size(16) - integer,
          volume :: size(16) - integer,
          _ :: size(16) - unsigned - big - integer,
          matrix :: bitstring - size(@matrix_size),
          width :: size(32) - unsigned - big - integer,
          height :: size(32) - unsigned - big - integer,
        >> = _data
      ) do
    %Tkhd{
      info: i,
      version: 0,
      flags: flags,
      creation_time: create,
      modification_time: modification,
      track_id: track_id,
      duration: duration,
      layer: layer,
      alternate_group: alt_group,
      volume: volume,
      height: height,
      width: width
    }
    |> write_matrix(matrix)
  end

  def write(
        %Info{} = i,
        <<
          1 :: 8,
          flags :: bitstring - size(24),
          create :: size(64) - unsigned - big - integer,
          modification :: size(64) - unsigned - big - integer,
          track_id :: size(32) - unsigned - big - integer,
          _ :: size(32) - unsigned - big - integer,
          duration :: size(64) - unsigned - big - integer,
          _ :: size(64) - unsigned - big - integer,
          layer :: size(16) - integer,
          alt_group :: size(16) - integer,
          volume :: size(16) - integer,
          _ :: size(16) - unsigned - big - integer,
          matrix :: bitstring - size(@matrix_size),
          width :: size(32) - unsigned - big - integer,
          height :: size(32) - unsigned - big - integer,
        >> = _data
      ) do
    %Tkhd{
      info: i,
      version: 1,
      flags: flags,
      creation_time: create,
      modification_time: modification,
      track_id: track_id,
      duration: duration,
      layer: layer,
      alternate_group: alt_group,
      volume: volume,
      height: height,
      width: width
    }
    |> write_matrix(matrix)
  end

  defp write_matrix(
         %Tkhd{} = t,
         <<
           t0 :: size(32) - unsigned - big - integer,
           t1 :: size(32) - unsigned - big - integer,
           t2 :: size(32) - unsigned - big - integer,
           t3 :: size(32) - unsigned - big - integer,
           t4 :: size(32) - unsigned - big - integer,
           t5 :: size(32) - unsigned - big - integer,
           t6 :: size(32) - unsigned - big - integer,
           t7 :: size(32) - unsigned - big - integer,
           t8 :: size(32) - unsigned - big - integer
         >>
       ) do
    %Tkhd{t | matrix: {t0, t1, t2, t3, t4, t5, t6, t7, t8}}
  end
end
