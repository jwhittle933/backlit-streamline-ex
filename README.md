# Backlit StreamlineEX

Streamline is a media parsing and streaming library on the Backlit platform.

## BMFF Boxes
The ISO/IEC spec defines `boxes` or `atoms` that make up most media formats. Two documents are in the `docs` directory for help in this area, as well as two small `.mp4` in `examples` for testing. An abbreviated example of the box structure looks like this:
```
[mp4] boxes=4
[ftyp] offset=0, size=32, header=8, majorbrand=isom, minorversion=512, compatiblebrands=[isom iso2 avc1 mp41]
[free] hex=0x66726565, offset=32, size=8, header=8, data=
[mdat] hex=0x6d646174, offset=40, size=6402, header=8
[moov] offset=6442, size=1836, header=8, boxes=4
->[mvhd] offset=0, size=108, header=8, version=0, flags=0, creation=0, modification=0, timescale=1000, duration=1024, rate=0, volume=0, matrix=[65536 16777217 256 65536 16777216 0 0 0 0], nexttrackid=0
->[trak] offset=108, size=743, header=8, boxes=3
--->[tkhd] offset=0, size=92, header=8, version=0, flags=3, creation=0, modification=0
--->[edts] offset=92, size=36, header=8, boxes=1
----->[elst] offset=0, size=28, header=8, version=0, flags=0, entry_count=1, entries=[media_rate_fraction=0, media_rate=1, media_time=2048, segment_duration=1000]
--->[mdia] offset=128, size=607, header=8, boxes=3
----->[mdhd] offset=0, size=32, header=8, version=0, flags=0, creation=0, modification=0, timescale=10240, duration=10240, pad=false, language=eng
----->[hdlr] offset=32, size=44, header=8, version=0, flags=0, predefined=0, handlertype=vide, name=VideoHandle
----->[minf] offset=76, size=523, header=8, boxes=3
------->[vmhd] offset=0, size=20, header=8
------->[dinf] offset=20, size=36, header=8, boxes=1
--------->[dref] offset=0, size=28, header=8, version=0, flags=0, entry_count=1
----------->[url ] offset=0, size=12, header=8, version=0, flags=1, location=
------->[stbl] offset=56, size=459, header=8, boxes=7, status=INCOMPLETE
--------->[stsd] offset=0, size=167, header=8, version=0, flags=0, entry_count=1, entries=[] status=INCOMPLETE
----------->[avc1] offset=0, size=151, header=8, data_ref_index=1, width=320, height=180, horiz_res=4718592, vert_res=4718592, frame_count=1, compressor=, depth=24, boxes=2
------------->[avcC] offset=0, size=49, header=8, version=1, profile=100, profile_compat=0, level=12, length_minus_1=225, seq_param_sets_len=25
------------->[pasp] offset=49, size=16, header=8, horiz_spacing=1, vert_spacing=1
--------->[stts] offset=167, size=24, header=8
--------->[stss] offset=191, size=20, header=8
--------->[ctts] offset=211, size=88, header=8
--------->[stsc] offset=299, size=40, header=8, version=0, flags=0, entry_count=2, entries=[{first_chunk=1, samples_per_chunk=2, sample_description_index=1}, {first_chunk=2, samples_per_chunk=1, sample_description_index=1}]
--------->[stsz] offset=339, size=60, header=8
--------->[stco] offset=399, size=52, header=8
->[trak] offset=851, size=844, header=8, boxes=3
--->[tkhd] offset=0, size=92, header=8, version=0, flags=3, creation=0, modification=0
--->[edts] offset=92, size=36, header=8, boxes=1
----->[elst] offset=0, size=28, header=8, version=0, flags=0, entry_count=1, entries=[media_rate_fraction=0, media_rate=1, media_time=1024, segment_duration=1000]
--->[mdia] offset=128, size=708, header=8, boxes=3
----->[mdhd] offset=0, size=32, header=8, version=0, flags=0, creation=0, modification=0, timescale=44100, duration=45124, pad=false, language=eng
----->[hdlr] offset=32, size=44, header=8, version=0, flags=0, predefined=0, handlertype=soun, name=SoundHandle
----->[minf] offset=76, size=624, header=8, boxes=3
------->[smhd] offset=0, size=16, header=8, version=0, flags=0, balance=0
------->[dinf] offset=16, size=36, header=8, boxes=1
--------->[dref] offset=0, size=28, header=8, version=0, flags=0, entry_count=1
----------->[url ] offset=0, size=12, header=8, version=0, flags=1, location=
------->[stbl] offset=52, size=564, header=8, boxes=7
--------->[stsd] offset=0, size=106, header=8, version=0, flags=0, entry_count=1, entries=[]
----------->[mp4a] offset=0, size=90, header=8, boxes=0, data_ref_index=1 
------------->[esds] offset=0, size=54, header=8
--------->[stts] offset=106, size=48, header=8
--------->[stsc] offset=154, size=100, header=8, version=0, flags=0, entry_count=7, entries=[{1, 1, 1}, {2, 4, 1}, {3, 5, 1}, {4, 4, 1}, {6, 5, 1}, {7, 4, 1}, {9, 13, 1}]
--------->[stsz] offset=254, size=196, header=8
--------->[stco] offset=450, size=52, header=8
--------->[sgpd] offset=502, size=26, header=8
--------->[sbgp] offset=528, size=28, header=8
->[udta] offset=1695, size=133, header=8
```
The process for parsing this information starts with reading the header info for each box, which is normally the first 8 bytes of every box: the first 32 bits are the box size, the second 32 bits are the box type. In order to reader the rest of the box data, you need to consume the next `size - box header size` of the byte stream. Alternatively, you could eager-read the info for the boxes by only reading the size (32 bits) and jump from box-start to box-start consuming the data in-between. How these are represented in data structures is fairly straight forward, so long as you can convert the byte stream to the box specification. Additionally, some boxes do not contain data themselves, but wrap `child` boxes that contain data or other child boxes.

