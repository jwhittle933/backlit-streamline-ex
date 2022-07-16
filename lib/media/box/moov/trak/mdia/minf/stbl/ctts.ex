defmodule Streamline.Media.MP4.Box.Ctts do
  @moduledoc """
  `ctts` Composition Offset Box

  This box provides the offset between decoding time and composition time. In version 0 of
  this box the decoding time must be less than the composition time, and the offsets are
  expressed as unsigned numbers such that CT(n) = DT(n) + CTTS(n) where CTTS(n) is the
  (uncompressed) table entry for sample n. In version 1 of this box, the composition
  timeline and the decoding timeline are still derived from each other, but the offsets
  are signed. It is recommended that for the computed composition timestamps, there is
  exactly one with the value 0 (zero).

  For either version of the box, each sample must have a unique composition timestamp
  value, that is, the timestamp for two samples shall never be the same.

  It may be true that there is no frame to compose at time 0; the handling of this is
  unspecified (systems might display the first frame for longer, or a suitable fill colour).

  When version 1 of this box is used, the CompositionToDecodeBox may also be present in the
  sample table to relate the composition and decoding timelines. When backwards‐compatibility
  or compatibility with an unknown set of readers is desired, version 0 of this box should
  be used when possible. In either version of this box, but particularly under version 0,
  if it is desired that the media start at track time 0, and the first media sample does
  not have a composition time of 0, an edit list may be used to ‘shift’ the media to time 0.

  The composition time to sample table is optional and must only be present if DT and CT
  differ for any samples.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Ctts {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               entries: [%{
                 # `sample_count` is an integer that counts the number of consecutive samples
                 # that have the given offset
                 sample_count: Binary.u32(),
                 # sample_offset is an integer that gives the offset between CT and DT, such that
                 # CT(n) = DT(n) + CTTS(n).
                 sample_offset: Binary.u32() | Binary.i32()
               }],
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    entry_count: 0,
    entries: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          entry_count :: size(32) - unsigned - big - integer,
          entries :: binary
        >>
      ) do
    %Ctts{info: i, version: v, flags: flags, entry_count: entry_count}
    |> write_samples(entries)
  end

  defp write_samples(
         %Ctts{version: 0, entry_count: ec, entries: entries} = s,
         <<
           sample_count :: size(32) - unsigned - big - integer,
           sample_offset :: size(32) - unsigned - big - integer,
           rest :: binary
         >>
       ) when length(entries) < ec do
    %Ctts{s | entries: entries ++ [%{sample_count: sample_count, sample_offset: sample_offset}]}
    |> write_samples(rest)
  end

  defp write_samples(
         %Ctts{version: 1, entry_count: ec, entries: entries} = s,
         <<
           sample_number :: size(32) - unsigned - big - integer,
           sample_offset :: size(32) - big - integer,
           rest :: binary
         >>
       ) when length(entries) < ec do
    %Ctts{s | entries: entries ++ [%{sample_number: sample_number, sample_offset: sample_offset}]}
    |> write_samples(rest)
  end

  defp write_samples(%Ctts{} = s, _), do: s
end
