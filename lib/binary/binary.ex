defmodule Streamline.Binary do
  @moduledoc false

  @type i8() :: <<_ :: 8>>
  @type i16() :: <<_ :: 16>>
  @type i32() :: <<_ :: 32>>
  @type i64() :: <<_ :: 64>>
  @type isize() :: i32() | i64()

  @type u8() :: i8()
  @type u16() :: i16()
  @type u32() :: i32()
  @type u64() :: i64()
  @type usize() :: u32() | u64()
end
