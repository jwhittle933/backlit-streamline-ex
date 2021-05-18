defmodule Streamline.Media.MP4.Box.Trak do
  @moduledoc false
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info
  alias __MODULE__

  @type children :: list(any())
  @type t() :: %Trak{
                 info: Info.t(),
                 children: children()
               }

  defstruct [:info, :children]

  def write(%Info{} = i, <<data :: binary>>) do
    data
    |> Box.read()
    |> (&%Trak{info: i, children: &1}).()
  end
end
