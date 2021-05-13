defmodule Streamline.IO do
  @moduledoc """
  Streamline IO module
  """
  alias Streamline.Media.MP4.Box.Writeable
  alias Streamline.IO.Reader

  @spec copy_n(Writeable.t(), IO.device() | iodata(), integer()) :: integer()
  def copy_n(box, device, n) do
    Writeable.write(box, IO.binread(device, n))
  end

  @spec read_next(IO.device() | iodata() | :eof) :: term()
  def read_next(<<data :: binary>>) do

  end

  def read_next(:eof) do

  end
end
