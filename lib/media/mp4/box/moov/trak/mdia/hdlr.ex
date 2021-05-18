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
               reserved: <<_ :: 3, _ :: _ * 64>>,
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
          _ :: size(32),
          _ :: size(32),
          _ :: size(32),
          name :: binary
        >>
      ) do
    %Hdlr{
      info: i,
      version: version,
      flags: flags,
      predefined: predefined,
      handler_type: hdlr,
      name: strip_null_term(name)
    }
    |> IO.inspect()
  end

  defp strip_null_term(name), do: binary_part(name, 0, byte_size(name) - 1)
end
