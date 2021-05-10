defmodule Streamline.Media.MP4.Box.Ftyp do
  @moduledoc """
  ftyp BMFF box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %Ftyp {
                  info: Info.t(),
                  major_brand: <<_::bytes-size(4)>>,
                  minor_version: integer,
                  compatible_brands: list(<<_::bytes-size(4)>>)
               }

  defstruct [:info, :major_brand, :minor_version, :compatible_brands]
end
