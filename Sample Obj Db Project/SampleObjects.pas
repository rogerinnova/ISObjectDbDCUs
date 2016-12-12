unit SampleObjects;

interface

uses
  SysUtils, Classes, ISPermObjFileStm, ISMultiUserPermObjFileStm, IsRemoteDbLib,
{$IFDEF NextGen}
  IsNextGenPickup,
{$ENDIF}
  ISMultiUserRemoteDb;

Type

  TExampleConfigSingleton = class;

  TInnovaSampleDb = Class(TISMultiUserDBRemote)
    // Using TISMultiUserDBRemote enables both Client Server and Local File options
    { for local file access db only you could exclude Client Server Option
      TSampleDb = Class(TISMultiUserDBObjectFile)
    }
  private
    fConfiguration: TExampleConfigSingleton;
    function SampleIndex(AObjPtr: Pointer): AnsiString;
  protected
    procedure LoadIndexs; override;
  public
    constructor CreateWithEncryption(const FName: AnsiString; OpenMode: Word;
      Const AProvideKeyToUseEncrpytion: AnsiString; DoRemote: Boolean = false;
      Const ADbHost: String = ''; ADbPort: Integer = 0);
    Destructor Destroy; Override;
    Function Configuration: TExampleConfigSingleton;
    // An example of using the Db to store a singleton object
  End;

  TSampleData = Class(TISMultiUserDbBaseObj)
    // Example of encapsulated Object;
    FCreateDate: TDateTime;
    FLastEditDate: TDateTime;
  Public
    constructor Create(IntOwnerList, IntOwner: Pointer); override;
    procedure Load(var s: Tstream); override;
    procedure Store(var s: Tstream); override;
    Function CreateText: String;
    Function SaveText: String;
    Property CreateDate: TDateTime read FCreateDate;
    Property LastEditDate: TDateTime read FLastEditDate;
  end;

  TSampleDbObject = Class(TISMultiUserDbBaseObj)
  Private
    FGivenName, FFamilyName, FPhone: String;
    // Example of encapsulated Object;
    FSampleData: TSampleData;
    // Example of encapsulated List;
    FListOfChildren: TStringList; // List Of TSampleDbObject
    function GetSampleData: TSampleData;
    function GetListOfChildren: TStringList;
  Protected
    procedure ResetBeforeReload; override;
  Public
    Destructor Destroy; Override;
    procedure Load(var s: Tstream); override;
    procedure Store(var s: Tstream); override;
    Function IndexThree: String;
    Property GivenName: String read FGivenName write FGivenName;
    Property FamilyName: String read FFamilyName write FFamilyName;
    Property Phone: String read FPhone write FPhone;
    Property SampleData: TSampleData read GetSampleData;
    Property ListOfChildren: TStringList Read GetListOfChildren;
  End;

  TExampleConfigSingleton = Class(TISMultiUserDbBaseObj)
    // An example of using the Db to store a singleton object
  private
    fAnyString: String;
    FAnyData: TSampleData;
  public
    Destructor Destroy; Override;
    procedure Load(var s: Tstream); override;
    procedure Store(var s: Tstream); override;
    Function AnyText:String;
    Function AnyData:TSampleData;
  End;

implementation

{ TInnovaSampleDb }

function TInnovaSampleDb.Configuration: TExampleConfigSingleton;
    // An example of using the Db to store a singleton object
begin
  Result := fConfiguration;

  if Result = nil then
  Begin
    //Pointer(fConfiguration) := NextPrevObjectByClass(TExampleConfigSingleton,
    //allows auto complete to find function which return a pointer
    //for AutoRefCount the pointer cast should then be removed
    fConfiguration := NextPrevObjectByClass(TExampleConfigSingleton,
      false, True, True);
    // Will always return first object of this (Or Descendent) class
    // ideally created when there are few objects in the database so
    // does not need to search far
    If fConfiguration = nil then
    Begin
      fConfiguration := TExampleConfigSingleton.Create(nil, nil);
      fConfiguration.AnyData.FCreateDate := Now;
      fConfiguration.fAnyString := 'Some Config Data 任何文本都可以去這裡';
      WriteIndexedObject(fConfiguration);
    End;
  Result:=fConfiguration;
  End;
end;

constructor TInnovaSampleDb.CreateWithEncryption(const FName: AnsiString;
  OpenMode: Word; const AProvideKeyToUseEncrpytion: AnsiString;
  DoRemote: Boolean; Const ADbHost: String; ADbPort: Integer);
Begin
  If DoRemote then
  Begin
    If ADbHost = '' then
      Raise Exception.Create('You must provide host for Remote Calls');
    inherited Create(FName, OpenMode, AProvideKeyToUseEncrpytion,
      ADbHost, ADbPort);
    FRemoteLog := True;
  end
  else
    inherited Create(FName, OpenMode, AProvideKeyToUseEncrpytion, ADbHost);
