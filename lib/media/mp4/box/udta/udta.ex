defmodule Streamline.Media.MP4.Box.Udta do
  @moduledoc """
  `udta` User Data

  This box contains objects that declare user information about the containing box and its data
  (presentation or track).

  The User Data Box is a container box for informative user‐data. This user data is formatted as
  a set of boxes with more specific box types, which declare more precisely their content.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t :: %Udta{
               info: Info.t(),
               children: children(),
             }

  defstruct [
    info: nil,
    children: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary,>>) do
    data
    |> Box.read()
    |> (&%Udta{info: i, children: &1}).()
  end
end
