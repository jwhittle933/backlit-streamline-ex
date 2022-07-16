defmodule Streamline.Media do
  @moduledoc """
  Module Media for basic media type detection and parsing
  """
  alias Streamline.Connector.Connect

  defimpl Connect do
    def connect(to) do
      #
    end
  end

  defstruct [:type, :data, :valid?, :errors]

  @doc """
  `media?` reads and reports whether or not the content is
  media encoded
  """
  def media?(filepath) when is_binary(filepath) do
    #
  end

  def media?(<< data :: binary >>) do
    #
  end

  def media?(device) do
    #
  end

  @doc """
  `fragmented?` reads and reports whether the media content
  is fragmented
  """
  def fragmented?() do
    #
  end
end
