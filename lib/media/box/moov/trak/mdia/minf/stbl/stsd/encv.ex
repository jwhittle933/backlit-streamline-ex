defmodule Streamline.Media.MP4.Box.Encv do
  @moduledoc """
  `encv` Box (Audio Sample)
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.{ Info, Sample.Visual }

  @type t :: %Encv{
               info: Info.t(),
               visual: Visual.t(),
               children: Box.children(),
             }

  defstruct [
    info: nil,
    visual: nil,
    children: []
  ]

  def write(%Info{ } = i, << data :: binary >>) do
    data
    |> Visual.write()
    |> write_self(i)
  end

  def write_self({ %Visual{ } = v, << data :: binary >> }, %Info{ } = i) do
    %Encv{ info: i, visual: v }
  end
end
