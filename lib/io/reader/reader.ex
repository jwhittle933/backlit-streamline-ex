defprotocol Streamline.IO.Read do
  @spec read(t) :: iodata()
  def read(src)
end

defmodule Streamline.IO.Reader do
  @moduledoc """
  Streamline IO Reader Module
  """
  alias __MODULE__

  @type t() :: %Reader {
                  pos: integer,
                  r: IO.device(),
                  last_read: iodata() | IO.nodata()
               }

  defstruct [:pos, :r, :last_read]

  @spec new(IO.device()) :: t
  def new(device), do: %Reader{r: device, pos: 0}

  @spec seek(t, integer()) :: t
  def seek(%Reader{} = reader, position) do
    :file.position(reader.r, position)

    %Reader{r: reader.r, pos: position}
  end

  @spec cursor(t) :: integer
  def cursor(%Reader{r: device} = r) do
    {:ok, p} = :file.position(device, :cur)
    %Reader{r | r: device, pos: p}
  end

  @spec read(t(), non_neg_integer()) :: t()
  def read(%Reader{r: r, pos: p}, n) do
    %Reader{r: r, pos: p + n, last_read: IO.binread(r, n)}
  end
end
