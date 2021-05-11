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
                 valid?: boolean,
                 d: IO.device()
               }

  defstruct [:size, :ftyp, :moov, :free, :skip, :valid?, :d]

  @spec open(iodata() | String.t() | IO.device()) :: {:ok | :error, MP4.t()}
  def open(<<size :: size(32), ?f, ?t, ?y, ?p, data :: binary>>) do
    {:ok, %MP4{}}
  end

  def open(filepath) when is_binary(filepath) do
    with {:ok, f} <- File.open(filepath) do
      {:ok, %MP4{d: f}}
    else
      {:error, exit} -> {:error, exit}
    end
  end

  def open(device) do
    #
  end

  def open(_) do
    #
  end

  @spec open!({:ok | :error, iodata() | :file.posix()} | iodata() | String.t()) :: MP4.t()
  def open!({:ok, <<data :: binary>>}) do
    #
  end

  def open!({:error, error_code}) do
    {:error, %MP4{valid?: false}}
  end

  def open!(<<data :: binary>>) do
    # will a string filepath string be interpreted as binary?
  end

  def open!(filepath) when is_binary(filepath) do
    # will a string filepath string be interpreted as binary?
  end

  def open!(_) do
    #
  end

  @spec handle(String.t() | iodata()) :: Handler.t()
  def handle(filepath) when is_binary(filepath) do
    #
  end

  def handle(<<data :: binary>>) do
    #
  end
end
