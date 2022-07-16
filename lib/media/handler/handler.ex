defmodule Streamline.Media.Handler do
  @moduledoc """
  Handler for lazy parsing and lookup of media formats

  The handler parses the binary information into a registry
  of offsets and sizes

  Rather than reading the data into structs, the Handler acts
  as the data interface to the binary stream. The data for each
  box will be unknown until access through the handler

  For example, the `ftyp` box:
    %MP4{children: [%Ftyp{}]}
    %Handler{raw: << ... >>, registry: [%Info{type: "ftyp", offset: 0, size: 32}]}

  Appropriate function will be provided here and in MP4 to navigate between
  the two read paradigms
  """
  alias __MODULE__
  alias Streamline.Result
  alias Streamline.IO.Reader
  alias Streamline.Media.MP4.Box.Info

  @type t() :: %Handler{
                 raw: [non_neg_integer()],
                 registry: [
                   key: Range.t() | Info.t()
                 ],
               }

  defstruct [raw: nil, registry: []]

  @valid_opts [:consume, :deep]
  def handle(reader, opts \\ [])
  def handle(filepath, opts) when is_binary(filepath) do
    filepath
    |> File.open()
    |> Result.expect("Could not open #{filepath}")
    |> Reader.new()
    |> Reader.read(8)
    |> into_handler()
  end

  def handle(device, opts) do
    device
    |> Reader.new()
    |> Reader.read(8)
    |> into_handler()
  end

  def into_handler(r, h \\ %Handler{ }, offset \\ 0)
  def into_handler(%Reader{ last_read: nil }, h, _off), do: h
  def into_handler(%Reader{ last_read: << >> }, h, _off), do: h
  def into_handler(%Reader{ last_read: :eof }, h, _off), do: h
  def into_handler(
        %Reader{ last_read: << size :: size(32) - unsigned - big - integer, name :: bytes - size(4) >> } = r,
        %Handler{ registry: registry } = h,
        off
      ) do
    r
    |> Reader.seek(size+off)
    |> Reader.read(8)
    |> into_handler(%Handler{ h | registry: registry ++ [{ :"#{name}", Range.new(off, off+size) }] }, off + size)
  end
end
