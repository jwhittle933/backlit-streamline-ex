defmodule Streamline.Media.MP4.Box.Co64 do
  @moduledoc """
  `co64` box alias for 64-bit stco
  """
  alias __MODULE__, as: Co
  alias Streamline.Media.MP4.Box.Stco

  defdelegate write(info, data), to: Stco
end
