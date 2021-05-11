defmodule Streamline.IO do
  @moduledoc """
  Streamline IO module
  """
  alias Streamline.Media.MP4.Box.Writeable

  @spec copy_n(Writeable.t(), IO.device() | iodata(), integer()) :: integer()
  def copy_n(box, device, n) do
    Writeable.write(box, IO.binread(device, n))
  end
end
