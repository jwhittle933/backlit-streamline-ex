defmodule Streamline.Media.MP4.Server do
  """
  GenServer implementation for reading MP4s
  """
  use GenServer
  alias __MODULE__
  alias Streamline.Media.MP4

  def init(%{ filename: f }), do: { :ok, MP4.read_all(f) }
  def init(%{ file: f }), do: { :ok, MP4.read_all(f) }


  def handle_call({}, _from, state) do

  end

  def handle_cast({}, state) do

  end
end
