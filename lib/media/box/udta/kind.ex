defmodule Kind do
  @moduledoc """
  `kind` Kind box

  The Kind box labels a track with its role or kind.

  It contains a URI, possibly followed by a value. If only a URI occurs, then the kind is defined
  by that URI; if a value follows, then the naming scheme for the value is identified by the URI.
  Both the URI and the value are null‐terminated C strings.


  More than one of these may occur in a track, with different contents but with appropriate semantics
  (e.g. two schemes that both define a kind that indicates sub‐titles).
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Kind{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               # `scheme_uri` is a NULL‐terminated C string declaring either the identifier of the
               # kind, if no value follows, or the identifier of the naming scheme for the following value.
               scheme_uri: String.t(),
               # value is a name from the declared scheme
               value: String.t(),
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    scheme_uri: nil,
    value: nil,
  ]

  # TODO: split on null terminator
  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          rest :: binary
        >>
      ) do
    %Kind{
      info: i,
      version: v,
      flags: flags
    }
  end
end
