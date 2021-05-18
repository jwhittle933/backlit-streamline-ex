defmodule Streamline.Media.MP4.Box.Minf do
  @moduledoc """
  `minf` BMFF media information box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t() :: %Minf{
                 info: Info.t(),
                 children: children()
               }

  defstruct [:info, :children]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    data
    |> Box.read()
    |> (&%Minf{info: i, children: &1}).()
  end
end
