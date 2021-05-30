defmodule Streamline.Media.MP4.Box.Avc1 do
  @moduledoc """
  `avc` box
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.{ Info, Sample.Visual }

  @type t :: %Avc1{
               info: Info.t(),
               visual: Visual.t(),
               children: Box.children()
             }

  defstruct [
    info: nil,
    visual: nil,
    children: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{ } = i, data) do
    data
    |> Visual.write()
    |> write_self(i)
  end

  def write_self({ %Visual{ } = v, << data :: binary >> }, %Info{ } = i) do
    %Avc1{
      info: i,
      visual: v,
      children: Box.read(data)
    }
  end
end
