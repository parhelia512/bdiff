//!  BSD 3-clause license: see LICENSE.md
//!  Based, in part, on `blksort.c` by Stefan Reuther, copyright (c) 1999 Stefan
//!  Reuther <Streu@gmx.de>.

///  <summary>Implements the block sort component of the diff generator.
///  </summary>
///  <remarks>Used by BDiff only.</remarks>

unit BDiff.BlockSort;


interface


uses
  // Project
  BDiff.Types,
  Common.Types;


type

  ///  <summary>Class that implements the block sort part of the diff.</summary>
  TBlockSort = class(TObject)
  strict private
    var
      fData: PCCharArray;
      fDataSize: Int32;
    ///  <summary>Compares elements of array of <c>TCChar</c> characters
    ///  starting from index <c>A</c>, with elements of same array starting at
    ///  index <c>B</c>.</summary>
    function Compare(const A, B: Int32): Int32;
    ///  <summary>Heap sort sink.</summary>
    procedure Sink(const Left, Right: Int32; const Block: PBlock);
  public
    ///  <summary>Object constructor.</summary>
    ///  <param name="Data">[in] Data to be sorted. Must not be nil.</param>
    ///  <param name="DataSize"> [in] Size of data to be sorted, must be &gt; 0.
    ///  </param>
    constructor Create(const Data: PCCharArray; const DataSize: Int32);
    ///  <summary>Returns array of offsets into data, sorted by position.
    ///  </summary>
    ///  <returns><c>PBlock</c>. Pointer to block of sorted indices into Data or
    ///  <c>nil</c> if the block can't be allocated. Caller must free.
    ///  </returns>
    function Execute: PBlock;
  end;


implementation

uses
  // Delphi
  System.SysUtils;


{
  GENERAL IMPLEMENTATION NOTE (Stefan Reuther)

    Block-sort part of bdiff:

      Taking the data area of length N, we generate N substrings:
      - first substring is data area, length N
      - 2nd is data area sans first character, length N-1
      - ith is data area sans first i-1 characters, length N-i+1
      - Nth is last character of data area, length 1

      These strings are sorted to allow fast (i.e., binary) searching in data
      area. Of course, we don't really generate these N*N/2 bytes of strings: we
      use an array of N size_t's indexing the data.

}


{ TBlockSort }

function TBlockSort.Compare(const A, B: Int32): Int32;
begin
  var PA: PCChar := @fData[A];
  var PB: PCChar := @fData[B];
  var Len: Int32 := if A > B then A else B;
  while (Len > 0) and (PA^ = PB^) do
  begin
    Inc(PA);
    Inc(PB);
    Dec(Len);
  end;
  if Len = 0 then
    Exit(A - B);
  Result := PA^ - PB^;
end;

constructor TBlockSort.Create(const Data: PCCharArray; const DataSize: Int32);
begin
  Assert(Assigned(Data), 'TBlockSort.Create: Data is nil');
  Assert(DataSize > 0, 'TBlockSort.Create: DataSize <= 0');
  inherited Create;
  fData := Data;
  fDataSize := DataSize;
end;

function TBlockSort.Execute: PBlock;
begin
  // attempt to allocate memory
  try
    GetMem(Result, SizeOf(Int32) * fDataSize);
  except
    on E: EOutOfMemory do
      Exit(nil);
    else
      raise;
  end;

  // initialize unsorted data
  for var I := 0 to Pred(fDataSize) do
    Result[I] := I;

  // heapsort
  var Left := fDataSize div 2;
  var Right := fDataSize;
  while Left > 0 do
  begin
    Dec(Left);
    Sink(Left, Right, Result);
  end;
  while Right > 0 do
  begin
    var Temp := Result[Left];
    Result[Left] := Result[Right-1];
    Result[Right-1] := Temp;
    Dec(Right);
    Sink(Left, Right, Result);
  end;
end;

procedure TBlockSort.Sink(const Left, Right: Int32; const Block: PBlock);
begin
  var I := Left;
  var X := Block[I];
  while True do
  begin
    var J := 2 * I + 1;
    if J >= Right then
      Break;
    if J < Right - 1 then
      if Compare(Block[J], Block[J+1]) < 0 then
        Inc(J);
    if Compare(X, Block[J]) > 0 then
      Break;
    Block[I] := Block[J];
    I := J;
  end;
  Block[I] := X;
end;

end.

