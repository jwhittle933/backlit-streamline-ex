defmodule Streamline.Media.MP4.Box.Hdlr do
  @moduledoc """
  `mdia` BMFF Box (Media Declaration Container)
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Hdlr {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               predefined: Binary.u32(),
               # `handler_type`
               # – when present in a media box, contains a value as defined
               # in clause 12, or a value from a derived specification, or
               # registration.
               #
               # - when present in a meta box, contains an appropriate value
               # to indicate the format of the meta box contents. The value
               # ‘null’ can be used in the primary meta box to indicate that
               # it is merely being used to hold resources.
               handler_type: String.t(),
               reserved: list(String.t() | Binary.u32()),
               # `name` is a null‐terminated string in UTF‐8 characters which gives
               # a human‐readable name for the track type (for debugging and
               # inspection purposes).
               name: String.t()
             }

  defstruct [
    :info,
    :version,
    :flags,
    :predefined,
    :handler_type,
    :reserved,
    :name
  ]

  def write(
        %Info{} = i,
        <<
          version :: 8,
          flags :: bitstring - size(24),
          predefined :: size(32) - unsigned - big - integer,
          hdlr :: bytes - size(4),
          r1 :: bytes - size(4),
          r2 :: bytes - size(4),
          r3 :: bytes - size(4),
          name :: binary
        >>
      ) do
    %Hdlr{
      info: i,
      version: version,
      flags: flags,
      predefined: predefined,
      handler_type: hdlr,
      reserved: [string_or(r1), string_or(r2), string_or(r3)],
      name: Binary.strip_null_term(name)
    }
  end

  @spec string_or(iodata()) :: String.t() | Binary.u32()
  defp string_or(<<0, 0, 0, 0>>), do: 0
  defp string_or(str) when is_binary(str), do: str
  defp string_or(_), do: ""
end
