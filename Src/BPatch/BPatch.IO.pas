{
 * Contains utility functions used for BPatch. Includes Pascal implementations
 * of some standard C library code.
}


unit BPatch.IO;


interface


uses
  // Project
  Common.IO;


const
  // Value representing end of file (as returned from TIO.GetCh).
  EOF: Integer = -1;
  // seek flag used by TIO.Seek (other possible values not used in program).
  SEEK_SET = 0;

type
  TIO = class sealed(TCommonIO)
  public
    { Redirects standard input from a given file handle }
    class procedure RedirectStdIn(const Handle: THandle);
    { Seeks to given offset from given origin in file specified by Handle.
      Returns True on success, false on failure. }
    class function Seek(Handle: THandle; Offset: Longint; Origin: Integer):
      Boolean;
    { Checks if given file handle is at end of file. }
    class function AtEOF(Handle: THandle): Boolean;
    { Gets a single ANSI character from file specified by Handle and returns it,
      or EOF. }
    class function GetCh(Handle: THandle): Integer;
  end;


implementation


uses
  // Delphi
  System.SysUtils,
  Winapi.Windows;


{ TIO }

class function TIO.AtEOF(Handle: THandle): Boolean;
begin
  var CurPos := System.SysUtils.FileSeek(Handle, Int64(0), 1);
  var Size := Winapi.Windows.GetFileSize(Handle, nil);
  Result := CurPos = Size;
end;

class function TIO.GetCh(Handle: THandle): Integer;
begin
  if AtEOF(Handle) then
    Result := EOF
  else
  begin
    var Ch: AnsiChar;
    System.SysUtils.FileRead(Handle, Ch, SizeOf(Ch));
    Result := Integer(Ch);
  end;
end;

class procedure TIO.RedirectStdIn(const Handle: THandle);
begin
  Winapi.Windows.SetStdHandle(
    Winapi.Windows.STD_INPUT_HANDLE, Cardinal(Handle)
  );
end;

class function TIO.Seek(Handle: THandle; Offset, Origin: Integer): Boolean;
begin
  Result := System.SysUtils.FileSeek(Handle, Offset, Origin) >= 0;
end;

end.

