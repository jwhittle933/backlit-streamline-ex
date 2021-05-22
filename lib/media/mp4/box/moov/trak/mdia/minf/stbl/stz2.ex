defmodule Streamline.Media.MP4.Box.Stz2 do
  @moduledoc """
  `stz2` box alias for stsz
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.Stsz

  @type t :: Stsz.t()

  defdelegate write(info, data), to: Stsz
end
