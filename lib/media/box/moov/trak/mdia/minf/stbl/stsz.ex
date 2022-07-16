defmodule Streamline.Media.MP4.Box.Stsz do
  @moduledoc """
  `stss` Sample Size Box

  This box contains the sample count and a table giving the size in bytes of each sample.
  This allows the media data itself to be unframed. The total number of samples in the
  media is always indicated in the sample count.

  There are two variants of the sample size box. The first variant has a fixed size 32‐bit
  field for representing the sample sizes; it permits defining a constant size for all samples
  in a track. The second variant permits smaller size fields, to save space when the sizes
  are varying but small. One of these boxes must be present; the first version is preferred
  for maximum compatibility.
      NOTE: A sample size of zero is not prohibited in general,
      but it must be valid and defined for the coding system,
      as defined by the sample entry, that the sample belongs to.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Stsz {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               sample_size: Binary.u32(),
               sample_count: Binary.u32(),
               samples: [%{
                 # `sample_number` gives the numbers of the samples that are sync samples in the stream.
                 entry_size: Binary.u32(),
               }],
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    sample_size: 0,
    sample_count: 0,
    samples: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          sample_size :: size(32) - unsigned - big - integer,
          sample_count :: size(32) - unsigned - big - integer,
          samples :: binary
        >>
      ) do
    %Stsz{info: i, version: v, flags: flags, sample_size: sample_size, sample_count: sample_count}
    |> write_samples(samples)
  end

  defp write_samples(%Stsz{} = s, ""), do: s
  defp write_samples(%Stsz{sample_size: ss} = s, <<data :: binary>>) when ss > 0, do: s

  defp write_samples(
         %Stsz{sample_count: sc, samples: samples} = s,
         <<entry_size :: size(32) - unsigned - big - integer, rest :: binary>>
       ) when length(samples) < sc do
    %Stsz{s | samples: samples ++ [%{entry_size: entry_size}]}
    |> write_samples(rest)
  end

  defp write_samples(%Stsz{} = s, _), do: s
end
