unit FNewTagItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Contnrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AudioFiles.Base, AudioFiles.BaseTags, AudioFiles.Declarations;

type
  TFormNewTagItem = class(TForm)
    cbKey: TComboBox;
    lbl_FrameType: TLabel;
    lbl_FrameValue: TLabel;
    edtValue: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    lblNoMoreFrames: TLabel;

  private
    { Private declarations }
    fAvailableTagItems: TTagItemInfoDynArray;

    procedure SetAvailableTagItems(Value: TTagItemInfoDynArray);
    function GetSelectedTagItemInfo: TTagItemInfo;
    function GetValue: UnicodeString;
  public
    { Public declarations }
    property AvailableTagItems: TTagItemInfoDynArray write SetAvailableTagItems;
    property SelectedTagItemInfo: TTagItemInfo read GetSelectedTagItemInfo;
    property Value: UnicodeString read GetValue;
  end;

var
  FormNewTagItem: TFormNewTagItem;

implementation

{$R *.dfm}

procedure TFormNewTagItem.SetAvailableTagItems(Value: TTagItemInfoDynArray);
var
  i: Integer;
begin
  fAvailableTagItems := Value;
  cbKey.Clear;

  for i := 0 to Length(Value) - 1 do begin
    if Value[i].Description <> '' then
      cbKey.Items.Add( Value[i].Description + ' (' + Value[i].Key + ')')
    else
      cbKey.Items.Add(Value[i].Key);
  end;

  if cbKey.Items.Count > 0 then begin
    cbKey.Enabled := True;
    lblNoMoreFrames.Visible := False;
    cbKey.ItemIndex := 0
  end
  else begin
    cbKey.Enabled := False;
    lblNoMoreFrames.Visible := True;
  end;
end;

function TFormNewTagItem.GetSelectedTagItemInfo: TTagItemInfo;
begin
  if length(fAvailableTagItems) > 0 then
    result := fAvailableTagItems[cbKey.ItemIndex]
  else
  begin
    result.Key := '';
    result.Description := '';
    result.TagType := ttUndef;
  end;
end;

function TFormNewTagItem.GetValue: UnicodeString;
begin
  result := edtValue.Text;
end;


end.
