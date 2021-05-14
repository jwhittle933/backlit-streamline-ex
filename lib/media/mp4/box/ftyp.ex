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

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<major_brand :: bytes - size(4), minor_version :: size(32) - unsigned - big - integer, data :: binary>>
      ) do
    %Ftyp{
      info: i,
      major_brand: major_brand,
      minor_version: minor_version,
      compatible_brands: []
    }
    |> write_compatible_brands(data)
  end

  defp write_compatible_brands(%Ftyp{compatible_brands: cb} = f, <<brand :: bytes - size(4)>>) do
    append_brand(f, brand)
  end

  defp write_compatible_brands(%Ftyp{compatible_brands: cb} = f, <<brand :: bytes - size(4), rest :: binary>>) do
    f
    |> append_brand(brand)
    |> write_compatible_brands(rest)
  end

  defp append_brand(%Ftyp{compatible_brands: cb} = f, <<brand :: bytes - size(4)>>) do
    %Ftyp{f | compatible_brands: cb ++ [brand]}
  end
end
