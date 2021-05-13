defmodule Streamline.Media.MP4.Box do
  @moduledoc false
  alias Streamline.Media.MP4.Box.Info
  alias __MODULE__

  @behaviour Streamline.Media.MP4.Box.Boxed

  defprotocol Typeable do
    @spec type(t) :: String.t()
    def type(box)
  end

  defprotocol Writeable do
    @spec write(t, iodata()) :: t
    def write(box, src)
  end

  defprotocol Infoable do
    @spec info(t) :: Info.t()
    def info(box)
  end

  ####### Behaviors ######
  # Each behavior below should operate on a box
  # that implements the protocols above
  def type(box) do
    Box.Typeable.type(box)
  end

  def write(box, iodata) do
    Box.Writeable.write(box, iodata)
  end

  def stringify(box) do
    String.Chars.to_string(box)
  end

  def info(box) do
    Box.Infoable.info(box)
  end

  @spec box_module(String.t()) :: module()
  def box_module(box_name) do
    :"Elixir.Streamline.Media.MP4.Box.#{:string.titlecase(box_name)}"
  end

  @spec write_box(String.t(), iodata()) :: module()
  def write_box(%Info{type: t} = i, data) do
    t
    |> box_module()
    |> apply(:write, [i, data])
  end
end
