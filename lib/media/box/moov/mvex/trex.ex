defmodule Streamline.Media.MP4.Box.Trex do
  @moduledoc """
  `trex` Track Extends Box

  This sets up default values used by the movie fragments. By setting defaults in this way, space and complexity
  can be saved in each Track Fragment Box.

  The sample flags field in sample fragments (default_sample_flags here and in a Track Fragment Header Box, and
  sample_flags and first_sample_flags in a Track Fragment Run Box) is coded as a 32‐bit value. It has the following
  structure:

      bit(4)   reserved=0;
      unsigned int(2) is_leading;
      unsigned int(2) sample_depends_on;
      unsigned int(2) sample_is_depended_on;
      unsigned int(2) sample_has_redundancy;
      bit(3)   sample_padding_value;
      bit(1)   sample_is_non_sync_sample;
      unsigned int(16)  sample_degradation_priority;

  The `is_leading`, `sample_depends_on`, `sample_is_depended_on`, and `sample_has_redundancy` values are defined as
  documented in the Independent and Disposable Samples Box.

  The flag sample_is_non_sync_sample provides the same information as the sync sample table [8.6.2]. When this value
  is set 0 for a sample, it is the same as if the sample were not in a movie fragment and marked with an entry in the
  sync sample table (or, if all samples are sync samples, the sync sample table were absent).

  The sample_padding_value is defined as for the padding bits table. The sample_degradation_priority is defined as for
  the degradation priority table.
  """
  alias Streamline.Binary
  use Streamline.Media.MP4.Box

  @type t :: %Trex{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: << _ :: 24 >>,
               # track_id identifies the track; this shall be the track ID of
               # a track in the Movie Box
               track_id: Binary.u32(),
               default_sample_description_index: Binary.u32(),
               default_sample_duration: Binary.u32(),
               default_sample_size: Binary.u32(),
               default_sample_flags: Binary.u32(),
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    track_id: 0,
    default_sample_description_index: 0,
    default_sample_duration: 0,
    default_sample_size: 0,
    default_sample_flags: 0,
  ]

  def write(
        %Info{ } = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          track_id:: size(32) - unsigned - big - integer,
          desc_index :: size(32) - unsigned - big - integer,
          duration :: size(32) - unsigned - big - integer,
          size :: size(32) - unsigned - big - integer,
          def_flags :: size(32) - unsigned - big - integer,
        >>
      ) do
    %Trex{
      info: i,
      version: v,
      flags: flags,
      default_sample_description_index: desc_index,
      default_sample_duration: duration,
      default_sample_size: size,
      default_sample_flags: def_flags,
    }
  end
end
