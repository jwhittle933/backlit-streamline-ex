defmodule Streamline.Media.MP4.Box.Edts do
  @moduledoc false
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t() :: %Edts{
                 info: Info.t(),
                 children: children() # moov has no defined fields; it wraps child boxes to be defined later
               }

  defstruct [info: nil, children: []]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    data
    |> Box.read()
    |> (&%Edts{info: i, children: &1}).()
  end
end
