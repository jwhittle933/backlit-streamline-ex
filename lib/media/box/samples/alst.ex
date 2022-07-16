defmodule Streamline.Media.MP4.Box.Alst do
  @moduledoc """
  `alst` Alternative Startup Entry

  An alternative startup sequence contains a subset of samples of a track within a certain period
  starting from a sync sample or a sample marked by 'rap ' sample grouping, which are collectively
  referred to as the initial sample below. By decoding this subset of samples, the rendering of the
  samples can be started earlier than in the case when all samples are decoded.

  An 'alst' sample group description entry indicates the number of samples in any of the respective
  alternative startup sequences, after which all samples should be processed.

  Either version 0 or version 1 of the Sample to Group Box may be used with the alternative startup
  sequence sample grouping. If version 1 of the Sample to Group Box is used, grouping_type_parameter
  has no defined semantics but the same algorithm to derive alternative startup sequences should be
  used consistently for a particular value of grouping_type_parameter.

  A player utilizing alternative startup sequences could operate as follows. First, an initial sync
  sample from which to start decoding is identified by using the Sync Sample Box, the sample_is_non_sync_sample
  flag for samples enclosed in track fragments, or the 'rap ' sample grouping. Then, if the initial
  sync sample is associated to a sample group description entry of type 'alst' where roll_count is
  greater than 0, the player can use the alternative startup sequence. The player then decodes only
  those samples that are mapped to the alternative startup sequence until the number of samples that
  have been decoded is equal to roll_count. After that, all samples are decoded.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Alst{
               info: Info.t(),
               # `roll_count` indicates the number of samples in the alternative startup sequence.
               # If `roll_count` == 0, the associated sample does not belong to any alternative
               # startup sequence and the semantics of the `first_output_sample` are unspecified.
               roll_count: Binary.u16(),
               # `first_output_sample` indicates the index of the first sample intended for output
               # among the samples in the alternative startup sequence. The index of the sync initial
               # sample starting the alternative startup sequence is 1, and the index is incremented
               # by 1, in decoding order, per each sample in the alternative startup sequence.
               first_output_sample: Binary.u16(),
               # `sample_offset[i]` indicates the decoding time delta of the i-th sample in the alternative
               # startup sequence relative to the regular decoding time of the sample derived from the
               # Decoding Time to Sample Box or the Track Fragment Header box.
               sample_offsets: [Binary.u32()],
               # `num_output_samples[j]` and `num_total_samples[j]` indicate the sample output rate within
               # the alternative startup sequence. The alternative startup sequence is divided into `k`
               # consecutive pieces, where each piece has a constant sample output rate which is unequal
               # to that of the adjacent pieces. The first piece starts from the sample indicated by
               # `first_output_sample`. `num_output_samples[i]` indicates the number of the output samples
               # of the j-th piece of the alternative startup sequence. `num_total_samples[j]` indicates
               # the total number of samples, including those that are not in the alternative startup
               # sequence, from the first sample in the j-th piece that is output to the earlier one
               # (in composition order) of the sample that ends the alternative startup sequence and the
               # sample that immediately precedes the first output sample of the (j+1)th piece.
               samples: [%{
                 num_output_samples: Binary.u16(),
                 num_total_samples: Binary.u16(),
               }]
             }

  defstruct [
    info: nil,
    roll_count: 0,
    first_output_sample: 0,
    sample_offsets: [],
    samples: []
  ]

  # TODO: Finish parsing
  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          roll_count :: size(16) - unsigned - big - integer,
          fos :: size(32) - unsigned - big - integer,
          samples :: binary
        >>
      ) do
    %Alst{
      info: i,
      roll_count: roll_count,
      first_output_sample: fos
    }
  end
end
