defmodule Streamline.Media.MP4.Box.Mp4a do
  @moduledoc """
  `mp4a` Box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.{ Info, Sample.Audio }

  @type children :: [term()]
  @type t() :: %Mp4a{
                 info: Info.t(),
                 audio: Audio.t(),
                 children: Box.children()
               }

  defstruct [
    info: nil,
    audio: nil,
    children: []
  ]

  def write(%Info{ } = i, << data :: binary >>) do
    data
    |> Audio.write()
    |> write_self(i)
  end

  def write_self({ %Audio{ } = a, << data :: binary >> }, %Info{ } = i) do
    %Mp4a{
      info: i,
      audio: a,
      children: Box.read(data)
    }
  end
end
