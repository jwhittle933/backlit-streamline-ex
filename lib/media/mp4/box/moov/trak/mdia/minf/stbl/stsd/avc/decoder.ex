defmodule Streamline.Media.MP4.Box.Avc.Decoder do
  @moduledoc """
  `AVCDecoderConfiguration` Box

  This record contains the size of the length field used in each sample to indicate the length of its
  contained NAL units as well as the initial parameter sets. This record is externally framed (its
  size must be supplied by the structure which contains it).

  This record contains a version field. This version of the specification defines version 1 of this
  record. Incompatible changes to the record will be indicated by a change of version number. Readers
  must not attempt to decode this record or the streams to which it applies if the version number is
  unrecognised.

  Compatible extensions to this record will extend it and will not change the configuration version
  code. Readers should be prepared to ignore unrecognised data beyond the definition of the data they
  understand (e.g. after the parameter sets in this specification).

  When used to provide the configuration of:
      - a parameter set elementary stream,
      - a video elementary stream used in conjunction with a parameter set elementary stream,

  the configuration record shall contain no sequence or picture parameter sets (numOfSequenceParameterSets
  and numOfPictureParameterSets shall both have the value 0).


  When used to provide the configuration of a video elementary stream used without a parameter set
  elementary stream, the configuration record may or may not contain sequence or picture parameter
  sets (numOfSequenceParameterSets or numOfPictureParameterSets may or may not have the value 0).

  The values for AVCProfileIndication, AVCLevelIndication, and the flags which indicate profile
  compatibility must be valid for all parameter sets of the stream described by this record. The
  level indication must indicate a level of capability equal to or greater than the highest level
  indicated in the included parameter sets; each profile compatibility flag may only be set if all
  the included parameter sets set that flag. The profile indication must indicate a profile to which
  the entire stream associated with this configuration record conforms. If the sequence parameter
  sets are marked with different profiles, and the relevant profile compatibility flags are all zero,
  then the stream may need examination to determine which profile, if any, the entire stream conforms
  to. If the entire stream is not examined, or the examination reveals that there is no profile to
  which the entire stream conforms, then the stream must be split into two or more sub-streams with
  separate configuration records in which these rules can be met.

  Explicit indication can be provided in the AVC Decoder Configuration Record about the chroma format
  and bit depth used by the avc video elementary stream. The parameter ‘chroma_format_idc’ present in
  the sequence parameter set in AVC specifies the chroma sampling relative to the luma sampling.
  Similarly the parameters ‘bit_depth_luma_minus8’ and ‘bit_depth_chroma_minus8’ in the sequence
  parameter set specify the bit depth of the samples of the luma and chroma arrays. The values of
  chroma_format_idc, bit_depth_luma_minus8’ and ‘bit_depth_chroma_minus8’ must be identical in all
  sequence parameter sets in a single AVC configuration record. If two sequences differ in any of these
  values, two different AVC configuration records will be needed. If the two sequences differ in color
  space indications in their VUI information, then two different configuration records are also required.

  The array of sequence parameter sets, and the array of picture parameter sets, may contain SEI messages
  of a ‘declarative’ nature, that is, those that provide information about the stream as a whole. An
  example of such an SEI is a user-data SEI. Such SEIs may also be placed in a parameter set elementary
  stream. NAL unit types that are reserved in ISO/IEC 14496-10 and in this specification may acquire a
  definition in future, and readers should ignore NAL units with reserved values of NAL unit type when
  they are present in these arrays.
    NOTE - this ‘tolerant’ behaviour is designed so that errors are not raised,
    allowing the possibility of backwards-compatible extensions to these arrays
    in future specifications.

  When Sequence Parameter Set Extension NAL units occur in this record in profiles other than those
  indicated for the array specific to such NAL units (profile_idc not equal to any of 100, 110, 122,
  144), they should be placed in the Sequence Parameter Set Array.
  """
  alias  __MODULE__
  alias Streamline.Binary

  @type t :: %Decoder{
               version: Binary.u8(),
               # `profile_idc` contains the profile code as defined in ISO/IEC 14496-10.
               profile_idc: Binary.u8(),
               # `profile_compatibility` is a byte defined exactly the same as the byte which occurs between the
               # `profile_idc` and `level_idc` in a sequence parameter set (SPS), as defined in ISO/IEC 14496-10.
               profile_compatibility: Binary.u8(),
               # `level_idc` contains the level code as defined in ISO/IEC 14496-10.
               level_idc: Binary.u8(),
               # lengthSizeMinusOne indicates the length in bytes of the NALUnitLength field in an AVC
               # video sample or AVC parameter set sample of the associated stream minus one. For example,
               # a size of one byte is indicated with a value of 0. The value of this field shall be one
               # of 0, 1, or 3 corresponding to a length encoded with 1, 2, or 4 bytes, respectively.
               length_size_minus_one: non_neg_integer(),
               # numOfSequenceParameterSets indicates the number of SPSs that are used as the initial set
               # of SPSs for decoding the AVC elementary stream.
               num_seq_param_sets: non_neg_integer(),
               seq_param_sets: [%{
                 # sequenceParameterSetLength indicates the length in bytes of the SPS NAL unit as defined
                 # in ISO/ IEC 14496-10.
                 seq_param_set_length: Binary.u16(),
                 # sequenceParameterSetNALUnit contains a SPS NAL unit, as specified in ISO/IEC 14496-10.
                 # SPSs shall occur in order of ascending parameter set identifier with gaps being allowed.
                 seq_param_set_nal_unit: iodata(),
                 # bit(8*seq_param_set_length)
               }],
               # numOfPictureParameterSets indicates the number of picture parameter sets (PPSs) that are
               # used as the initial set of PPSs for decoding the AVC elementary stream.
               num_picture_param_sets: non_neg_integer(),
               picture_param_sets: [%{
                 # pictureParameterSetLength indicates the length in bytes of the PPS NAL unit as defined
                 # in ISO/ IEC 14496-10.
                 picture_param_set_length: Binary.u16(),
                 # pictureParameterSetNALUnit contains a PPS NAL unit, as specified in ISO/IEC 14496-10.
                 # PPSs shall occur in order of ascending parameter set identifier with gaps being allowed.
                 picture_param_set_nal_unit: iodata(),
                 # bit(8*seq_param_set_length)
               }],
               chroma_format: non_neg_integer(),
               bit_depth_luma_minus8: non_neg_integer(),
               bit_depth_chroma_minus8: non_neg_integer(),
               num_seq_param_sets_ext: Binary.u8(),
               seq_param_sets_ext: [%{
                 seq_param_set_ext_length: Binary.u16(),
                 seq_param_set_ext_nal_unit: iodata(),
                 # bit(8*seq_param_set_length)
               }]
             }

  defstruct [
    version: 0,
    profile_idc: nil,
    profile_compatibility: nil,
    level_idc: nil,
    length_size_minus_one: nil,
    num_seq_param_sets: 0,
    seq_param_sets: [],
    num_picture_param_sets: 0,
    picture_param_sets: [],
    chroma_format: 0,
    bit_depth_luma_minus8: 0,
    bit_depth_chroma_minus8: 0,
    num_seq_param_sets_ext: 0,
    seq_param_sets_ext: []
  ]

  def write(
        <<
          v :: 8,
          profile_idc :: 8,
          profile_compatibility :: 8,
          level_idc :: 8,
          _ :: size(6),
          len_size_min_one :: size(2),
          _ :: size(3),
          num_seq_param_sets :: size(5),
          rest :: binary
        >>
      ) do
    %Decoder{
      version: v,
      profile_idc: profile_idc,
      profile_compatibility: profile_compatibility,
      level_idc: level_idc,
      length_size_minus_one: len_size_min_one,
      num_seq_param_sets: num_seq_param_sets
    }
    |> write(:seq, rest)
  end

  def write(
        %Decoder{ num_seq_param_sets: num_sps, seq_param_sets: sps } = d,
        :seq,
        <<
          seq_param_length :: size(16) - unsigned - big - integer,
          rest :: binary
        >>
      ) when length(sps) < num_sps do
    { unit, rest } = extract(rest, seq_param_length)

    %Decoder{
      d |
      seq_param_sets: sps ++ [
        %{
          seq_param_set_len: seq_param_length,
          seq_param_set_nal_unit: unit
        }
      ]
    }
    |> write(:seq, rest)
  end

  def write(
        %Decoder{ } = d,
        :seq,
        << num_pic_param_length :: size(8) - unsigned - big - integer, rest :: binary >>
      ) do
    write(%Decoder{ d | num_picture_param_sets: num_pic_param_length }, :pic, rest)
  end

  def write(
        %Decoder{ num_picture_param_sets: num_pps, picture_param_sets: pps } = d,
        :pic,
        <<
          pic_param_length :: size(16) - unsigned - big - integer,
          rest :: binary
        >>
      ) when length(pps) < num_pps do
    { unit, rest } = extract(rest, pic_param_length)

    %Decoder{
      d |
      picture_param_sets: pps ++ [
        %{
          pic_param_set_len: pic_param_length,
          pic_param_set_nal_unit: unit
        }
      ]
    }
    |> write(:pic, rest)
  end

  def write(%Decoder{ } = d, :pic, << rest :: binary >>) do
    write(d, :idc, rest)
  end

  @seq_ext [100, 110, 122, 144]
  def write(
        %Decoder{ profile_idc: idc } = d,
        :idc,
        <<
          _ :: size(6),
          chroma :: size(2),
          _ :: size(5),
          bit_depth_luma :: size(3),
          _ :: size(5),
          bit_depth_chroma :: size(3),
          num_seq_param_ext :: size(8),
          rest :: binary
        >>
      ) when idc in @seq_ext do
    %Decoder{
      d |
      chroma_format: chroma,
      bit_depth_luma_minus8: bit_depth_luma,
      bit_depth_chroma_minus8: bit_depth_chroma,
      num_seq_param_sets_ext: num_seq_param_ext
    }
    |> write(:ext, rest)
  end

  def write(%Decoder{ } = d, :idc, _), do: d

  def write(
        %Decoder{ num_seq_param_sets_ext: num_seq_param_ext, seq_param_sets_ext: exts } = d,
        :ext,
        <<
          length :: size(16) - unsigned - big - integer,
          rest :: binary
        >>
      ) when length(exts) < num_seq_param_ext do
    { unit, rest } = extract(rest, length)

    %Decoder{
      d |
      seq_param_sets_ext: exts ++ [
        %{
          seq_param_set_ext_length: length,
          seq_param_set_ext_nal_unit: unit,
        }
      ]
    }
    |> write(:ext, rest)
  end

  def write(%Decoder{ } = d, :ext, _), do: d

#  def write(d, _, _), do: d

  defp extract(<< data :: binary >>, size) do
    << part :: bytes - size(size), rest :: binary >> = data
    { part, rest }
  end

  defp bytes(size), do: size * 8
end
