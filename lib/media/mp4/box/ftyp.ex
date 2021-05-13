defmodule Streamline.Media.MP4.Box.Ftyp do
  @moduledoc """
  ftyp BMFF box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %Ftyp {
                 info: Info.t(),
                 major_brand: <<_ :: 4, _ :: _ * 8>>,
                 minor_version: integer,
                 compatible_brands: list(<<_ :: 4, _ :: _ * 8>>)
               }

  defstruct [:info, :major_brand, :minor_version, :compatible_brands]

  @spec write(iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Ftyp{info: i}
  end
end
