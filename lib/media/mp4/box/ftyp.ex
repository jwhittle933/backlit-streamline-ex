defmodule Streamline.Media.MP4.Box.Ftyp do
  @moduledoc """
  ftyp BMFF box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info
  alias Streamline.Media.MP4.Box.Written

  @type t() :: %Ftyp {
                  info: Info.t(),
                  major_brand: <<_::4, _::_*8>>,
                  minor_version: integer,
                  compatible_brands: list(<<_::4, _::_*8>>)
               }

  defstruct [:info, :major_brand, :minor_version, :compatible_brands]

  def write(%Ftyp{}, src) do

  end
end
