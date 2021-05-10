defmodule Streamline.Connector do
  @moduledoc """
  Connector module for media type conversion
  """

  defprotocol Connect do
    def connect(to)
  end
end
