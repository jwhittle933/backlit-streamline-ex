defmodule Streamline.Media.MP4.Box.Stsd do
  @moduledoc """
  `stsd` BMFF Box (Sample Table Description)

  The sample description table gives detailed information about the coding type used,
  and any initialization information needed for that coding.

  The information stored in the sample description box after the entry‐count is both track‐type
  specific as documented here, and can also have variants within a track type (e.g. different
  codings may use different specific information after some common fields, even within a video track).

  Which type of sample entry form is used is determined by the media handler, using a suitable form,
  such as one defined in clause 12, or defined in a derived specification, or registration.

  Multiple descriptions may be used within a track.
      Note: Though the count is 32 bits, the number of items
      is usually much fewer, and is restricted by the fact
      that the reference index in the sample table is only 16 bits

  If the ‘format’ field of a SampleEntry is unrecognized, neither the sample description itself, nor
  the associated media samples, shall be decoded.
      Note: The definition of sample entries specifies boxes in a
      particular order, and this is usually also followed in derived
      specifications. For maximum compatibility, writers should construct
      files respecting the order both within specifications and as
      implied by the inheritance, whereas readers should be prepared to
      accept any box order.

  All string fields shall be null‐terminated, even if unused. “Optional” means there is at least one null byte.

  Entries that identify the format by MIME type, such as a TextSubtitleSampleEntry, TextMetaDataSampleEntry, or
  SimpleTextSampleEntry, all of which contain a MIME type, may be used to identify the format of streams for
  which a MIME type applies. A MIME type applies if the contents of the string in the optional configuration
  box (without its null termination), followed by the contents of a set of samples, starting with a sync sample
  and ending at the sample immediately preceding a sync sample, are concatenated in their entirety, and the result
  meets the decoding requirements for documents of that MIME type. Non‐sync samples should be used only if that
  format specifies the behaviour of ‘progressive decoding’, and then the sample times indicate when the results
  of such progressive decoding should be presented (according to the media type).
        Note: The samples in a track that is all sync samples are
        therefore each a valid document for that MIME type.

  In some classes derived from SampleEntry, namespace and schema_location are used both to identify the XML
  document content and to declare “brand” or profile compatibility. Multiple namespace identifiers indicate
  that the track conforms to the specification represented by each of the identifiers, some of which may
  identify supersets of the features present. A decoder should be able to decode all the namespaces in
  order to be able to decode and present correctly the media associated with this sample entry.
        Note Additionally, namespace identifiers may represent performance
        constraints, such as limits on document size, font size, drawing rate,
        etc., as well as syntax constraints such as features that are not
        permitted or ignored.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t :: %Stsd {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               entry_count: Binary.u32(),
               entries: [%{format: Binary.u32(), data_reference_index: Binary.u16()}],
               children: children()
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    entry_count: 0,
    entries: [],
    children: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          entry_count :: size(32) - unsigned - big - integer,
          rest :: binary
        >>
      ) do
    %Stsd{info: i, version: v, flags: flags, entry_count: entry_count}
  end

  defp write_entries(
         %Stsd{entry_count: ec, entries: entries} = s,
         <<
#           format :: size(32) - unsigned - big - integer,
           _ :: size(8),
           _ :: size(8),
           _ :: size(8),
           _ :: size(8),
           _ :: size(8),
           _ :: size(8),
           dref_index :: size(16) - unsigned - big - integer,
           rest :: binary
         >>
       )
       when length(entries) < ec do
    %Stsd{s | entries: entries ++ [%{data_reference_index: dref_index}]}
    |> write_entries(rest)
  end

  defp write_entries(%Stsd{} = s, <<rest :: binary>>), do: {s, rest}
end
