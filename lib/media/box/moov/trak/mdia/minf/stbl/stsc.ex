defmodule Streamline.Media.MP4.Box.Stsc do
  @moduledoc """
  `stsc` Sample to Chunk, partial data-offset information

  Samples within the media data are grouped into chunks. Chunks can be of different sizes,
  and the samples within a chunk can have different sizes. This table can be used to find
  the chunk that contains a sample, its position, and the associated sample description.

  The table is compactly coded. Each entry gives the index of the first chunk of a run of
  chunks with the same characteristics. By subtracting one entry here from the previous one,
  you can compute how many chunks are in this run. You can convert this to a sample count
  by multiplying by the appropriate samples‐per‐chunk.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Stsc {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               entries: [%{
                 first_chunk: Binary.u32(),
                 samples_per_chunk: Binary.u32(),
                 sample_description_index: Binary.u32()
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
    %Stsc{info: i, version: v, flags: flags, entry_count: entry_count}
    |> write_entries(entries)
  end

  defp write_entries(
         %Stsc{entry_count: ec, entries: entries} = s,
         <<
           first_chunk :: size(32) - unsigned - big - integer,
           samples_pc :: size(32) - unsigned - big - integer,
           sample_desc_index :: size(32) - unsigned - big - integer,
           rest :: binary
         >>
       ) when length(entries) < ec do
    %Stsc{
      s |
      entries: entries ++ [
        %{
          first_chunk: first_chunk,
          samples_per_chunk: samples_pc,
          sample_description_index: sample_desc_index
        }
      ]
    }
    |> write_entries(rest)
  end

  defp write_entries(%Stsc{} = s, _), do: s
end
