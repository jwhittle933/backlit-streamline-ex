defmodule Streamline.Media.MP4.Box.Srat do
  @moduledoc """
  `srat` Sampling Rate Box
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Info

  @type t :: %Srat{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: << _ :: 24 >>,
               sampling_rate: Binary.u32()
             }

  defstruct [:info, :version, :flags, :sampling_rate]

  def write(
        %Info{ } = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          sr :: size(32) - unsigned - big - integer
        >>
      ) do
    %Srat{ info: i, version: v, flags: flags, sampling_rate: sr }
  end
end
