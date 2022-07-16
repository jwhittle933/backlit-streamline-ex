defmodule Streamline.Media.MP4.Box.Dinf do
  @moduledoc """
  `dinf` BMFF Box (Data Information Container)
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t :: %Dinf{
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
    |> (&%Dinf{info: i, children: &1}).()
  end
end
