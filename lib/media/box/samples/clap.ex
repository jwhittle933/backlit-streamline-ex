defmodule Streamline.Media.MP4.Box.Clap do
  @moduledoc """
  `clap` Clean Aperture Box

  There are notionally four values in the CleanApertureBox. These parameters are represented as a
  fraction N/D. The fraction may or may not be in reduced terms. We refer to the pair of parameters
  fooN and fooD as foo. For horizOff and vertOff, D must be positive and N may be positive or negative.
  For cleanApertureWidth and cleanApertureHeight, both N and D must be positive.
      NOTE: These are fractional numbers for several reasons. First, in some
      systems the exact width after pixel aspect ratio correction is integral,
      not the pixel count before that correction. Second, if video is resized
      in the full aperture, the exact expression for the clean aperture may
      not be integral. Finally, because this is represented using centre and
      offset, a division by two is needed, and so half‐values can occur.

  Considering the pixel dimensions as defined by the VisualSampleEntry width and height. If picture
  centre of the image is at pcX and pcY, then horizOff and vertOff are defined as follows:

        pcX = horizOff + (width  - 1)/2
        pcY = vertOff  + (height - 1)/2

  Typically, horizOff and vertOff are zero, so the image is centred about the picture centre.

  The leftmost/rightmost pixel and the topmost/bottommost line of the clean aperture fall at:

        pcX ± (cleanApertureWidth - 1)/2
        pcY ± (cleanApertureHeight - 1)/2;
  """
  alias  __MODULE__
  alias Streamline.Binary

  @type t :: %Clap{
               # `clean_aperture_width_n`, `clean_aperture_width_d`: a fractional number which defines the exact
               # clean aperture width, in counted pixels, of the video image
               clean_aperture_width_n: Binary.u32(),
               clean_aperture_width_d: Binary.u32(),
               # `clean_aperture_height_n`, `clean_aperture_height_d`: a fractional number which defines the
               # exact clean aperture height, in counted pixels, of the video image
               clean_aperture_height_n: Binary.u32(),
               clean_aperture_height_d: Binary.u32(),
               # `horiz_offset_n`, `horiz_off_d`: a fractional number which defines the horizontal offset of clean
               # aperture centre minus (width‐1)/2. Typically 0.
               horiz_offset_n: Binary.u32(),
               horiz_offset_d: Binary.u32(),
               vert_offset_n: Binary.u32(),
               vert_offset_d: Binary.u32(),
             }

  defstruct [
    clean_aperture_width_n: 0,
    clean_aperture_width_d: 0,
    clean_aperture_height_n: 0,
    clean_aperture_height_d: 0,
    horiz_offset_n: 0,
    horiz_offset_d: 0,
    vert_offset_n: 0,
    vert_offset_d: 0,
  ]
end
