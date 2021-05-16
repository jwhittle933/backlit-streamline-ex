defmodule Streamline.Media.MP4.Box.Mvhd do
  @moduledoc false

  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type children :: list(any())
  @type t() :: %Mvhd{
                 info: Info.t(),
                 children: children()
               }

  defstruct [:info, :children]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Mvhd{info: i}
  end
end
