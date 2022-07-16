defmodule Streamline.Media.MP4.Box.Sbgp do
  @moduledoc """
  `sbgp` Sample to Group

  This table can be used to find the group that a sample belongs to and the associated description
  of that sample group. The table is compactly coded with each entry giving the index of the first
  sample of a run of samples with the same sample group descriptor. The sample group description ID
  is an index that refers to a SampleGroupDescription box, which contains entries describing the
  characteristics of each sample group.

  There may be multiple instances of this box if there is more than one sample grouping for the samples
  in a track. Each instance of the SampleToGroup box has a type code that distinguishes different sample
  groupings. There shall be at most one instance of this box with a particular grouping type in a Sample
  Table Box or Track Fragment Box. The associated SampleGroupDescription shall indicate the same value
  for the grouping type.

  Version 1 of this box should only be used if a grouping type parameter is needed.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t() :: %Sbgp{
                 info: Info.t(),
                 # `version` is an integer that specifies the version of this box
                 # (0 or 1 in this specification)
                 version: Binary.u8(),
                 # `flags` is a map of flags
                 flags: <<_ :: 24>>,
                 # `grouping_type` is an integer that identifies the SampleToGroup box
                 # that is associated with this sample group description. If
                 # grouping_type_parameter is not defined for a given grouping_type,
                 # then there shall be only one occurrence of this box with this grouping_type.
                 grouping_type: String.t(),
                 grouping_type_parameter: Binary.u32(),
                 entry_count: Binary.u32(),
                 entries: [%{
                   sample_count: Binary.u32(),
                   group_description_index: Binary.u32()
                 }]
               }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    grouping_type: "",
    grouping_type_parameter: 0,
    entry_count: 0,
    entries: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          0 :: 8,
          flags :: bitstring - size(24),
          gt :: bytes - size(4),
          count :: size(32) - unsigned - big - integer,
          entries :: binary,
        >>
      ) do
    %Sbgp{
      info: i,
      version: 0,
      flags: flags,
      grouping_type: gt,
      entry_count: count,
    }
    |> write_entries(entries)
  end

  def write(
        %Info{} = i,
        <<
          1 :: 8,
          flags :: bitstring - size(24),
          gt :: bytes - size(4),
          gt_param :: bytes - size(4),
          count :: size(32) - unsigned - big - integer,
          entries :: binary,
        >>
      ) do
    %Sbgp{
      info: i,
      version: 1,
      flags: flags,
      grouping_type: gt,
      grouping_type_parameter: gt_param,
      entry_count: count,
    }
    |> write_entries(entries)
  end

  defp write_entries(
         %Sbgp{entry_count: ec, entries: entries} = s,
         <<
           sample_count :: size(32) - unsigned - big - integer,
           gdi :: size(32) - unsigned - big - integer,
           _ :: binary
         >>
       ) when length(entries) < ec do
    %Sbgp{s | entries: entries ++ [%{sample_count: sample_count, group_description_index: gdi}]}
  end

  defp write_entries(%Sbgp{} = s, _), do: s
end
