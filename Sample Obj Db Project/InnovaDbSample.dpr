program InnovaDbSample;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmInnovaDbExample in 'FrmInnovaDbExample.pas' {DbGetForm},
  SampleObjects in 'SampleObjects.pas',
  DatabaseVersionConstants in 'DatabaseVersionConstants.pas',
  DlgObjectEdit in 'DlgObjectEdit.pas' {DlgEditUsrObject};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDbGetForm, DbGetForm);
  Application.Run;
end.
