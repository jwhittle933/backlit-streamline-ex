defmodule Streamline.Media.MP4.Box.Moov do
  @moduledoc """
  moov BMFF movie box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t() :: %Moov {
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
    |> (&%Moov{info: i, children: &1}).()
  end
end
