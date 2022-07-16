defmodule Streamline.Media.MP4.Box.Mvex do
  @moduledoc """
  `mvex` Box

  This box warns readers that there might be Movie Fragment Boxes in this file. To know of all samples in the tracks,
  these Movie Fragment Boxes must be found and scanned in order, and their information logically added to that found
  in the Movie Box.
  """
  use Streamline.Media.MP4.Box

  @type t :: %Mvex {
               info: Info.t(),
               children: Box.children()
             }

  defstruct info: nil, children: []

  def write(%Info{ } = i, << data :: binary >>) do
    %Mvex{
      info: i,
      children: Box.read(data)
    }
  end
end
