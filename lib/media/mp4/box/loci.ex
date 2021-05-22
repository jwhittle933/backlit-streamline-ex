defmodule Streamline.Media.MP4.Box.Loci do
  @moduledoc """
  `loci`
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Loci{
               info: Info.t(),
               data: iodata()
             }

  defstruct [:info, :data]

  def write(%Info{} = i, <<data :: binary>>) do
    %Loci{info: i, data: data}
  end
end
