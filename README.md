# Backlit StreamlineEX

Streamline is a media parsing and streaming library on the Backlit platform.

## API (RFC)

The api for StreamlineEX should be elegant and straightforward, without much work needed from the consumber of the
library. In other words, the only thing a consumer should need to do is open/upload a file or pass in a bitstream that
is known to be media encoded. The `handles` of the api should do the rest.

My initial thought is to model the `Ecto.Changeset` and create pipelines that read the bitstream and apply it to the
changeset, setting it valid or invalid based on the stream. So, something like this.

```elixir
defmodule Example do
  alias Streamline.Media.MP4
  alias MP4.Box.{Info, Ftype, Moov}

  def parse do
    mp4 =
      "../path/to/some/file.mp4"
      |> File.open()
      |> MP4.parse(f)
      
    %MP4{
      size: s, 
      children: [
        %Ftype{info: %Info{type: "ftype", offset: 0, size: 32}}, 
        %Moov{info: %Info{type: "moov", offset: 32, size: 6542}}
      ]
    } = mp4
  end
  
  def handle do
    mp4 = MP4.handle("../path/to/some/file.mp4")
  end
end
```

