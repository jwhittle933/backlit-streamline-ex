defmodule Streamline.Media.MP4.Box.BoxType do
  @moduledoc """
  See https://hexdocs.pm/elixir/typespecs.html

  BoxType represents a 4 member list of bytes
  that can be UTF8 encoded
  """

  defprotocol BoxTyped do
    #
  end

  @type t() :: <<_ :: 4, _ :: _ * 8>>

  @spec from(iodata() | String.t()) :: t()
  def from(<<name :: bytes - size(4)>>) do
    name
  end

  def from(_) do
    "unknown"
  end
end
