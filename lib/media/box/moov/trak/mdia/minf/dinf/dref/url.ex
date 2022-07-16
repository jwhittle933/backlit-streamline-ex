defmodule Streamline.Media.MP4.Box.Url do
  @moduledoc """
  `url ` BMFF Box
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Url {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               location: String.t()
             }

  defstruct [:info, :version, :flags, :location]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          location :: binary
        >>
      ) do
    %Url{version: v, flags: flags, location: location}
  end
end
