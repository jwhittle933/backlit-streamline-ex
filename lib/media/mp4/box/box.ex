defmodule Streamline.Media.MP4.Box do
  @moduledoc false
  @behavior Streamline.Media.MP4.Box.Boxed

  defprotocol Typed do
    @spec type(any()) :: String.t()
    def type(box)
  end

  defprotocol Write do
    @spec write(iodata()) :: {any(), iodata()}
    def write(src)
  end

  defprotocol Print do
    @spec print(any()) :: String.t()
    def print(box)
  end

  defprotocol Info do
    @spec info(any()) :: Info.t()
    def info(box)
  end

  ####### Behaviors ######
  # Each behavior below should operate on a box
  # that implements the protocols above
  def type(box) do
    #
  end

  def write(box, iodata) do
    #
  end

  def stringify(box) do
    #
  end

  def info(box) do
    #
  end
end
