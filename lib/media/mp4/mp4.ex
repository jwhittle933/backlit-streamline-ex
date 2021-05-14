defmodule Streamline.Media.MP4 do
  @moduledoc """
  MP4 base module for mp4 parsing and handling
  """
  alias __MODULE__
  alias Streamline.Result
  alias Streamline.IO.Reader
  alias Streamline.Media.MP4.Handler
  alias Streamline.Media.MP4.Box
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %MP4 {
                 size: integer,
                 children: [term()],
                 valid?: boolean,
                 d: Reader.t() | iodata(),
                 open?: boolean
               }

  defstruct [:size, :children, :valid?, :d, :open?]

  @spec open(String.t() | t() | IO.device()) :: Result.t()
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

  def open(%MP4{} = m) do
    m
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

  @spec close(IO.device()) :: t()
  def close(%MP4{d: device} = m) do
    File.close(device)

    %MP4{m | open?: false}
  end

  @doc """
  parse_file consumes the IO.device
  """
  @spec parse_file(IO.device()) :: t
  defp parse_file(device) do
    %MP4{d: Reader.new(device), open?: true, children: []}
    |> read_boxes()
  end

  @spec read_boxes(t()) :: t()
  def read_boxes(
        %MP4{
          d: %Reader{
            last_read: :eof
          }
        } = m
      ), do: close(m)

  def read_boxes(%MP4{d: %Reader{last_read: nil} = reader, children: c} = m) do
    m
    |> read_header()
    |> read_boxes()
  end

  def read_boxes(
        %MP4{
          size: size,
          d: %Reader{
            last_read: <<data :: binary>>
          } = reader,
          children: c
        } = m
      ) do
    info = Info.parse(data)
    r = Reader.read(reader, info.size - info.header_size)
    box = Box.write_box(info, r.last_read)

    %MP4{m | children: c ++ [box], size: size + info.size}
    |> read_header()
    |> read_boxes()
  end

  def read_header(%MP4{d: reader, children: c} = m) do
    reader
    |> Reader.read(8)
    |> Reader.cursor()
    |> (&apply_reader(m, &1)).()
  end

  @spec apply_reader(t(), Reader.t()) :: t()
  defp apply_reader(%MP4{children: c, valid?: v, open?: o, size: s}, reader) do
    %MP4{d: reader, children: c, valid?: v, open?: o, size: s}
  end
end
