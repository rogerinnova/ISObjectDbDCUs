unit FrmInnovaDbExample;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.IOUtils,
  ISPermObjFileStm, ISMultiUserPermObjFileStm, SampleObjects, System.ImageList,
  FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, FMX.ListBox;

type
  TForm1 = class(TForm)
    ImageList1: TImageList;
    ListBox1: TListBox;
    Panel1: TPanel;
    SbtnNewDb: TSpeedButton;
    SbtnLocalDb: TSpeedButton;
    SBtnRemoteDb: TSpeedButton;
    sBtnExit: TSpeedButton;
    SBtnAdd: TSpeedButton;
    SBtnEdit: TSpeedButton;
    LblConfigText: TLabel;
    procedure SbtnNewDbClick(Sender: TObject);
    procedure sBtnExitClick(Sender: TObject);
    procedure SbtnLocalDbClick(Sender: TObject);
    procedure SBtnRemoteDbClick(Sender: TObject);
    procedure SBtnEditClick(Sender: TObject);
    procedure SBtnAddClick(Sender: TObject);
  private
    { Private declarations }
    FObjectDb: TInnovaSampleDb;
    function EditObject(AObject: TObject): Boolean;
    Function AddNewObject: TObject;
    Function ObjectFromListBox: TObject;
    function LocalDbFileName: String;
    Procedure FreeDb;
    Procedure RefreshFormData;
    Procedure RemoveAndResetLocalDb;
    Function GetLocalDb: TInnovaSampleDb;
    Function GetDb: TInnovaSampleDb;
    Function GetRemoteDb: TInnovaSampleDb;
    function GetLastError: String;
    procedure SetLastError(const Value: String);
  public
    { Public declarations }
    Property ObjectDb: TInnovaSampleDb Read GetDb;
    Property LastError: String read GetLastError Write SetLastError;
  end;

Const
  SmpleGiven: Array [1 .. 5] of string = ('Joe', 'Jan', 'Jill',
    'James', 'Fred');
  SmpleFam: Array [1 .. 5] of string = ('Blow', 'Smith', 'Smyth',
    'Jones', 'Nerk');

var
  Form1: TForm1;


implementation

uses DlgObjectEdit
{$IFDEF NextGen}
    , ISObjectCounter
{$ENDIF}
    ;

{$R *.fmx}
{ $ R *.LgXhdpiPh.fmx ANDROID }
{ $ R *.NmXhdpiPh.fmx ANDROID }
{ $ R *.iPhone55in.fmx IOS }
{ $ R *.iPhone47in.fmx IOS }
{ $ R *.Windows.fmx MSWINDOWS }
{ $ R *.Macintosh.fmx MACOS }

Const
  RemoteDbFileName = 'C:\ObjectDbExample\SampleTest\GeneralSampleTestDb.RMT';
  AppEncKey = 'IHaveChoosenSomeRandomTextToMangleDataInDb';
  RemoteDbServer = 'Scripts.innovasolutions.com.au';
  LocalDbFileNameConst = 'SmplTestDb.IDB';
  LocalDbPathBitConst = 'ISObjDbs';

function TForm1.AddNewObject: TObject;
Var
  NewObj: TSampleDbObject;
  Dlg: TDlgEditUsrObject;
begin
  Result := nil;
  NewObj := TSampleDbObject.Create(nil, nil);
  Dlg := TDlgEditUsrObject.Create(Self);
  try
    Dlg.EditObject := NewObj;
    if Dlg.Execute then
    begin
      FObjectDb.WriteIndexedObject(NewObj);
      Result := NewObj;
    end
    else
      NewObj.Free;
  finally
    Dlg.Free;
  end;
  if Result <> nil then
    RefreshFormData;
end;

function TForm1.EditObject(AObject: TObject): Boolean;
Var
  Dlg: TDlgEditUsrObject;
  DbIndex: Integer;
begin
  Result := False;
  if AObject = nil then
    Exit;

  if AObject is TSampleDbObject then
  Begin
    Dlg := TDlgEditUsrObject.Create(Self);
    try
      Dlg.EditObject := AObject as TSampleDbObject;
      Result := Dlg.Execute;
    finally
      Dlg.Free;
    end;
  End;
  if Result then
    RefreshFormData;
end;

procedure TForm1.FreeDb;
begin
{$IFDEF NextGen}
  DisposeOfAndNil(TObject(FObjectDb));
  // Need to call Dispose on Db to release cached objects;
{$ELSE}
  FreeAndNil(FObjectDb);
{$ENDIF}
  RefreshFormData;
end;

