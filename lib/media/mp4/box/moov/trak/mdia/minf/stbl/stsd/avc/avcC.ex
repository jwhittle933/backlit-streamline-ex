defmodule Streamline.Media.MP4.Box.AvcC do
  @moduledoc """
  `avcC` AVC Decoder Configuration Box

  This atom contains an MPEG-4 decoder configuration atom. This is a required extension to the video sample
  description for H.264 video. This extension appears in video sample descriptions only when the codec type
  is ‘avc’

  An AVC visual sample entry shall contain an AVC Configuration Box, as defined below. This includes an
  AVCDecoderConfigurationRecord, as defined in 5.3.3.1

  An optional MPEG4BitRateBox may be present in the AVC visual sample entry to signal the bit rate information
  of the AVC video stream. Extension descriptors that should be inserted into the Elementary Stream Descriptor,
  when used in MPEG-4, may also be present.

  Multiple sample entries may be used, as permitted by the ISO Base Media File Format specification, to indicate
  sections of video that use different configurations or parameter sets.

  The sample entry name ‘avc1’ or 'avc3' may only be used when the stream to which this sample entry applies is
  a compliant and usable AVC stream as viewed by an AVC decoder operating under the configuration (including profile
  and level) given in the AVCConfigurationBox. The file format specific structures that resemble NAL units (see
  Annex A) may be present but must not be used to access the AVC base data; that is, the AVC data must not be
  contained in Aggregators (though they may be included within the bytes referenced by the additional_bytes field)
  nor referenced by Extractors.

  The sample entry name ‘avc2’ or 'avc4' may only be used when Extractors or Aggregators (Annex A) are required
  to be supported, and an appropriate Toolset is required (for example, as indicated by the file-type brands).
  This sample entry type indicates that, in order to form the intended AVC stream, Extractors must be replaced
  with the data they are referencing, and Aggregators must be examined for contained NAL Units. Tier grouping
  may be present.
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.{ Info, Avc.Decoder }

  @type t :: %AvcC {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               decoder: Decoder.t()
             }

  defstruct [
    info: nil,
    decoder: nil
  ]

  def write(%Info{ } = i, << data :: binary >>) do
    %AvcC{
      info: i,
      decoder: Decoder.write(data)
    }
  end
end