End;

destructor TInnovaSampleDb.Destroy;
begin
  fConfiguration.Free;
  inherited;
end;

procedure TInnovaSampleDb.LoadIndexs;
begin
  inherited;
  AddIndex(SampleIndex, idx3);
end;

function TInnovaSampleDb.SampleIndex(AObjPtr: Pointer): AnsiString;
begin
  Result := '';
  if (AObjPtr <> nil) And (TObject(AObjPtr) is TSampleDbObject) then
    Result := TSampleDbObject(AObjPtr).IndexThree;
end;

{ TSampleDbObject }

destructor TSampleDbObject.Destroy;
begin
  FreeAndNil(FSampleData);
  FreeSListFO(FListOfChildren);
  inherited;
end;

function TSampleDbObject.GetListOfChildren: TStringList;
begin
  if FListOfChildren = nil then
  begin
    FListOfChildren := TStringList.Create;
    FListOfChildren.Duplicates := dupAccept;
  end;
  Result := FListOfChildren;
end;

function TSampleDbObject.GetSampleData: TSampleData;
begin
  if FSampleData = nil then
  begin
    FSampleData := TSampleData.Create(self, self);
  end;
  Result := FSampleData;
end;

function TSampleDbObject.IndexThree: String;
begin
  Result := Uppercase(FFamilyName) + ' ' + FGivenName;
end;

procedure TSampleDbObject.Load(var s: Tstream);
begin
  inherited;
  FGivenName := ReadStrmUnicodeString(s);
  FFamilyName := ReadStrmUnicodeString(s);
  FPhone := ReadStrmUnicodeString(s);
  // Example of encapsulated Object;
  FSampleData := ReadStrmObject(s, self);
  // Example of encapsulated List;
  ReadStrmList(s, ListOfChildren); // List Of TSampleDbObject
end;

procedure TSampleDbObject.ResetBeforeReload;
begin
  inherited;
  FreeAndNil(FSampleData);
  FreeSListFO(FListOfChildren);
end;

procedure TSampleDbObject.Store(var s: Tstream);
begin
  inherited;
  WriteStrmString(s, FGivenName);
  WriteStrmString(s, FFamilyName);
  WriteStrmString(s, FPhone);
  // Example of encapsulated Object;
  WriteStrmObject(s, SampleData);
  // Example of encapsulated List;
  WriteStrmList(s, ListOfChildren); // List Of TSampleDbObject
end;

{ TSampleData }

constructor TSampleData.Create(IntOwnerList, IntOwner: Pointer);
begin
  inherited;
  FCreateDate := Now;
end;

function TSampleData.CreateText: String;
begin
  if FCreateDate < 8 then
    Result := 'Null Date'
  else
    Result := FormatDateTime('dd mmm yyyy  hh:nn', FCreateDate);
end;

procedure TSampleData.Load(var s: Tstream);
begin
  inherited;
  s.read(FCreateDate, SizeOf(FCreateDate));
  s.read(FLastEditDate, SizeOf(FLastEditDate));
end;

function TSampleData.SaveText: String;
begin
  if FLastEditDate < 8 then
    Result := 'Null Date'
  else
    Result := FormatDateTime('dd mmm yyyy  hh:nn', FLastEditDate);
end;

procedure TSampleData.Store(var s: Tstream);
begin
  inherited;
  FLastEditDate := Now;
  s.write(FCreateDate, SizeOf(FCreateDate));
  s.write(FLastEditDate, SizeOf(FLastEditDate));
end;

{ TExampleConfigSingleton }

function TExampleConfigSingleton.AnyData: TSampleData;
begin
 if FAnyData=nil then
    FAnyData:=  TSampleData.Create(self,self);
 Result:= FAnyData;
end;

function TExampleConfigSingleton.AnyText: String;
begin
  Result:='Created on: '+ FormatDateTime('dd mmm',FAnyData.FCreateDate)+ ' Text : <'+
  fAnyString+'>';
end;

destructor TExampleConfigSingleton.Destroy;
begin
  FreeAndNil(FAnyData);
  inherited;
end;

procedure TExampleConfigSingleton.Load(var s: Tstream);
begin
  inherited;
  fAnyString := ReadStrmUnicodeString(s);
  FAnyData := ReadStrmObject(s,self);
end;

procedure TExampleConfigSingleton.Store(var s: Tstream);
begin
  inherited;
  WriteStrmString(s, fAnyString);
  WriteStrmObject(s, FAnyData);
end;

Initialization

{ http://www.innovasolutions.com.au/delphistuf/ObjectDbInfo/Object%20Database.html
  Register Persistent Classes
}
// Need to Register all objects to be stored before Db Access
RegPersistentClasses([TSampleDbObject, TSampleData, TExampleConfigSingleton]);

end.
