defmodule Streamline.Media.MP4.Box.Btrt do
  @moduledoc """
  `btrt` Bit Rate Box
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Btrt{
               buffer_size_db: Binary.u32(),
               max_bitrate: Binary.u32(),
               avg_bitrate: Binary.u32()
             }

  defstruct [:buffer_size_db, :max_bitrate, :avg_bitrate]
end
