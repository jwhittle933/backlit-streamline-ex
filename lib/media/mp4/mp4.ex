defmodule Streamline.Media.MP4 do
  @moduledoc """
  MP4 base module for mp4 parsing and handling
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box.{
    Ftyp,
    Moov
  }
  alias Streamline.Media.MP4.Handler

  @type t() :: %MP4 {
                  size: integer,
                  ftyp: Ftyp.t(),
                  moov: Moov.t(),
                  free: any(),
                  skip: any(),
                  valid?: boolean
               }

  defstruct [:size, :ftyp, :moov, :free, :skip, :valid?]

  @spec open(iodata() | String.t()) :: {:ok | :error, MP4.t()}
  def open(<<size::bytes-size(4), ?f, ?t, ?y, ?p, data::binary>>) do
    #
  end

  def open(filepath) when is_binary(filepath) do
    #
  end

  def open(_) do
    #
  end

  @spec open!({:ok | :error, iodata() | :file.posix()} | iodata() | String.t()) :: MP4.t()
  def open!({:ok, <<data::binary>>}) do
    #
  end

  def open!({:error, error_code}) do
    {:error, %MP4{valid?: false}}
  end

  def open!(filepath) when is_binary(filepath) do
    # will a string filepath string be interpreted as binary?
  end

  def open!(<<data::binary>>) do
    # will a string filepath string be interpreted as binary?
  end

  def open!(_) do
    #
  end

  @spec handle(String.t() | iodata()) :: Handler.t()
  def handle(filepath) when is_binary(filepath) do
    #
  end

  def handle(<<data::binary>>) do
    #
  end
end
