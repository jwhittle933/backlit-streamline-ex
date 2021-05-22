defmodule Streamline.Media.MP4.Box.Sgpd do
  @moduledoc """
  `sgpd` Sample Group Description

  This description table gives information about the characteristics of sample groups.
  The descriptive information is any other information needed to define or characterize
  the sample group.

  There may be multiple instances of this box if there is more than one sample grouping
  for the samples in a track. Each instance of the SampleGroupDescription box has a type
  code that distinguishes different sample groupings. There shall be at most one instance
  of this box with a particular grouping type in a Sample Table Box or Track Fragment Box.
  The associated SampleToGroup shall indicate the same value for the grouping type.

  The information is stored in the sample group description box after the entry‐count.
  An abstract entry type is defined and sample groupings shall define derived types to
  represent the description of each sample group. For video tracks, an abstract
  VisualSampleGroupEntry is used with similar types for audio and hint tracks.
      NOTE: In version 0 of the entries the base classes
      for sample group description entries are neither
      boxes nor have a size that is signaled. For this
      reason, use of version 0 entries is deprecated.
      When defining derived classes, ensure either that
      they have a fixed size, or that the size is explicitly
      indicated with a length field. An implied size
      (e.g. achieved by parsing the data) is not recommended
      as this makes scanning the array difficult.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t() :: %Sgpd{
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
                 # default_length indicates the length of every group entry (if the length
                 # is constant), or zero (0) if it is variable
                 default_length: Binary.u32(),
                 # `default_sample_description_index` specifies the index of the sample group
                 # group description which applies to the samples in the track for which no
                 # sample to group mapping is provided through the Sample To Group box. Default
                 # value is 0
                 default_sample_description_index: Binary.u32(),
                 entry_count: Binary.u32(),
                 entries: [%{
                   description_length: Binary.u32(),
                   entry: term()
                 }]
               }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    grouping_type: 0,
    default_length: 0,
    default_sample_description_index: 0,
    entry_count: 0,
    entries: []
  ]

  # TODO: parse entries
  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          1 :: 8,
          flags :: bitstring - size(24),
          gt :: bytes-size(4),
          default_length :: size(32) - unsigned - big - integer,
          entry_count :: size(32) - unsigned - big - integer,
          entries :: binary,
        >>
      ) do
    %Sgpd{
      info: i,
      version: 1,
      flags: flags,
      grouping_type: gt,
      default_length: default_length,
      entry_count: entry_count,
    }
    |> write_entries(entries)
  end

  def write(
        %Info{} = i,
        <<
          2 :: 8,
          flags :: bitstring - size(24),
          gt :: bytes-size(4),
          default_desc_index :: size(32) - unsigned - big - integer,
          entry_count :: size(32) - unsigned - big - integer,
          entries :: binary
        >>
      ) do
    %Sgpd{
      info: i,
      version: 2,
      flags: flags,
      grouping_type: gt,
      default_sample_description_index: default_desc_index,
      entry_count: entry_count
    }
    |> write_entries(entries)
  end

  defp write_entries(
         %Sgpd{entry_count: ec, entries: entries} = s,
         <<
           data :: binary
         >>
       ) when length(entries) < ec do
    s
  end

  defp write_entries(%Sgpd{} = s, _), do: s

  defp write_desc_length(%Sgpd{version: 1, default_length: 0} = s, <<data :: binary>>) do

  end

  defp write_desc_length(%Sgpd{} = s, _), do: s
end
