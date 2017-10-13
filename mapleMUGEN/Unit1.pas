unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sSkinManager, StdCtrls, sGroupBox, sCheckBox, sButton;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    Timer1: TTimer;
    sGroupBox1: TsGroupBox;
    sGroupBox2: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    sCheckBox7: TsCheckBox;
    sCheckBox8: TsCheckBox;
    sCheckBox9: TsCheckBox;
    sCheckBox10: TsCheckBox;
    sCheckBox11: TsCheckBox;
    sCheckBox12: TsCheckBox;
    sGroupBox3: TsGroupBox;
    sButton1: TsButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sButton1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  mugenhandle,mugenpt:Integer;
  mugenaddr:Integer=$005040E8;
  rb:Dword;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
mugenpid:Integer;
begin
mugenhandle:=Findwindow(nil,'M.U.G.E.N');
GetWindowThreadProcessId(mugenhandle,@mugenpid);
mugenpt:=openprocess(process_all_access,false,mugenpid);
end;

function cheat(write,pt1,pt2,number:Integer):Integer;
var
num:integer;
begin
if write = 0 then
begin
  readprocessmemory(mugenpt,pointer(mugenaddr),@num,4,rb);
  readprocessmemory(mugenpt,pointer(num+pt1),@num,4,rb);
  readprocessmemory(mugenpt,pointer(num+pt2),@num,4,rb);
  result:=num;
end;
if write = 1 then
begin
  readprocessmemory(mugenpt,pointer(mugenaddr),@num,4,rb);
  readprocessmemory(mugenpt,pointer(num+pt1),@num,4,rb);
  writeprocessmemory(mugenpt,pointer(num+pt2),@number,4,rb);
end;
end;

function pressk(wp,lp:integer):Boolean;
begin
  postmessage(mugenhandle,wm_keydown,wp,lp);
  lp:=lp+$C0000000;
  postmessage(mugenhandle,wm_keyup,wp,lp);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
num:integer;
begin
If scheckbox1.checked then
begin
  cheat(1,$12278,$1b8,99000);
end;
If scheckbox2.checked then
begin
  cheat(1,$12278,$1d0,99000);
end;

If scheckbox4.checked then
begin
  cheat(1,$1227C,$1b8,99000);
end;
If scheckbox5.checked then
begin
  cheat(1,$1227C,$1d0,99000);
end;

If scheckbox7.checked then
begin
  cheat(1,$12278,$1b8,1);
end;
If scheckbox8.checked then
begin
   cheat(1,$12278,$1d0,0);
end;
If scheckbox9.checked then
begin
  cheat(1,$1227C,$1b8,1);
end;
If scheckbox10.checked then
begin
   cheat(1,$1227C,$1d0,0);
end;
If scheckbox11.checked then
begin
  cheat(1,$12278,$1b8,0);
end;
If scheckbox12.checked then
begin
  cheat(1,$1227C,$1b8,0);
end;
end;
procedure TForm1.sButton1Click(Sender: TObject);
begin
  pressk($73,$003E0001);
end;

end.
