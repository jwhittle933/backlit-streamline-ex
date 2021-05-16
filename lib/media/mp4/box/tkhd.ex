defmodule Streamline.Media.MP4.Box.Tkhd do
  @moduledoc false
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type children :: list(any())
  @type t() :: %Tkhd{
                 info: Info.t(),
                 children: children()
               }

  defstruct [:info, :children]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Tkhd{info: i}
  end
end
