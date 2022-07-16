defmodule Streamline.IO.Writer do
  @moduledoc """
  `writer` module for file writing
  """
  alias __MODULE__
  alias Streamline.IO.Reader

  defstruct []

  def from(%Reader{}) do
    %Writer{}
  end
end
