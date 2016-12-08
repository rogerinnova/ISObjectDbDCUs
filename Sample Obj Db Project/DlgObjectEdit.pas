unit DlgObjectEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SampleObjects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Edit,
  System.ImageList, FMX.ImgList;

type
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
    LbxChildren: TListBox;
    LblCreateTime: TLabel;
    LblLastSave: TLabel;
  private
    { Private declarations }
    fEditObject: TSampleDbObject;
    Procedure RefreshFormDetails;
    Procedure ReCoverFormDetails;
  public
    { Public declarations }
    Function Execute: Boolean;
    Property EditObject: TSampleDbObject Read fEditObject Write fEditObject;
  end;

implementation

{$R *.fmx}
{ TDlgEditUsrObject }

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

procedure TDlgEditUsrObject.ReCoverFormDetails;
begin
  if EditObject = nil then Exit;
//  else
    EditObject.GivenName:=EdtGiven.Text;
    EditObject.FamilyName:=EdtFamily.Text;
end;

procedure TDlgEditUsrObject.RefreshFormDetails;
begin
  LbxChildren.Items.Clear;
  if EditObject = nil then
  Begin
    EdtGiven.Text := '';
    EdtFamily.Text := '';
    LblCreateTime.Text := 'No Object';
    LblLastSave.Text := 'No Object';
  End
  else
  begin
    EdtGiven.Text := EditObject.GivenName;
    EdtFamily.Text := EditObject.FamilyName;
    LblCreateTime.Text := 'Created : ' + EditObject.SampleData.CreateText;
    LblLastSave.Text := 'Save : ' + EditObject.SampleData.SaveText;
    LbxChildren.Items.AddStrings(EditObject.ListOfChildren);
  end;
end;

end.
