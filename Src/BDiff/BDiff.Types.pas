//!  BSD 3-clause license: see LICENSE.md

///  <summary>General type declarations specific to BDiff.</summary>
///  <remarks>Used by BDiff only.</remarks>

unit BDiff.Types;


interface


type

  ///  <summary>Type that enables array <c>[]</c> notation to be used with
  ///  pointers to blocks of <c>Cardinal</c>.</summary>
  ///  <remarks>The original C code uses <c>*size_t</c> pointers that are
  ///  accessed using array <c>[]</c> notation. <c>TBlock</c> enables this to be
  ///  done in Pascal.</remarks>
  TBlock = array[0..0] of Cardinal;

  ///  <summary>Pointer to a <c>TBlock</c> array.</summary>
  PBlock = ^TBlock;

  ///  <summary>Emulation of C's <c>char</c> type.</summary>
  ///  <remarks>This type was defined since the original C code uses
  ///  <c>char</c>, which is signed, while the Pascal <c>Char</c> type is
  ///  unsigned. This type made translation of the C code easier.</remarks>
  TCChar = type Int8;

  ///  <summary>Pointer to <c>TCChar</c>.</summary>
  PCChar = ^TCChar;

  ///  <summary>Array of <c>TCChar</c>.</summary>
  ///  <remarks>This class is provided to ease translation of the original C
  ///  code, which used <c>char</c> array pointers access via the array
  ///  <c>[]</c> operator.</remarks>
  TCCharArray = array[0..(MaxInt div SizeOf(TCChar) - 1)] of TCChar;

  ///  <summary>Pointer to an array of <c>TCChar</c>.</summary>
  PCCharArray = ^TCCharArray;

  ///  <summary>Enumeration of supported patch file formats.</summary>
  TFormat = (FMT_BINARY, FMT_FILTERED, FMT_QUOTED);


implementation


end.

