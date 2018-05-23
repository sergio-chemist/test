program DXProjApp;

uses
  Forms,
  UDXMod in 'UDXMod.pas' {frmDXMod},
  FileUtils in '..\CopyMan\FileUtils.pas',
  FastCopy in '..\CopyMan\FastCopy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDXMod, frmDXMod);
  Application.Run;
end.

