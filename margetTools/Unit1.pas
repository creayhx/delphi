unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,clipbrd, ExtCtrls,xpman;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}


procedure TForm1.Timer1Timer(Sender: TObject);
begin
    if length(clipboard.AsText) = 40 then
    begin
      clipboard.AsText:='magnet:?xt=urn:btih:'+clipboard.AsText;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage('¥≈¡¶¡¥Ω”');
end;

end.
