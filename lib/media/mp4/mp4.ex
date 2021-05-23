defmodule Streamline.Media.MP4 do
  @moduledoc """
  MP4 base module for mp4 parsing and handling
  """
  alias __MODULE__
  alias MP4.{Find, Handler, Box}
  alias Streamline.Result
  alias Streamline.IO.Reader
  alias Box.Info

  @type t() :: %MP4 {
                 children: [term()],
                 valid?: boolean,
                 d: Reader.t() | iodata(),
                 open?: boolean | :unknown
               }

  defstruct [
    children: [],
    valid?: :unknown,
    d: nil,
    open?: false
  ]

  @spec open(String.t() | t() | IO.device()) :: Result.t()
  def open(filepath) when is_binary(filepath) do
    filepath
    |> File.open()
    |> Result.expect("Could not open #{filepath}")
    |> (&%MP4{d: Reader.new(&1), open?: true, children: [], valid?: :unknown}).()
    |> Result.wrap()
  end

  def open(%MP4{} = m) do
    m
  end

  def open(device) do
    Result.wrap(
      %MP4{
        d: %Reader{
          r: device
        }
      }
    )
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

  @spec close(t()) :: t()
  def close(%MP4{d: nil} = m), do: m
  def close(
        %MP4{
          d: %Reader{
            r: nil
          }
        } = m
      ), do: m

  def close(
        %MP4{
          d: %Reader{
            r: device
          }
        } = m
      ) do
    File.close(device)

    %MP4{m | open?: false}
  end

  @doc """
  read_all consumes the IO.device and parses
  all boxes

  TODO: clean up duplication between arity
  """
  @spec read_all(t() | IO.device() | String.t()) :: t()
  def read_all(
        %MP4{
          d: %Reader{
            r: reader
          }
        } = m
      ) do
    reader
    |> IO.binread(:all)
    |> Box.read()
    |> (&%MP4{m | children: &1}).()
    |> close()
  end

  def read_all(filepath) when is_binary(filepath) do
    filepath
    |> File.open()
    |> Result.expect("Could not open #{filepath}")
    |> IO.binread(:all)
    |> Box.read()
    |> (&%MP4{children: &1}).()
    |> close()
  end

  def read_all(device) do
    device
    |> IO.binread(:all)
    |> Box.read()
    |> (&%MP4{children: &1}).()
    |> close()
  end

  defdelegate find(mp4, key), to: Find
end
