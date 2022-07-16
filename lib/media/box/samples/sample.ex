defmodule Streamline.Media.MP4.Box.Sample do
  @moduledoc """
  Sample Entry
  """
  alias __MODULE__
  alias Streamline.Binary

  @type t :: %Sample{
               reserved: << _ :: 48 >>,
               data_reference_index: Binary.u16()
             }

  defstruct [
    :reserved,
    :data_reference_index
  ]

  @spec write(iodata()) :: t()
  def write(<< res :: size(48) - unsigned - big - integer, dfi :: size(16) - unsigned - big - integer, rest :: binary >>) do
    { %Sample{ reserved: res, data_reference_index: dfi }, rest }
  end
end
