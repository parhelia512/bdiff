//!  BSD 3-clause license: see LICENSE.md

///  <summary>Exception generation routines.</summary>
///  <remarks>Code common to both BDiff and BPatch.</remarks>

unit Common.Errors;


interface


///  <summary>Raises an exception with given message.</summary>
procedure Error(const Msg: string); overload;

///  <summary>Raises an exception with message created from format string and
///  values.</summary>
procedure Error(const Fmt: string; const Args: array of const); overload;

///  <summary>Raises exception determined by last operating system error.
///  </summary>
procedure OSError;


implementation


uses
  // Delphi
  System.Sysutils;


procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

procedure Error(const Fmt: string; const Args: array of const);
begin
  raise Exception.CreateFmt(Fmt, Args);
end;

procedure OSError;
begin
  var Err: EOSError;
  var LastError := GetLastError;
  if LastError <> 0 then
    Err := EOSError.Create(SysErrorMessage(LastError))
  else
    Err := EOSError.Create('Unknown operating system error');
  Err.ErrorCode := LastError;
  raise Err;
end;

end.

