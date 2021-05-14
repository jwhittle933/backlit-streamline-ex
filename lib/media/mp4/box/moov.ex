defmodule Streamline.Media.MP4.Box.Moov do
  @moduledoc """
  moov BMFF movie box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type children :: list(any())
  @type t() :: %Moov {
                 info: Info.t(),
                 children: children() # moov has no defined fields; it wraps child boxes to be defined later
               }

  defstruct [:info, :children]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Moov{info: i}
  end
end
