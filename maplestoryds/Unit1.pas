unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sSkinManager, StdCtrls, sLabel, sGroupBox, sButton,
  sEdit, sCheckBox, Menus,Unit2;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    sSkinManager1: TsSkinManager;
    sGroupBox1: TsGroupBox;
    sLabel4: TsLabel;
    sLabel3: TsLabel;
    sLabel2: TsLabel;
    sLabel1: TsLabel;
    sEdit1: TsEdit;
    sEdit2: TsEdit;
    sEdit3: TsEdit;
    sEdit4: TsEdit;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sLabel6: TsLabel;
    sEdit6: TsEdit;
    sButton6: TsButton;
    sLabel7: TsLabel;
    sEdit7: TsEdit;
    sButton7: TsButton;
    sLabel8: TsLabel;
    sEdit8: TsEdit;
    sButton8: TsButton;
    sButton9: TsButton;
    sGroupBox2: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sLabel9: TsLabel;
    sEdit9: TsEdit;
    sEdit10: TsEdit;
    sButton10: TsButton;
    sLabel5: TsLabel;
    Timer2: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure sButton9Click(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton6Click(Sender: TObject);
    procedure sButton7Click(Sender: TObject);
    procedure sButton8Click(Sender: TObject);
    procedure sButton10Click(Sender: TObject);

    procedure sButton11Click(Sender: TObject);
    procedure N4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gamehandle,gamepid,mapleds:Integer;
  //窗口句柄 窗口pid  打开进程标识符
  rw:Dword;
  atk:Boolean=false;
  def:boolean=false;
  atkb1,atkb2,defb1,defb2:Integer;
implementation
const
  str: array[1..5] of integer = (1,1,1,1,1);//定义数组

function cheat(change,gamehandle,num,bit:Integer):Integer;
var
    num1,num2:Integer;
begin
    If change = 1 then
begin
    writeprocessmemory(mapleds,pointer(gamehandle),@num,bit,rw);
end;
if change = 0 then
begin
    readprocessmemory(mapleds,pointer(gamehandle),@num2,bit,rw);
    result:=num2;
end;

end;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
gamehandle:=findwindow(nil,'DeSmuME 0.9.7 x86');
GetWindowThreadProcessId(gamehandle,@gamepid);
mapleds:=openprocess(process_all_access,false,gamepid);
end;



procedure TForm1.N2Click(Sender: TObject);
begin
form2.show;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
num:Integer;
begin
    if scheckbox1.Checked then
    begin
        cheat(1,$00E7BDAC,70,1);
    end;
    if scheckbox2.Checked then
    begin
        num:=cheat(0,$00E7B898,0,4);
        cheat(1,$00E7B894,num,4);
    end;
    if scheckbox3.Checked then
    begin
        num:=cheat(0,$00E7B89E,0,4);
        cheat(1,$00E7B89C,num,4);
    end;
    if scheckbox4.Checked then
    begin
        cheat(1,$00E7B8AC,99999,4);
        cheat(1,$00E7B8B4,99999,4);
    end;
    if scheckbox5.Checked then
    begin
        cheat(1,$00E7B8B0,99999,4);
        cheat(1,$00E7B8B8,99999,4);
    end;

end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
    playerx,playery:Integer;
begin
    playerx:= cheat(0,$00E7BC30,0,4) div 10000;
    playery:= cheat(0,$00E7BC34,0,4) div 10000;
    slabel9.Caption:='人物坐标 X:= '+ Inttostr(playerx) + 'Y:= ' + Inttostr(playery);
end;

procedure TForm1.sButton9Click(Sender: TObject);
var
    time,hp,maxhp,mp,maxmp,exp,money:Integer;
begin
    time:=cheat(0,$00E7B8CC,0,4);
    hp:=cheat(0,$00E7B894,0,4);
    maxhp:=cheat(0,$00E7B898,0,4);
    mp:=cheat(0,$00E7B89C,0,2);
    maxmp:=cheat(0,$00E7B89E,0,2);
    exp:=cheat(0,$00E7B88C,0,4);
    money:=cheat(0,$00E7B8C8,0,4);
    sedit1.Text:=Inttostr(time);
    sedit2.Text:=Inttostr(hp);
    sedit3.Text:=Inttostr(maxhp);
    sedit4.Text:=Inttostr(mp);
    sedit6.Text:=Inttostr(maxmp);
    sedit7.Text:=Inttostr(exp);
    sedit8.Text:=Inttostr(money);
end;

procedure TForm1.sButton1Click(Sender: TObject);
begin
    cheat(1,$00E7B8CC,strtoint(sedit1.text),4);
end;

procedure TForm1.sButton2Click(Sender: TObject);//cheat hp
begin
    cheat(1,$00E7B894,strtoint(sedit2.text),4);
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
    cheat(1,$00E7B898,strtoint(sedit3.text),4);
end;

procedure TForm1.sButton4Click(Sender: TObject);
begin
    cheat(1,$00E7B89C,strtoint(sedit4.text),2);
end;

procedure TForm1.sButton6Click(Sender: TObject);
begin
    cheat(1,$00E7B89E,strtoint(sedit6.text),2);
end;

procedure TForm1.sButton7Click(Sender: TObject);
begin
    cheat(1,$00E7B88C,strtoint(sedit7.text),4);
end;

procedure TForm1.sButton8Click(Sender: TObject);
begin
    cheat(1,$00E7B8C8,strtoint(sedit8.text),4);
end;

procedure TForm1.sButton10Click(Sender: TObject);
var
    plx,ply:Integer;
begin

    if sedit9.text <>'' then
    begin
        plx:=strtoint(sedit9.text) * 10000;
        cheat(1,$00E7BC30,plx,4);
    end;
    if sedit10.text <>'' then
    begin
        ply:=strtoint(sedit10.text) * 10000;
        cheat(1,$00E7BC34,ply,4);
    end;
end;


procedure TForm1.sButton11Click(Sender: TObject);
begin
    if sbutton6.Caption = '超级防御(关)' then
    begin
        sbutton6.Caption:= '超级防御(开)';
        def:=true;//攻击力备份开关
        defb1:=cheat(0,$00E7B8B0,0,4);
        defb2:=cheat(0,$00E7B8B8,0,4);
    end
    else
    begin
        sbutton6.Caption:= '超级防御(关)';
    end;
end;


procedure TForm1.N4Click(Sender: TObject);
begin
    showmessage('只需要更换一下装备就可以还原');
end;

end.
