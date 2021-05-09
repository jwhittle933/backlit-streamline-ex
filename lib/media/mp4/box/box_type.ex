defmodule Streamline.Media.MP4.Box.BoxType do
  @moduledoc """
  See https://hexdocs.pm/elixir/typespecs.html

  BoxType represents a 4 member list of bytes
  that can be UTF8 encoded
  """

  defprotocol BoxTyped do
    #
  end

  @type t() :: binary()

  @spec from(iodata()) :: {iodata(), iodata()}
  def from(<<name :: bytes - size(4), rest :: binary>>) do
    {name, rest}
  end

  def from(<<data::binary>>) do
    {"unknown", data}
  end
end
