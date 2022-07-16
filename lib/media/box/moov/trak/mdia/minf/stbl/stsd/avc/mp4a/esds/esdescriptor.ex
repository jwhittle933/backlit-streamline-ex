defmodule Streamline.Media.MP4.Box.Esds.ESDescriptor do
  @moduledoc """
  `esds` ESDescriptor
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Esds.{ DecoderConfigDescriptor }

  @type t :: %ESDescriptor{
               esid: Binary.u16(),
               stream_dependence_flag: << _ :: 1 >>,
               url_flag: << _ :: 1 >>,
               stream_priority: << _ :: 1 >>,
               ocr_stream_flag: Binary.i8(),
               depends_on_esid: Binary.u16(),
               url_length: Binary.u8(),
               url_string: String.t(),
               ocr_es_id: Binary.u16(),
               decoder: DecoderConfigDescriptor.t(),
             }

  defstruct [
    esid: 0,
    stream_dependence_flag: 0,
    url_flag: 0,
    stream_priority: 0,
    ocr_stream_flag: 0,
    depends_on_esid: 0,
    url_length: 0,
    url_string: "",
    ocr_es_id: 0,
    decoder: nil
  ]

  def write(
        <<
          esid :: size(16) - unsigned - big - integer,
          stream_dep_flag :: 1,
          url_flag :: 1,
          ocr_flag :: 1,
          stream_priority :: size(5) - unsigned - big - integer,
          rest :: binary,
        >>
      ) do
    %ESDescriptor{
      esid: esid,
      stream_dependence_flag: Binary.bool(stream_dep_flag),
      url_flag: Binary.bool(url_flag),
      ocr_stream_flag: Binary.bool(ocr_flag),
      stream_priority: stream_priority,
    }
    |> write(:stream, rest)
  end

  def write(
        %ESDescriptor{ stream_dependence_flag: true } = e,
        :stream,
        <<
          dep_esid :: size(16) - unsigned - big - integer,
          rest :: binary
        >>
      ) do
    %ESDescriptor{ e | depends_on_esid: dep_esid }
    |> write(:url, rest)
  end

  def write(%ESDescriptor{ } = e, :stream, << rest :: binary >>), do: write(e, :url, rest)

  def write(
        %ESDescriptor{ url_flag: true } = e,
        :url,
        <<
          url_length :: size(16) - unsigned - big - integer,
          rest :: binary
        >>
      ) do
    << url :: bytes - size(url_length), rest :: binary >> = rest

    %ESDescriptor{ e | url_length: url_length, url_string: url }
    |> write(:ocr, rest)
  end

  def write(%ESDescriptor{ } = e, :url, << rest :: binary >>), do: write(e, :ocr, rest)

  def write(
        %ESDescriptor{ ocr_stream_flag: true } = e,
        :ocr,
        <<
          ocr_es_id :: size(16) - unsigned - big - integer,
          rest :: binary
        >>
      ) do
    { %ESDescriptor{ e | ocr_es_id: ocr_es_id }, rest }
  end

  def write(%ESDescriptor{ } = e, :ocr, << rest :: binary >>) do
    { decoder, rest } = DecoderConfigDescriptor.write(rest)

    { %ESDescriptor{ e | decoder: decoder }, rest }
  end
end
