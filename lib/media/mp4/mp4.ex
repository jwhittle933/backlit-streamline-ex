defmodule Streamline.Media.MP4 do
  @moduledoc """
  MP4 base module for mp4 parsing and handling
  """
  alias __MODULE__
  alias Streamline.Result
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

  @spec open(iodata() | String.t() | IO.device()) :: Result.t()
  def open(<<size :: size(32), ?f, ?t, ?y, ?p, data :: binary>>) do
    Result.ok(%MP4{})
  end

  def open(filepath) when is_binary(filepath) do
    filepath
    |> File.open()
    |> Result.expect("Could not open file")
    |> parse_file()
    |> Result.ok()
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

  @spec parse_file(IO.device() | iodata()) :: t
  defp parse_file(device) do
    %MP4{d: device}
  end
end
