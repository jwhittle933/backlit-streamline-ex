defmodule Streamline.Media.MP4.Box.Dref do
  @moduledoc """
  `dref` BMFF Box (Data Reference object)

  The data reference object contains a table of data references
  (normally URLs) that declare the location(s) of the media data
  used within the presentation. The data reference index in the
  sample description ties entries in this table to the samples in
  the track. A track may be split over several sources in this way.

  The `entry_count` in the DataReferenceBox shall be 1 or greater;
  each DataEntryBox within the DataReferenceBox shall be either a
  DataEntryUrnBox or a DataEntryUrlBox.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t :: %Dref {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               children: children()
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    entry_count: 0,
    children: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          ec :: size(32) - unsigned - big - integer,
          rest :: binary
        >>
      ) do
    rest
    |> Box.read()
    |> (&%Dref{
      info: i,
      version: v,
      flags: flags,
      entry_count: ec,
      children: &1
    }).()
  end


end
