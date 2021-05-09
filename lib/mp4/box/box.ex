defmodule Streamline.Media.MP4.Box do
  @moduledoc false

  defprotocol Boxed do
    @spec type() :: String.t()
    def type()

    @spec write(iodata()) :: {any(), iodata()}
    def write(src)

    @spec string() :: String.t()
    def print()

    @spec info() :: Info.t()
  end

  defprotocol Write do
    @spec write(iodata()) :: {any(), iodata()}
    def write(src)
  end
end
