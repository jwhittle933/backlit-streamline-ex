defmodule Streamline.Media.MP4.Box.Mdat do
  @moduledoc false

  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type children :: list(any())
  @type t() :: %Mdat {
                 info: Info.t(),
                 children: children()
               }

  defstruct [info: nil, children: []]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Mdat{info: i}
  end
end
