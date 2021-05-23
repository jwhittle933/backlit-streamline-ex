defmodule Streamline.Media.MP4.Box.Loci do
  @moduledoc """
  `loci`
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Loci{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               # language declares the language code for the following text. See ISO 639‐2/T
               # for the set of three character codes. Each character is packed as the
               # difference between its ASCII value and 0x60. The code is confined to being
               # three lower‐case letters, so these values are strictly positive.
               language: String.t(),
               name: String.t(),
               role: Binary.u8(),
               longitude: Binary.u32(),
               latitude: Binary.u32(),
               altitude: Binary.u32(),
               astronomical_body: String.t(),
               additional_notes: String.t()
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    pad: 0,
    language: "",
    name: "",
    role: "",
    latitude: 0,
    longitude: 0,
    altitude: 0,
    astronomical_body: "",
    additional_notes: ""
  ]

  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          pad :: 1,
          language :: size(15) - unsigned - big - integer,
          data :: binary
        >>
      ) do
    %Loci{info: i, version: v, flags: flags, language: Binary.language_code(language)}
  end
end
