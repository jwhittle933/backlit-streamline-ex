defmodule Streamline.Media.MP4.Box do
  @moduledoc false

  defprotocol Boxed do
    @spec type(any()) :: String.t()
    def type(box)

    @spec write(iodata()) :: {any(), iodata()}
    def write(src)

    @spec print(any()) :: String.t()
    def print(box)

    @spec info(any()) :: Info.t()
    def info(box)
  end

  defprotocol Write do
    @spec write(iodata()) :: {any(), iodata()}
    def write(src)
  end
end
