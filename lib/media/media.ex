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
  parse_media takes raw input and returns the media type
  """
  def parse_media() do
    #
  end
end
