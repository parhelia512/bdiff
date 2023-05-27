{
 * Static class containing main program logic for BPatch program.
}


unit BPatch.Main;


interface


type
  TMain = class(TObject)
  strict private
    class procedure DisplayHelp;
    class procedure DisplayVersion;
    class procedure RedirectStdIn(const FileName: string);
  public
    class procedure Run;
  end;


implementation


uses
  System.SysUtils,

  BPatch.InfoWriter,
  BPatch.IO,
  BPatch.Patcher,
  BPatch.Params,
  Common.AppInfo,
  Common.Errors;


{ TMain }

class procedure TMain.DisplayHelp;
begin
  TBPatchInfoWriter.HelpScreen;
end;

class procedure TMain.DisplayVersion;
begin
  TBPatchInfoWriter.VersionInfo;
end;

class procedure TMain.RedirectStdIn(const FileName: string);
begin
  var PatchFileHandle: THandle := FileOpen(
    FileName, fmOpenRead or fmShareDenyNone
  );
  if NativeInt(PatchFileHandle) <= 0 then
    OSError;
  TIO.RedirectStdIn(PatchFileHandle);
end;

class procedure TMain.Run;
begin
  ExitCode := 0;
  var Params := TParams.Create;
  try
    try
      Params.Parse;
      if Params.Help then
        DisplayHelp
      else if Params.Version then
        DisplayVersion
      else
      begin
        if (Params.PatchFileName <> '') and (Params.PatchFileName <> '-') then
          RedirectStdIn(Params.PatchFileName);
        TPatcher.Apply(Params.OldFileName, Params.NewFileName);
      end;
    finally
      Params.Free;
    end;
  except
    on E: Exception do
    begin
      ExitCode := 1;
      TIO.WriteStrFmt(
        TIO.StdErr, '%0:s: %1:s'#13#10, [TAppInfo.ProgramFileName, E.Message]
      );
    end;
  end;
end;

end.

