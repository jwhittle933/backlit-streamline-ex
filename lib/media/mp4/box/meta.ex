defmodule Streamline.Media.MP4.Box.Meta do
  @moduledoc """
  `meta` Meta box

  A meta box contains descriptive or annotative metadata. The 'meta' box is required to contain a
  ‘hdlr’ box indicating the structure or format of the ‘meta’ box contents. That metadata is located
  either within a box within this box (e.g. an XML box), or is located by the item identified by a
  primary item box.

  All other contained boxes are specific to the format specified by the handler box.

  The other boxes defined here may be defined as optional or mandatory for a given format. If they
  are used, then they must take the form specified here. These optional boxes include a data‐information
  box, which documents other files in which metadata values (e.g. pictures) are placed, and a item
  location box, which documents where in those files each item is located (e.g. in the common case of
  multiple pictures stored in the same file). At most one meta box may occur at each of the file level,
  movie level, or track level, unless they are contained in an additional metadata container box (‘meco’).

  If an Item Protection Box occurs, then some or all of the meta‐data, including possibly the primary
  resource, may have been protected and be un‐readable unless the protection system is taken into account.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Meta{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               children: [term()]
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    children: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          rest :: binary
        >>
      ) do
    rest
    |> Box.read()
    |> (&%Meta{info: i, version: v, flags: flags, children: &1}).()
  end
end
