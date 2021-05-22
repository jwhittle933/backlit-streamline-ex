defmodule Streamline.Media.MP4.Box.Smhd do
  @moduledoc """
  `smhd` Sound Media Header

  Audio tracks use the SoundMediaHeader box in the media information box as defined in 8.4.5.
  The sound media header contains general presentation information, independent of the coding,
  for audio media. This header is used for all tracks containing audio.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t() :: %Smhd{
                 info: Info.t(),
                 # `version` is an integer that specifies the version of this box
                 # (0 or 1 in this specification)
                 version: Binary.u8(),
                 # `flags` is a map of flags
                 flags: <<_ :: 24>>,
                 # balance is a fixed‐point 8.8 number that places mono audio tracks
                 # in a stereo space; 0 is centre (the normal value); full left is
                 # ‐1.0 and full right is 1.0.
                 balance: Binary.u16()
               }

  defstruct [:info, :version, :flags, :balance]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          balance :: size(16) - unsigned - big - integer,
          _ :: binary
        >>
      ) do
    %Smhd{info: i, version: v, flags: flags, balance: balance}
  end
end
