defmodule Streamline.Media.MP4.Box.Esds do
  @moduledoc """
  `esds` Elementary Stream Descriptor Box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.Info
  alias Esds.Descriptor

  @type t :: %Esds{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: << _ :: 24 >>,
               descriptors: [Descriptor.t()],
               children: Box.children()
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    descriptors: [],
    children: []
  ]

  def write(
        %Info{ } = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          rest :: binary
        >>
      ) do
    %Esds{
      info: i,
      version: v,
      flags: flags,
    }
  end
end
