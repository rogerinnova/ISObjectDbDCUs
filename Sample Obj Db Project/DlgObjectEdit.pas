unit DlgObjectEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  ISMultiUserPermObjFileStm, SampleObjects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Edit,
  System.ImageList, FMX.ImgList;

type
{$IfDef NextGen}
  TCallBackProc = Procedure (ARef:TObject) of Object;
{$ENDIF}
  TDlgEditUsrObject = class(TForm)
    PnlToolBar: TPanel;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    SBtnOk: TSpeedButton;
    SBtnCancel: TSpeedButton;
    ImageList1: TImageList;
    EdtGiven: TEdit;
    EdtFamily: TEdit;
    LblGivenName: TLabel;
    LblFamilyName: TLabel;
    LblCreateTime: TLabel;
    LblLastSave: TLabel;
    procedure SBtnOkClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SBtnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
{$IfDef NextGen}
    FCallBack: TCallBackProc;
{$ENDIF}
    fEditObject: TSampleDbObject;
    FEditOk:Boolean;
    Procedure RefreshFormDetails;
    Procedure ReCoverFormDetails;
  public
    { Public declarations }

{$IfDef NextGen}
    DbFile:TISMultiUserDBObjectFile;
    Procedure Execute(ACallBack:TCallBackProc);
{$ELSE}
    Function Execute: Boolean;
{$ENDIF}
    Property EditObject: TSampleDbObject Read fEditObject Write fEditObject;
  end;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}
{$R *.iPhone47in.fmx IOS}
{$R *.iPhone55in.fmx IOS}
{$R *.iPhone.fmx IOS}

{ TDlgEditUsrObject }
{$IFDef NextGen}
Procedure TDlgEditUsrObject.Execute(ACallBack:TCallBackProc);
Begin
  if EditObject = nil then
    raise Exception.Create('Edit Object Required');
  FCallBack:=ACallBack;
  RefreshFormDetails;
  Show;    //No Model Form
End;

{$Else}
function TDlgEditUsrObject.Execute: Boolean;
begin
  Result := false;
  if EditObject <> nil then
  begin
    RefreshFormDetails;
    If ShowModal = MrOk then
    begin
      ReCoverFormDetails;
      if EditObject.DbFileRef <> nil then
        Result := EditObject.SaveToDb
      Else
        Result := True;
    end
    else
      EditObject.RefreshFromDb(false);
  end;
end;
{$ENDIF}

procedure TDlgEditUsrObject.FormClose(Sender: TObject;
  var Action: TCloseAction);
Var
  TestAction:TCloseAction;
begin
  TestAction:=Action;
  Action:=TCloseAction.caFree;
{$IFDef NextGen}
  if Assigned(FCallBack) then
     FCallBack(fEditObject);
{$Endif}
end;

procedure TDlgEditUsrObject.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult<>mrOk then
    EditObject.RefreshFromDb(False);
  CanClose:=ModalResult<>mrNone;
end;

procedure TDlgEditUsrObject.ReCoverFormDetails;
begin
  if EditObject = nil then Exit;
//  else
    EditObject.GivenName:=EdtGiven.Text;
    EditObject.FamilyName:=EdtFamily.Text;
end;

procedure TDlgEditUsrObject.RefreshFormDetails;
begin
  //LbxChildren.Items.Clear;
  if EditObject = nil then
  Begin
    EdtGiven.Text := '';
    EdtFamily.Text := '';
    LblCreateTime.Text := 'No Object';
    LblLastSave.Text := 'No Object';
    Caption:='No Object';
  End
  else
  begin
    EdtGiven.Text := EditObject.GivenName;
    EdtFamily.Text := EditObject.FamilyName;
    LblCreateTime.Text := 'Created : ' + EditObject.SampleData.CreateText;
    LblLastSave.Text := 'Save : ' + EditObject.SampleData.SaveText;
    //LbxChildren.Items.AddStrings(EditObject.ListOfChildren);
    Caption:=EditObject.IndexThree;
  end;
end;

procedure TDlgEditUsrObject.SBtnCancelClick(Sender: TObject);
begin
 FEditOk:=False;
 ModalResult:=mrCancel;
 EditObject.RefreshFromDb(False);
 Close;
end;

procedure TDlgEditUsrObject.SBtnOkClick(Sender: TObject);
begin
{$IFDEF NEXTGEN}
  FEditOk:=False;
  ModalResult:=mrOk;
  ReCoverFormDetails;
  if EditObject.DbFileRef <> nil then
        FEditOk:=EditObject.SaveToDb
    Else if DbFile<>nil then
       FEditOk:=DbFile.WriteIndexedObject(EditObject);
  if not FEditOk then
    Begin
      ModalResult:=mrNone;
      raise Exception.Create('Write Failed');
    end
    Else
       Close;
{$ENDIF}
end;

end.
