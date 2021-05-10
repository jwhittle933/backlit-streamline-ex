# Backlit StreamlineEX

Streamline is a media parsing and streaming library on the Backlit platform.

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


My initial thought is to model media the `Ecto.Changeset` and create pipelines that read the bitstream and apply it to the
changeset, setting it valid or invalid based on the stream. So, something like this.

