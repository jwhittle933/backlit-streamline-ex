defmodule Streamline.Media.MP4.Box.Cprt do
  @moduledoc """
  `cprt` Copyright

  The Copyright box contains a copyright declaration which applies to the entire presentation,
  when contained within the Movie Box, or, when contained in a track, to that entire track.
  There may be multiple copyright boxes using different language codes.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Cprt {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               pad: <<_ :: 1>>,
               # language declares the language code for the following text. See ISO 639‐2/T
               # for the set of three character codes. Each character is packed as the
               # difference between its ASCII value and 0x60. The code is confined to being
               # three lower‐case letters, so these values are strictly positive.
               language: String.t(),
               # notice is a null‐terminated string in either UTF‐8 or UTF‐16 characters,
               # giving a copyright notice. If UTF‐16 is used, the string shall start with
               # the BYTE ORDER MARK (0xFEFF), to distinguish it from a UTF‐8 string. This
               # mark does not form part of the final string.
               notice: String.t()
             }

  defstruct [:info, :version, :flags, :pad, :language, :notice]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          pad :: size(1),
          language :: size(15) - unsigned - big - integer,
          notice :: binary
        >>
      ) do
    %Cprt{
      info: i,
      version: v,
      flags: flags,
      pad: pad,
      language: Binary.language_code(language),
      notice: Binary.strip_null_term(notice)
    }
  end
end
