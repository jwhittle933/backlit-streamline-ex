defmodule Streamline.Media.MP4.Box.Mdia do
  @moduledoc """
  `mdia` BMFF Box (Media Declaration Container)
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t :: %Mdia {
               info: Info.t(),
               children: children()
             }

  defstruct [
    info: nil,
    children: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    data
    |> Box.read()
    |> (&%Mdia{info: i, children: &1}).()
  end
end
