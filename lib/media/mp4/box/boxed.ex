defmodule Streamline.Media.MP4.Box.Boxed do
  @moduledoc """
  Boxed behavior module
  """
  alias Streamline.Media.MP4.Box.Info

  @callback type(any()) :: String.t()
  @callback write(any(), iodata()) :: integer
  @callback stringify(any()) :: String.t()
  @callback info(any()) :: Info.t()
end
