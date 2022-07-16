defmodule Streamline.Media.MP4.Box.Skip do
  @moduledoc false

  alias __MODULE__
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %Skip {
                 info: Info.t(),
                 raw: iodata()
               }

  defstruct [:info, :raw]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Skip{info: i, raw: data}
  end
end
