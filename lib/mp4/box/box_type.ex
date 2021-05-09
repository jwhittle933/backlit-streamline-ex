defmodule Streamline.Media.MP4.Box.BoxType do
  @moduledoc """
  See https://hexdocs.pm/elixir/typespecs.html

  BoxType represents a 4 member list of bytes
  that can be UTF8 encoded
  """

  defprotocol BoxTyped do
    #
  end

  @type t() :: <<_::4, _::_*unit>>

  def from(<<type::4, rest::binary>>) do
    #
  end
end
