defmodule Streamline.Media.MP4.Box.Colr do
  @moduledoc """
  `colr` Color Information Box

  Color information may be supplied in one or more ColorInformationBoxes placed in a VisualSampleEntry.
  These should be placed in order in the sample entry starting with the most accurate (and potentially
  the most difficult to process), in progression to the least. These are advisory and concern rendering
  and color conversion, and there is no normative behaviour associated with them; a reader may choose
  to use the most suitable. A ColorInformationBox with an unknown colour type may be ignored.

  If used, an ICC profile may be a restricted one, under the code ‘rICC’, which permits simpler processing.
  That profile shall be of either the Monochrome or Three‐Component Matrix‐Based class of input profiles,
  as defined by ISO 15076‐1. If the profile is of another class, then the ‘prof’ indicator must be used.

  If color information is supplied in both this box, and also in the video bitstream, this box takes
  precedence, and over‐rides the information in the bitstream.
      NOTE: When an ICC profile is specified, SMPTE RP 177 “Derivation of Basic Television Color Equations”
      may be of assistance if there is a need to form the Y'CbCr to R'G'B' conversion matrix for the color
      primaries described by the ICC profile.
  """
  alias __MODULE__
  alias Streamline.Binary

  @type t :: %Colr{
               color_type: String.t(),
               nlcx: %{
                 color_primaries: Binary.u16(),
                 transfer_characteristics: Binary.u16(),
                 matrix_coefficients: Binary.u16(),
                 full_range_flag: boolean,
                 reserved: << _ :: 7 >>,
               },
               rICC: %{
                 # ICC_profile: an ICC profile as defined in ISO 15076‐1 or ICC.1:2010 is supplied.
                 ICC_profile: %{ }
               },
               prof: %{
                 ICC_profile: %{ }
               },
             }

  defstruct [:color_type, :nlcx, :rICC, :prof]
end
