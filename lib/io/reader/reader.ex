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
                 r: IO.device()
               }

  defstruct [:pos, :r]

  @spec new(IO.device()) :: t
  def new(device), do: %Reader{r: device, pos: 0}

  @spec seek(t, integer()) :: t
  def seek(%Reader{} = reader, position) do
    :file.position(reader.r, position)

    %Reader{r: reader.r, pos: position}
  end

  @spec cursor(t) :: integer
  def cursor(%Reader{pos: p}), do: p
end
