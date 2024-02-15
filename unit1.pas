unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type
  TSexPeople = (spMale, spFemale);
  TRecPeople = record
    Name: string;
    Address: String;
    YearBorn: Integer;
    MonthBorn: Integer;
    DateBorn: Integer;
    Sex: TSexPeople;
  end;

  { TStoredPeople }

  TStoredPeople = class
  private
    FData: Array of TRecPeople;
    FCurrentIndex: Integer;
    function GetRecordCount: Integer;
  public
    property RecNo: Integer read FCurrentIndex;
    property RecordCount: Integer read GetRecordCount;
    constructor Create;
    destructor Destroy; override;
    procedure AssignRecord(pSource: TStoredPeople);
    procedure AddData(pRecData: TRecPeople);
    procedure Open;
    procedure Close;
    function Eof: Boolean;
    procedure First;
    procedure Next;
    function PrintRecord: AnsiString;
    function PrintCurrentRecord: String;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    MyDataSet: TStoredPeople;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TStoredPeople }

function TStoredPeople.GetRecordCount: Integer;
begin
  Result:= Length(FData);
end;

constructor TStoredPeople.Create;
begin

end;

destructor TStoredPeople.Destroy;
begin
  inherited Destroy;
end;

procedure TStoredPeople.AssignRecord(pSource: TStoredPeople);
begin
  if pSource = nil then begin
    ShowMessage('Source not yet init !');
    Exit;
  end;
  FCurrentIndex:= pSource.FCurrentIndex;
  FData:= pSource.FData;
end;

procedure TStoredPeople.AddData(pRecData: TRecPeople);
begin
  SetLength(FData, Length(FData)+1);
  FCurrentIndex := Length(FData)-1;
  FData[FCurrentIndex]:= pRecData;
end;

procedure TStoredPeople.Open;
begin
  SetLength(FData, 0);
  FCurrentIndex := 0;
end;

procedure TStoredPeople.Close;
begin
  SetLength(FData, 0);
  FCurrentIndex := -1;
end;

function TStoredPeople.Eof: Boolean;
begin
  Result := FCurrentIndex >= RecordCount;
end;

procedure TStoredPeople.First;
begin
  FCurrentIndex := 0;
end;

procedure TStoredPeople.Next;
begin
  Inc(FCurrentIndex);
end;

function TStoredPeople.PrintRecord: AnsiString;
var StrRes: String;
    vBackup: Integer;
begin
  vBackup:= FCurrentIndex;
  StrRes:= '';
  First;
  while not Eof do begin
    StrRes:= StrRes + '[Name]='+FData[FCurrentIndex].Name;
    StrRes:= StrRes + ',[Address]='+FData[FCurrentIndex].Address;
    StrRes:= StrRes + ',[YearBorn]='+IntToStr(FData[FCurrentIndex].YearBorn);
    StrRes:= StrRes + ',[MonthBorn]='+IntToStr(FData[FCurrentIndex].MonthBorn);
    StrRes:= StrRes + ',[DateBorn]='+IntToStr(FData[FCurrentIndex].DateBorn);
    case FData[FCurrentIndex].Sex of
      spMale: StrRes:= StrRes + ',[Sex]=Male';
      spFemale: StrRes:= StrRes + ',[Sex]=Female';
    end;
    Next;
    if not Eof then
      StrRes:= StrRes+sLineBreak;
  end;
  Result:= StrRes;
  FCurrentIndex:= vBackup;
end;

function TStoredPeople.PrintCurrentRecord: String;
var StrRes: String;
begin
  StrRes:= '[Name]='+FData[FCurrentIndex].Name;
  StrRes:= StrRes + ',[Address]='+FData[FCurrentIndex].Address;
  StrRes:= StrRes + ',[YearBorn]='+IntToStr(FData[FCurrentIndex].YearBorn);
  StrRes:= StrRes + ',[MonthBorn]='+IntToStr(FData[FCurrentIndex].MonthBorn);
  StrRes:= StrRes + ',[DateBorn]='+IntToStr(FData[FCurrentIndex].DateBorn);
  case FData[FCurrentIndex].Sex of
    spMale: StrRes:= StrRes + ',[Sex]=Male';
    spFemale: StrRes:= StrRes + ',[Sex]=Female';
  end;
  Result:= StrRes;
end;

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Text:= MyDataSet.PrintRecord;
end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if not (key in (['0'..'9', #8, #13])) then begin
    Key:= #0;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var vMyRecord: TRecPeople;
begin
  vMyRecord.Name:= Edit1.Text;
  vMyRecord.Address:= Edit2.Text;
  vMyRecord.YearBorn:= StrToInt(Edit3.Text);
  vMyRecord.MonthBorn:= StrToInt(Edit4.Text);
  vMyRecord.DateBorn:= StrToInt(Edit5.Text);
  case RadioGroup1.ItemIndex of
    0: vMyRecord.Sex:= spMale;
    1: vMyRecord.Sex:= spFemale;
  end;
  MyDataSet.AddData(vMyRecord);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MyDataSet:= TStoredPeople.Create;
end;

end.

