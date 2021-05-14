defmodule Streamline.Media.MP4.Box.Free do
  @moduledoc false

  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %Free {
                 info: Info.t()
               }

  defstruct [:info]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Free{info: i}
  end
end