function TForm1.GetDb: TInnovaSampleDb;
begin
  if FObjectDb = nil then
    Result := GetLocalDb
  else
    Result := FObjectDb;
end;

function TForm1.GetLastError: String;
begin
  Result := Caption;
end;

function TForm1.GetLocalDb: TInnovaSampleDb;
begin
  if FObjectDb <> nil then
    if FObjectDb.RemoteFile then
      FreeDb;

  if FObjectDb = nil then
    if FileExists(LocalDbFileName) then
      FObjectDb := TInnovaSampleDb.Create(LocalDbFileName, fmOpenDb,
        AppEncKey, '')
    Else
    Begin
      Result := nil;
      RemoveAndResetLocalDb;
      if FileExists(LocalDbFileName) then
        GetLocalDb
      Else
        raise Exception.Create('Local Db Start Error');
    end;
  Result := FObjectDb;
  RefreshFormData;
end;

function TForm1.GetRemoteDb: TInnovaSampleDb;
begin
  if FObjectDb <> nil then
    if not FObjectDb.RemoteFile then
      FreeDb;

  if FObjectDb = nil then
    FObjectDb := TInnovaSampleDb.Create(RemoteDbFileName, fmOpenDb, AppEncKey,
      RemoteDbServer, 1500);

  Result := FObjectDb;
  RefreshFormData;
end;

function TForm1.LocalDbFileName: String;
Var
  DbDir: String;
begin
  DbDir := Tpath.Combine(Tpath.GetHomePath, LocalDbPathBitConst);
  if not DirectoryExists(DbDir) then
  Begin
    ForceDirectories(DbDir);
    if not DirectoryExists(DbDir) then
      raise Exception.Create('Directory Fail ' + DbDir);
  End;

  Result := Tpath.Combine(DbDir, LocalDbFileNameConst);
end;

function TForm1.ObjectFromListBox: TObject;
Var
  Idx: Integer;
begin
  Result := nil;
  if FObjectDb = nil then
    Exit;
  // Else
  Idx := ListBox1.ItemIndex;
  if Idx >= 0 then
    Result := FObjectDb.ReadFileObjectByIndex(ListBox1.Items.Objects[Idx]);
end;

procedure TForm1.RefreshFormData;
begin
  ListBox1.Items.Clear;
  if FObjectDb <> nil then
    ListBox1.Items.AddStrings(FObjectDb.SecondaryIndexStringList(idx3, False));
  if FObjectDb <> nil then
    LblConfigText.Text := FObjectDb.Configuration.AnyText
  Else
    LblConfigText.Text := 'No Db';
end;

procedure TForm1.RemoveAndResetLocalDb;
Var
  NewDb: TInnovaSampleDb;
  NxtObj: TSampleDbObject;
  i: Integer;
begin
  FreeDb;
  EraseDb(LocalDbFileName, True);

  Try
    NewDb := TInnovaSampleDb.CreateWithEncryption(LocalDbFileName, fmCreate,
      AppEncKey, False, '');
  Except
    On E: Exception do
    Begin
      LastError := E.Message;
      raise Exception.Create('Error OpenDb ::' + LastError);
    End;
  End;
  if NewDb = Nil then
    LastError := 'No Db';
  if NewDb <> nil then
{$IFDEF NextGen}
    DisposeOfAndNil(TObject(NewDb));
{$ELSE}
    FreeAndNil(NewDb);
{$ENDIF}
  NewDb := GetLocalDb;
  if NewDb <> Nil then
    for i := 1 to 5 do
    Begin
      NxtObj := TSampleDbObject.Create(nil, nil);
      NxtObj.GivenName := SmpleGiven[i];
      NxtObj.FamilyName := SmpleFam[i];
      NewDb.WriteIndexedObject(NxtObj);
    End;
  RefreshFormData;
end;

procedure TForm1.SBtnAddClick(Sender: TObject);
Var
  NewObject: TObject;
begin
  NewObject := AddNewObject;
  RefreshFormData;
end;

procedure TForm1.SBtnEditClick(Sender: TObject);
begin
  EditObject(ObjectFromListBox);
  RefreshFormData;
end;

procedure TForm1.sBtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.SbtnLocalDbClick(Sender: TObject);
begin
  GetLocalDb;
end;

procedure TForm1.SbtnNewDbClick(Sender: TObject);
begin
  RemoveAndResetLocalDb;
end;

procedure TForm1.SBtnRemoteDbClick(Sender: TObject);
begin
  GetRemoteDb;
end;

procedure TForm1.SetLastError(const Value: String);
begin
  Caption := Value;
end;

end.