## API (RFC)

The api for StreamlineEX should be elegant and straightforward, without much work needed from the consumber of the
library. In other words, the only thing a consumer should need to do is open/upload a file or pass in a bitstream that
is known to be media encoded. The `handles` of the api should do the rest. Example:
```elixir
defmodule Example do
  alias Streamline.Media.MP4
  alias MP4.Box.{Info, Ftype, Moov}

  def open(iodevice) do
    mp4 =
      "../path/to/some/file.mp4"
      |> File.open!()
      |> MP4.open(f)

    %MP4{
      size: s,
      children: [
        %Ftype{info: %Info{type: "ftype", offset: 0, size: 32}},
        %Moov{info: %Info{type: "moov", offset: 32, size: 6542}}
      ]
    } = mp4
  end
  
  def open(file_path) do
    mp4 = MP4.open("../path/to/some/file.mp4")

    %MP4{
      size: s,
      children: [
        %Ftype{info: %Info{type: "ftype", offset: 0, size: 32}},
        %Moov{info: %Info{type: "moov", offset: 32, size: 6542}}
      ]
    } = mp4
  end

  def open!(filepath) do
    mp4 = MP4.open!("../path/to/some/file.mp4")

    %MP4{
      size: s,
      children: [
        %Ftype{info: %Info{type: "ftype", offset: 0, size: 32}},
        %Moov{info: %Info{type: "moov", offset: 32, size: 6542}}
      ]
    } = mp4
  end
  
  def open!(iodevice) do
    mp4 =
      "../path/to/some/file.mp4"
      |> File.open()
      |> MP4.open!(f)

    %MP4{
      size: s,
      children: [
        %Ftype{info: %Info{type: "ftype", offset: 0, size: 32}},
        %Moov{info: %Info{type: "moov", offset: 32, size: 6542}}
      ]
    } = mp4
  end

  def handle(filepath) do
    handle = MP4.handle("../path/to/some/file.mp4")
    MP4.valid(handle) # => true
    MP4.description(handle) # => %Ftype{info: %Info{}}
  end
  
  def handle(iodata) do
    data = <<102, 116, 121, 112, 200, 122, 9, 0, 0, 45>>
    handle = MP4.handle(data)
    
    MP4.valid(handle) # => true
    MP4.description(handle) # => %Ftype{info: %Info{}}
  end
end
```


My initial thought is to model media the `Ecto.Changeset` and create pipelines that read the bitstream and apply it to the changeset, setting it valid or invalid based on the stream. So, something like this.

