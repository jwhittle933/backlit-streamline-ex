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

  @spec new(IO.device())
  def new(device), do: %Reader{r: device, pos: 0}

  @spec seek(t, integer()) :: t
  def seek(%Reader{} = reader, position) do
    :file.position(reader.r, position)

    reader
  end

  @spec cursor(t) :: integer
  def cursor(%Reader{pos: p}), do: p
end
