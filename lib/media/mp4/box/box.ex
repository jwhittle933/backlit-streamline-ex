defmodule Streamline.Media.MP4.Box do
  @moduledoc false
  alias Streamline.Media.MP4.Box.Info
  alias __MODULE__

  @behaviour Streamline.Media.MP4.Box.Boxed

  defprotocol Typeable do
    @spec type(t) :: String.t()
    def type(box)
  end

  defprotocol Writeable do
    @spec write(t, iodata()) :: t
    def write(box, src)
  end

  # String.Chars instead?
  defprotocol Stringable do
    @spec stringify(t) :: String.t()
    def stringify(box)
  end

  defprotocol Infoable do
    @spec info(t) :: Info.t()
    def info(box)
  end

  ####### Behaviors ######
  # Each behavior below should operate on a box
  # that implements the protocols above
  def type(box) do
    Box.Typeable.type(box)
  end

  def write(box, iodata) do
    Box.Writeable.write(box, iodata)
  end

  def stringify(box) do
    Box.Stringable.stringify(box)
  end

  def info(box) do
    Box.Infoable.info(box)
  end
end
