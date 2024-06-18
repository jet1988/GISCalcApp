unit UnitMine;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.StdCtrls,
  {$IFDEF ANDROID}
  Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.NET,
  {$ENDIF}
  {$IFDEF IOS OR IOS64}
  MacApi.Helpers, iOSApi.Foundation, FMX.Helpers.iOS,
  {$ENDIF}
  {$IFDEF POSIX}
  Posix.Stdlib,
  {$ENDIF POSIX}
  {$IFDEF MSWINDOWS}
  ShellAPI, {DarkModeApi.FMX,} FMX.Platform.Win,
  {$ENDIF}
  FMX.Platform;

type
  TKoord = Record
    dd:Integer;
    mm:Integer;
    ss:Integer;
  End;

  TFormMine = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    SpinBoxYDec: TSpinBox;
    SpinBoxXDec: TSpinBox;
    Panel2: TPanel;
    Label4: TLabel;
    SpinBoxYGr: TSpinBox;
    SpinBoxXGr: TSpinBox;
    SpinBoxYMin: TSpinBox;
    SpinBoxXMin: TSpinBox;
    SpinBoxYSec: TSpinBox;
    SpinBoxXSec: TSpinBox;
    Panel3: TPanel;
    EditY: TEdit;
    EditX: TEdit;
    BtnY: TButton;
    BtnX: TButton;
    BtnYa: TButton;
    BtnG: TButton;
    CheckStayOnTop: TCheckBox;

    procedure Shirota;
    procedure Doldota;
    procedure SpinBoxYDecChange(Sender: TObject);
    procedure SpinBoxXDecChange(Sender: TObject);
    procedure SpinBoxYGrChange(Sender: TObject);
    procedure SpinBoxXGrChange(Sender: TObject);
    procedure SpinBoxYMinChange(Sender: TObject);
    procedure SpinBoxXMinChange(Sender: TObject);
    procedure SpinBoxYSecChange(Sender: TObject);
    procedure SpinBoxXSecChange(Sender: TObject);
    procedure BtnYClick(Sender: TObject);
    procedure BtnXClick(Sender: TObject);
    procedure BtnYaClick(Sender: TObject);
    procedure BtnGClick(Sender: TObject);
    procedure CheckStayOnTopChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMine: TFormMine;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

function DDDToDDMMSS(ddd:Real):TKoord;
begin
  Result.dd:= Trunc(abs(ddd));
  Result.mm:= Trunc((abs(ddd)-Result.dd)*60);
  Result.ss:= Round(((abs(ddd)-Result.dd)*60-Result.mm)*60);
end;

function DDMMSSToDDD(dd,mm,ss:real):Real;
begin
  Result:=dd + (mm / 60) + (ss / 3600);
end;

