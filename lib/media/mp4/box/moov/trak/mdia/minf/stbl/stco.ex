defmodule Streamline.Media.MP4.Box.Stco do
  @moduledoc """
  `stco` Sample Table Chunk Offset Box

  The chunk offset table gives the index of each chunk into the containing file. There are two variants,
  permitting the use of 32‐bit or 64‐bit offsets. The latter is useful when managing very large presentations.
  At most one of these variants will occur in any single instance of a sample table.

  Offsets are file offsets, not the offset into any box within the file (e.g. Media Data Box). This permits
  referring to media data in files without any box structure. It does also mean that care must be taken when
  constructing a self‐contained ISO file with its metadata (Movie Box) at the front, as the size of the Movie
  Box will affect the chunk offsets to the media data.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Stco {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               entries: [%{
                 # `chunk_offset` gives the numbers of the samples that are sync samples in the stream.
                 chunk_offset: Binary.u32(),
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
    %Stco{info: i, version: v, flags: flags, entry_count: entry_count}
    |> write_samples(entries)
  end

  defp write_samples(
         %Stco{entry_count: sc, entries: entries} = s,
         <<chunk_offset :: size(32) - unsigned - big - integer, rest :: binary>>
       ) when length(entries) < sc do
    %Stco{s | entries: entries ++ [%{chunk_offset: chunk_offset}]}
    |> write_samples(rest)
  end

  defp write_samples(%Stco{} = s, _), do: s
end
