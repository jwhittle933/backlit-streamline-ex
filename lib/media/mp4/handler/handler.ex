defmodule Streamline.Media.MP4.Handler do
  @moduledoc """
  MP4 Handler for lazy parsing and lookup

  The handler parses the binary information into a registry
  of offsets and sizes

  Rather than reading the data into structs, the Handler acts
  as the data interface to the binary stream. The data for each
  box will be unknown until access through the handler

  For example, the `ftyp` box:
    %MP4{children: [%Ftyp{}]}
    %Handler{raw: << ... >>, registry: [%Info{type: "ftyp", offset: 0, size: 32}]}

  Appropriate function will be provided here and in MP4 to navigate between
  the two read paradigms
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %Handler{
                 raw: iodata(),
#                 rev_registry: %{
#                   Range.t() => iodata()
#                 },
                 registry: [Info.t()]
               }

  defstruct [raw: nil, registry: []]
end
