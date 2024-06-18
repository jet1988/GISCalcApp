program GISCalcApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitMine in 'UnitMine.pas' {FormMine};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMine, FormMine);
  Application.Run;
end.
