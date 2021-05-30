defmodule Streamline.Media.MP4.Box.Pasp do
  @moduledoc """
  `pasp` Pixel Aspect Ratio Box

  The pixel aspect ratio and clean aperture of the video may be specified using the ‘pasp’ and ‘clap’ sample
  entry boxes, respectively. These are both optional; if present, they over‐ride the declarations (if any)
  in structures specific to the video codec, which structures should be examined if these boxes are
  absent. For maximum compatibility, these boxes should follow, not precede, any boxes defined in or required
  by derived specifications.

  In the PixelAspectRatioBox, hSpacing and vSpacing have the same units, but those units are unspecified: only
  the ratio matters. hSpacing and vSpacing may or may not be in reduced terms, and they may reduce to 1/1.
  Both of them must be positive.

  They are defined as the aspect ratio of a pixel, in arbitrary units. If a pixel appears H wide and V tall,
  then hSpacing/vSpacing is equal to H/V. This means that a square on the display that is n pixels tall needs
  to be n*vSpacing/hSpacing pixels wide to appear square.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Info

  @type t :: %Pasp{
               info: Info.t(),
               # hSpacing, vSpacing: define the relative width and height of a pixel
               h_spacing: Binary.u32(),
               v_spacing: Binary.u32(),
             }

  defstruct [info: nil, h_spacing: 0, v_spacing: 0]

  def write(%Info{ } = i, << h :: size(32) - unsigned - big - integer, v :: size(32) - unsigned - big - integer >>) do
    %Pasp{ info: i, h_spacing: h, v_spacing: v }
  end
end
