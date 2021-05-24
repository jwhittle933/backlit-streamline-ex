defmodule Streamline.Media.MP4.Box.Elst do
  @moduledoc """
  `elst` BMFF Box (Edit List Box)
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @doc """
  This box contains an explicit timeline map. Each entry defines part of the track time‐line:
  by mapping part of the media time‐line, or by indicating ‘empty’ time, or by defining a ‘dwell’,
  where a single time‐ point in the media is held for a period.
  """
  @type t() :: %Elst{
                 info: Info.t(),
                 # `version` is an integer that specifies the version of this box
                 # (0 or 1 in this specification)
                 version: Binary.u8(),
                 # `flags` is a map of flags
                 flags: <<_ :: 24>>,
                 # entry_count is an integer that gives the number of entries in the following table
                 entry_count: Binary.u32(),
                 entries: [%{
                   # `segment_duration` is an integer that specifies the duration of this edit segment
                   # in units of the timescale in the Movie Header Box (mvhd)
                   segment_duration: Binary.usize(),
                   # `media_time` is an integer containing the starting time within the media of this edit
                   # segment (in media time scale units, in composition time). If this field is set to –1,
                   # it is an empty edit. The last edit in a track shall never be an empty edit. Any difference
                   # between the duration in the Movie Header Box, and the track’s duration is expressed as
                   # an implicit empty edit at the end.
                   media_time: Binary.isize()
                 }],
                 # media_rate specifies the relative rate at which to play the media corresponding to this edit
                 # segment. If this value is 0, then the edit is specifying a ‘dwell’: the media at media‐time
                 # is presented for the segment‐duration. Otherwise this field shall contain the value 1.
                 media_rate: Binary.i16(),
                 media_rate_fraction: Binary.i16(),
                 raw: iodata()
               }

  defstruct [
    :info,
    :version,
    :flags,
    :entry_count,
    :entries,
    :media_rate,
    :media_rate_fraction,
    :raw
  ]

  def write(
        %Info{} = i,
        <<
          version :: 8,
          flags :: bitstring - size(24),
          entry_count :: size(32) - unsigned - big - integer,
          rest :: binary
        >> = data
      ) do
    %Elst{
      info: i,
      version: version,
      flags: flags,
      entry_count: entry_count,
      entries: [],
      raw: data
    }
    |> write_entries(version, rest)
  end

  defp write_entries(
         %Elst{entry_count: ec, entries: entries} = e,
         1 = version,
         <<
           segment_duration :: size(64) - unsigned - big - integer,
           media_time :: size(64) - integer,
           data :: binary
         >>
       ) when length(entries) <= ec do
    {e, data}
    %Elst{e | entries: entries ++ [%{segment_duration: segment_duration, media_time: media_time}]}
    |> write_entries(version, data)
    |> write_media_rate()
  end

  defp write_entries(
         %Elst{entry_count: ec, entries: entries} = e,
         0 = version,
         <<
           segment_duration :: size(32) - unsigned - big - integer,
           media_time :: size(32) - integer,
           data :: binary
         >>
       ) when length(entries) <= ec do
    %Elst{e | entries: entries ++ [%{segment_duration: segment_duration, media_time: media_time}]}
    |> write_entries(version, data)
  end

  defp write_entries(%Elst{} = e, _, <<_data :: binary>>), do: e

  defp write_media_rate({%Elst{} = e, <<media_rate :: size(16) - integer, media_rate_fraction :: size(16) - integer>>}) do
    %Elst{e | media_rate: media_rate, media_rate_fraction: media_rate_fraction}
  end
end
