defmodule Streamline.Media.MP4.Box.Vmhd do
  @moduledoc """
  `vmhd` BMFF Box (Media Declaration Container)
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Vmhd{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               # `graphics_mode` specifies a composition mode for this video track,
               # from the following enumerated set, which may be extended by derived
               # specifications: copy = 0 copy over the existing image
               graphics_mode: Binary.u16(),
               # `opcolor` is a set of 3 color values (red, green, blue) available for
               # use by graphics modes
               opcolor: {Binary.u16(), Binary.u16(), Binary.u16()}
             }

  defstruct [
    :info,
    :version,
    :flags,
    :graphics_mode,
    :opcolor
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          gm :: size(16) - unsigned - big - integer,
          oc1 :: size(16) - unsigned - big - integer,
          oc2 :: size(16) - unsigned - big - integer,
          oc3 :: size(16) - unsigned - big - integer,
        >>
      ) do
    %Vmhd{info: i, version: v, flags: flags, graphics_mode: gm, opcolor: {oc1, oc2, oc3}}
  end
end
