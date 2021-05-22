defmodule Streamline.Media.MP4.Box.Ilst do
  @moduledoc false
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Ilst {
               info: Info.t(),
               data: iodata()
             }

  defstruct [:info, :data]

  def write(%Info{} = i, <<data :: binary>>) do
    %Ilst{info: i, data: data}
  end
end
