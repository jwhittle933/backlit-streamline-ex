defmodule Streamline.Media.MP4.Box.Stts do
  @moduledoc """
  `stts` Time To Sample Box

  This box contains a compact version of a table that number. Other tables give sample sizes and pointers,
  from the sample number. Each entry in the table gives the number of consecutive samples with the same
  time delta, and the delta of those samples. By adding the deltas a complete time‐to‐sample map may be built.

  The Decoding Time to Sample Box contains decode time delta's: DT(n+1) = DT(n) + STTS(n) where STTS(n) is
  the (uncompressed) table entry for sample n.

  The sample entries are ordered by decoding time stamps; therefore the deltas are all non‐negative.

  The DT axis has a zero origin; DT(i) = SUM(for j=0 to i‐1 of delta(j)), and the sum of all deltas gives
  the length of the media in the track (not mapped to the overall timescale, and not considering any edit list).

  The Edit List Box provides the initial CT value if it is non‐empty (non‐zero).
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Stts {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               entries: [%{
                 # `sample_count` is an integer that counts the number of consecutive
                 # samples that have the given duration.
                 sample_count: Binary.u32(),
                 # `sample_delta` is an integer that gives the delta of these samples
                 # in the time‐scale of the media.
                 sample_delta: Binary.u32()
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
    %Stts{info: i, version: v, flags: flags, entry_count: entry_count}
    |> write_entries(entries)
  end

  defp write_entries(
         %Stts{entry_count: ec, entries: entries} = s,
         <<
           sample_count :: size(32) - unsigned - big - integer,
           sample_delta :: size(32) - unsigned - big - integer,
           rest :: binary
         >>
       ) when length(entries) < ec do
    %Stts{s | entries: entries ++ [%{sample_count: sample_count, sample_delta: sample_delta}]}
    |> write_entries(rest)
  end

  defp write_entries(%Stts{} = s, _), do: s
end
