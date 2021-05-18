defmodule Streamline.Media.MP4.Box.Mdhd do
  @moduledoc """
  `mdia` BMFF Box (Media Declaration Container)
  """
  use Bitwise
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Mdhd{
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
               pad: boolean,
               language: {
                 <<_ :: 5>>,
                 <<_ :: 5>>,
                 <<_ :: 5>>
               },
               predefined: Binary.u16()
             }

  defstruct [
    :info,
    :version,
    :flags,
    :creation_time,
    :modification_time,
    :timescale,
    :duration,
    :pad,
    :language,
    :predefined
  ]

  def write(
        %Info{} = i,
        <<
          0 :: 8,
          flags :: bitstring - size(24),
          create :: size(32) - unsigned - big - integer,
          modification :: size(32) - unsigned - big - integer,
          timescale :: size(32) - unsigned - big - integer,
          duration :: size(32) - unsigned - big - integer,
          pad :: size(1),
          language :: size(15) - integer,
          predefined :: size(16) - unsigned - big - integer
        >>
      ) do
    %Mdhd{
      info: i,
      version: 0,
      flags: flags,
      creation_time: create,
      modification_time: modification,
      timescale: timescale,
      duration: duration,
      pad: pad,
      language: language_code(language),
      predefined: predefined
    }
  end

  def write(
        %Info{} = i,
        <<
          1 :: 8,
          flags :: bitstring - size(24),
          create :: size(64) - unsigned - big - integer,
          modification :: size(64) - unsigned - big - integer,
          timescale :: size(32) - unsigned - big - integer,
          duration :: size(64) - unsigned - big - integer,
          pad :: size(1),
          language :: size(15) - unsigned - big - integer,
          predefined :: size(16) - unsigned - big - integer
        >>
      ) do
    %Mdhd{
      info: i,
      version: 0,
      flags: flags,
      creation_time: create,
      modification_time: modification,
      timescale: timescale,
      duration: duration,
      pad: pad,
      language: language_code(language),
      predefined: predefined
    }
  end

  @packed 0x60
  defp language_code(lang) do
    {
      bsr(band(lang, 0x7c00), 10) + @packed,
      bsr(band(lang, 0x03E0), 5) + @packed,
      band(lang, 0x001F) + @packed
    }
  end
end
