unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,unit2, StdCtrls, sButton, sSkinManager, sCheckBox, ExtCtrls;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    sButton1: TsButton;
    Timer1: TTimer;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    sCheckBox6: TsCheckBox;
    sCheckBox7: TsCheckBox;
    sCheckBox8: TsCheckBox;
    procedure sButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  player : Array[0..3] of DWORD = ($58C94,$58C98,$58C9c,$58Ca0);
implementation
Function change(playerNo,point,num:Integer):Boolean;
var
    temp:Integer;
begin
    readProcessMemory(gProcess,pointer(dllBaseAddr + player[playerNo - 1]),@temp,4,RB);
    writeProcessMemory(gProcess,pointer(temp + point),@num,4,RB);
end;
{$R *.dfm}

procedure TForm1.sButton1Click(Sender: TObject);
begin
    load('Little Fighter 2','lf2.exe','lf2.exe');
    if( gProcess > 0 )then
    begin
        sbutton1.caption := '游戏已启动';
    end
    else
    begin
        sbutton1.caption := '游戏未启动';
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    load('Little Fighter 2','lf2.exe','lf2.exe');
    if( gProcess > 0 )then
    begin
        sbutton1.caption := '游戏已启动';
    end
    else
    begin
        sbutton1.caption := '游戏未启动';
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    if scheckbox1.checked  then
    begin
        change(1,$2fc,500);
    end;
    if scheckbox2.checked  then
    begin
        change(1,$308,500);
    end;
end;

end.
