defmodule Streamline.Binary do
  @moduledoc """
  Module `binary` for bitstring and bytes operations
  """
  use Bitwise

  @type i8() :: << _ :: 8 >>
  @type i16() :: << _ :: 16 >>
  @type i32() :: << _ :: 32 >>
  @type i64() :: << _ :: 64 >>
  @type isize() :: i32() | i64()

  @type u8() :: i8()
  @type u16() :: i16()
  @type u32() :: i32()
  @type u64() :: i64()
  @type usize() :: u32() | u64()

  @type c128() :: << _ :: 128 >>

  @packed 0x60
  def language_code(lang) do
    {
      bsr(band(lang, 0x7c00), 10) + @packed,
      bsr(band(lang, 0x03E0), 5) + @packed,
      band(lang, 0x001F) + @packed
    }
  end

  def strip_null_term(name), do: binary_part(name, 0, byte_size(name) - 1)

  def extract(str, amount) when is_binary(str) do
    extract(str, amount, [])
  end

  defp extract(<< b :: size(1), bits :: bitstring >>, amount, acc) when length(acc) < amount do
    extract(bits, amount, [b | acc])
  end

  defp extract(<< >>, _, acc),
       do: acc
           |> Enum.reverse
           |> :binary.list_to_bin()

  def bool(0), do: false
  def bool(1), do: true
end
