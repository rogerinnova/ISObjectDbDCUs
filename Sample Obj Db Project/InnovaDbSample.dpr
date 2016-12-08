program InnovaDbSample;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmInnovaDbExample in 'FrmInnovaDbExample.pas' {Form1},
  SampleObjects in 'SampleObjects.pas',
  DatabaseVersionConstants in 'DatabaseVersionConstants.pas',
  DlgObjectEdit in 'DlgObjectEdit.pas' {DlgEditUsrObject};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
