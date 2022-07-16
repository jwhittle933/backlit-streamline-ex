defmodule Streamline.Media.MP4.Box.Stss do
  @moduledoc """
  `stss` Sync Sample Box

  This box provides a compact marking of the sync samples within the stream. The table is arranged
  in strictly increasing order of sample number.

  If the sync sample box is not present, every sample is a sync sample.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Stss {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               entries: [%{
                 # `sample_number` gives the numbers of the samples that are sync samples in the stream.
                 sample_number: Binary.u32(),
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
    %Stss{info: i, version: v, flags: flags, entry_count: entry_count}
    |> write_samples(entries)
  end

  defp write_samples(
         %Stss{entry_count: ec, entries: entries} = s,
         <<
           sample_number :: size(32) - unsigned - big - integer,
           rest :: binary
         >>
       ) when length(entries) < ec do
    %Stss{s | entries: entries ++ [%{sample_number: sample_number}]}
    |> write_samples(rest)
  end

  defp write_samples(%Stss{} = s, _), do: s
end
