defmodule Streamline.Media.MP4.Box.Mvhd do
  @moduledoc false
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Info
  alias __MODULE__

  @default_rate 0x00010000
  @default_volume 0x0100

  @matrix_size 32 * 9
  @default_matrix {0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000}

  @predefined_size 32 * 6

  @doc """
  `mvhd` box: ISO/IEC 14496-12:2015(E), 8.2.2.2, pg. 36
  """
  @type children :: list(any())
  @type t() :: %Mvhd{
                 info: Info.t(),
                 # `version` is an integer that specifies the version of this box
                 # (0 or 1 in this specification)
                 version: Binary.u8(),
                 # `flags` is a map of flags
                 flags: <<_ :: 24>>,
                 # `creation_time` is an integer that declares the creation time of
                 # the presentation (in seconds since midnight, Jan. 1, 1904, in UTC time)
                 creation_time: Binary.usize(),
                 # `modification_time` is an integer that declares the most recent time
                 # the presentation was modified (in seconds since midnight, Jan. 1, 1904, in UTC time)
                 modification_time: Binary.usize(),
                 # `timescale` is an integer that specifies the time‐scale for the entire
                 # presentation; this is the number of time units that pass in one second.
                 # For example, a time coordinate system that measures time in sixtieths
                 # of a second has a time scale of 60.
                 timescale: Binary.u32(),
                 # `duration` is an integer that declares length of the presentation
                 # (in the indicated timescale). This property is derived from the
                 # presentation’s tracks: the value of this field corresponds# to the
                 # duration of the longest track in the presentation. If the duration
                 # cannot be determined then duration is set to all 1s.
                 duration: Binary.u64(),
                 # `rate` is a fixed point 16.16 number that indicates the preferred rate
                 # to play the presentation; 1.0 (0x00010000) is normal forward playback
                 rate: Binary.u32(),
                 # `volume` is a fixed point 8.8 number that indicates the preferred playback
                 # volume. 1.0 (0x0100) is full volume.
                 volume: Binary.u16(),
                 reserved: Binary.u16(),
                 reserved2: {Binary.u32(), Binary.u32()},
                 # `matrix` provides a transformation matrix for the video; (u,v,w) are
                 # restricted here to (0,0,1), hex values (0,0,0x40000000).
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
                 predefined: <<_ :: 192>>,
                 # `next_track_id` is a non‐zero integer that indicates a value to use for
                 # the track ID of the next track to be added to this presentation. Zero
                 # is not a valid track ID value. The value of next_track_ID shall be larger
                 # than the largest track‐ID in use. If this value is equal to all 1s
                 # (32‐bit maxint), and a new media track is to be added, then a search must
                 # be made in the file for an unused track identifier.
                 next_track_id: Binary.u32(),
                 raw: iodata()
               }

  defstruct [
    :info,
    :version,
    :flags,
    :creation_time,
    :modification_time,
    :timescale,
    :duration,
    :rate,
    :volume,
    :reserved,
    :reserved2,
    :matrix,
    :predefined,
    :next_track_id,
    :raw
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          0 :: 8,
          flags :: bitstring - size(24),
          create :: size(32) - unsigned - big - integer,
          modification :: size(32) - unsigned - big - integer,
          timescale :: size(32) - unsigned - big - integer,
          duration :: size(32) - unsigned - big - integer,
          rate :: size(32) - integer,
          volume :: size(16) - integer,
          reserved :: size(16) - integer,
          reserved2 :: size(64) - integer,
          matrix :: bitstring - size(@matrix_size),
          predefined :: size(@predefined_size) - integer,
          next :: size(32) - unsigned - big - integer,
        >> = data
      ) do
    %Mvhd{
      info: i,
      version: 0,
      flags: flags,
      creation_time: create,
      modification_time: modification,
      timescale: timescale,
      duration: duration,
      rate: rate,
      volume: volume,
      reserved: reserved,
      reserved2: reserved2,
      predefined: predefined,
      next_track_id: next,
      raw: data
    }
    |> write_matrix(matrix)
  end

  def write(
        %Info{} = i,
        <<
          1 :: 8,
          flags :: bitstring - size(24),
          create :: size(64) - unsigned - big - integer,
          mod :: size(64) - unsigned - big - integer,
          timescale :: size(32) - unsigned - big - integer,
          duration :: size(64) - unsigned - big - integer,
          rate :: size(32) - unsigned - big - integer,
          volume :: size(16) - unsigned - big - integer,
          _ :: size(16) - unsigned - big - integer,
          _ :: size(64),
          matrix :: bitstring - size(@matrix_size),
          predefined :: size(@predefined_size) - integer,
          next :: size(32) - unsigned - big - integer,
        >> = data
      ) do
    %Mvhd{
      info: i,
      version: 1,
      flags: flags,
      creation_time: create,
      modification_time: mod,
      timescale: timescale,
      duration: duration,
      rate: rate,
      volume: volume,
      predefined: predefined,
      next_track_id: next,
      raw: data
    }
    |> write_matrix(matrix)
  end

  defp write_matrix(
         %Mvhd{} = m,
         <<
           m0 :: size(32) - unsigned - big - integer,
           m1 :: size(32) - unsigned - big - integer,
           m2 :: size(32) - unsigned - big - integer,
           m3 :: size(32) - unsigned - big - integer,
           m4 :: size(32) - unsigned - big - integer,
           m5 :: size(32) - unsigned - big - integer,
           m6 :: size(32) - unsigned - big - integer,
           m7 :: size(32) - unsigned - big - integer,
           m8 :: size(32) - unsigned - big - integer
         >>
       ) do
    %Mvhd{m | matrix: {m0, m1, m2, m3, m4, m5, m6, m7, m8}}
  end

  defp write_predefined(
         %Mvhd{} = m,
         <<
           p0 :: size(32) - big - integer,
           p1 :: size(32) - big - integer,
           p2 :: size(32) - big - integer,
           p3 :: size(32) - big - integer,
           p4 :: size(32) - big - integer,
           p5 :: size(32) - big - integer
         >>
       ) do
    %Mvhd{m | predefined: {p0, p1, p2, p3, p4, p5}}
  end
end
