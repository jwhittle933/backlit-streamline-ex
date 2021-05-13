defmodule Streamline.Media.MP4.Box.Mdat do
  @moduledoc false

  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type children :: list(any())
  @type t() :: %Mdat {
                 info: Info.t(),
                 children: children() # moov has no defined fields; it wraps child boxes to be defined later
               }

  defstruct [:info, :children]

  @spec write(iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Mdat{info: i}
  end
end