procedure OpenUrl(const URL: string);
begin
  {$IFDEF ANDROID}
  TAndroidHelper.Context.startActivity(TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW, StrToJURI(URL)));
  {$ENDIF}
  {$IFDEF IOS OR IOS64}
  SharedApplication.OpenURL(StrToNSUrl(URL));
  {$ENDIF}
  {$IFDEF POSIX}
  _system(PAnsiChar('xdg-open ' + AnsiString(URL)));
  {$ENDIF POSIX}
  {$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', PChar(URL), nil, nil, 1);
  {$ENDIF}
end;

procedure TFormMine.Shirota;
var t, m, s:string;
begin
  t:= inttostr(Round(SpinBoxYGr.Value));
  m:= inttostr(Round(SpinBoxYMin.Value));
  s:= inttostr(Round(SpinBoxYSec.Value));
  EditY.Text:=t+'°'+m+''''+s+''''''+BtnY.Text;
  //Edit1.Text:=AdvSpinEdit3.Text+'°'+AdvSpinEdit4.Text+''''+AdvSpinEdit5.Text+''''''+Button1.Caption;
end;

procedure TFormMine.Doldota;
  var t, m, s:string;
begin
  t:= inttostr(Round(SpinBoxXGr.Value));
  m:= inttostr(Round(SpinBoxXMin.Value));
  s:= inttostr(Round(SpinBoxXSec.Value));
  EditX.Text:= t + '°' + m + '''' + s + '''''' + BtnX.Text;
end;

procedure TFormMine.BtnGClick(Sender: TObject);
var url:string;
begin
  url:='https://www.google.ru/maps/place/' + EditY.Text + '+' + EditX.Text;
  OpenUrl(url);
end;

procedure TFormMine.BtnXClick(Sender: TObject);
begin
  if BtnX.Text = 'E' then BtnX.Text:= 'W' else BtnX.Text:= 'E';
  SpinBoxXDec.Value:= -SpinBoxXDec.Value;
  SpinBoxXGr.Value:=  -SpinBoxXGr.Value;
  Doldota;
end;

procedure TFormMine.BtnYClick(Sender: TObject);
begin
  if BtnY.Text = 'N' then BtnY.Text:= 'S' else BtnY.Text:= 'N';
  SpinBoxYDec.Value:= -SpinBoxYDec.Value;
  SpinBoxYGr.Value:=  -SpinBoxYGr.Value;
  Shirota;
end;

procedure TFormMine.CheckStayOnTopChange(Sender: TObject);
begin
  if CheckStayOnTop.IsChecked then
    FormStyle:= TFormStyle.StayOnTop
  else
    FormStyle:= TFormStyle.Normal;
end;

procedure TFormMine.BtnYaClick(Sender: TObject);
var url:string;
begin
  url:= 'https://maps.yandex.ru/?text=' + SpinBoxYDec.Text + '+' + SpinBoxXDec.Text;
  OpenUrl(url);
end;

procedure TFormMine.SpinBoxYDecChange(Sender: TObject);
var koord:TKoord;
begin
  if not SpinBoxYDec.IsFocused then exit;

  if SpinBoxYDec.Value>0 then BtnY.Text:= 'N' else BtnY.Text:= 'S';
  koord:=DDDToDDMMSS(SpinBoxYDec.Value);
  SpinBoxYGr.Value := koord.dd;
  SpinBoxYMin.Value:= koord.mm;
  SpinBoxYSec.Value:= koord.ss;
  Shirota;
end;

procedure TFormMine.SpinBoxYGrChange(Sender: TObject);
begin
  if SpinBoxYDec.IsFocused then Exit;
  SpinBoxYDec.Value:= DDMMSSToDDD(SpinBoxYGr.Value, SpinBoxYMin.Value, SpinBoxYSec.Value);
  Shirota;
end;

procedure TFormMine.SpinBoxYMinChange(Sender: TObject);
begin
  if SpinBoxYDec.IsFocused then Exit;
  SpinBoxYDec.Value:= DDMMSSToDDD(SpinBoxYGr.Value, SpinBoxYMin.Value, SpinBoxYSec.Value);
  Shirota;
end;

procedure TFormMine.SpinBoxYSecChange(Sender: TObject);
begin
  if SpinBoxYDec.IsFocused then Exit;
  SpinBoxYDec.Value:= DDMMSSToDDD(SpinBoxYGr.Value, SpinBoxYMin.Value, SpinBoxYSec.Value);
  Shirota;
end;

procedure TFormMine.SpinBoxXDecChange(Sender: TObject);
var koord:TKoord;
begin
  if not SpinBoxXDec.IsFocused then exit;

  if SpinBoxXDec.Value>0 then BtnX.Text:='E' else BtnX.Text:='W';
  koord:=DDDToDDMMSS(SpinBoxXDec.Value);
  SpinBoxXGr.Value := koord.dd;
  SpinBoxXMin.Value:= koord.mm;
  SpinBoxXSec.Value:= koord.ss;
Doldota;
end;

procedure TFormMine.SpinBoxXGrChange(Sender: TObject);
begin
  if SpinBoxXDec.IsFocused then Exit;
  SpinBoxXDec.Value:= DDMMSSToDDD(SpinBoxXGr.Value, SpinBoxXMin.Value, SpinBoxXSec.Value);
  Doldota;
end;

procedure TFormMine.SpinBoxXMinChange(Sender: TObject);
begin
  if SpinBoxXDec.IsFocused then Exit;
  SpinBoxXDec.Value:= DDMMSSToDDD(SpinBoxXGr.Value, SpinBoxXMin.Value, SpinBoxXSec.Value);
  Doldota;
end;

procedure TFormMine.SpinBoxXSecChange(Sender: TObject);
begin
  if SpinBoxXDec.IsFocused then Exit;
  SpinBoxXDec.Value:= DDMMSSToDDD(SpinBoxXGr.Value, SpinBoxXMin.Value, SpinBoxXSec.Value);
  Doldota;
end;

end.
