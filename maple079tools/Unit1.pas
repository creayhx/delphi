unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sSkinManager, sButton, sCheckBox, sLabel;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    sSkinManager1: TsSkinManager;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sButton1: TsButton;
    sButton2: TsButton;
    sLabel1: TsLabel;
    sCheckBox4: TsCheckBox;
    Timer2: TTimer;
    sButton3: TsButton;
    sCheckBox5: TsCheckBox;
    sCheckBox6: TsCheckBox;
    sCheckBox7: TsCheckBox;
    Timer3: TTimer;
    sCheckBox8: TsCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sCheckBox5Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  maple:Thandle;
  gHandle:Thandle;
  pBase:Dword=$00BDD490;//��Ϸ��ַ
  mBase: Dword=$00BDD498;//��ַ��ַ
  hmBase:Dword=$00BDD6F0;//Ѫ����ַ
  wdState:Array[0..2] of Dword = ($00BE5174,$00BE5178,$00BE517C);
  wdValue:Array[0..2] of Dword = ($2BF1BDDB,$C95F8DC2,$7DEA7030);
  attkState:Array[0..2] of Dword = ($00BE4FAC,$00BE4FB0,$00BE4FB4);
  mttkState:Array[0..2] of Dword = ($00BE500C,$00BE5010,$00BE5014);
  attkValue:Array[0..2] of Dword = ($AE793347,$C576FB0A,$161DA124);
  rw:Dword;
  oldLeft,oldRight,oldUp,oldDown:Integer;// �����ͼ������

implementation

  Function getGame():Boolean;
  //todo ��ʼ��Ϸ
  var
    gamepid:Thandle;
  begin
    gHandle:=findwindow(nil,'���ð�յ���ӭ��');//MapleStory
    GetWindowThreadProcessId(gHandle,@gamepid);
    maple:=openprocess(process_all_access,false,gamepid);
  end;

  Function write(addr,point,value:Integer):Integer;
  // д������
  var
    num,val:Integer;
  begin
      readProcessMemory(maple,pointer(addr),@num,4,rw);
      writeProcessMemory(maple,pointer(num+point),@value,4,rw);
  end;

  Function read(addr,point:Integer):Integer;
  //��ȡ����
  var
    num,val:Integer;
  begin
    readProcessMemory(maple,pointer(addr),@num,4,rw);
    readProcessMemory(maple,pointer(num+point),@val,4,rw);
    result:= val;
  end;

  Function readHM(state:Integer):Integer;
  //��ȡѪ�������ٷֱ�
  var
    num,val:Integer;
  begin
    readProcessMemory(maple,pointer(hmBase),@num,4,rw);
    if(state = 0 ) then
    begin
       readProcessMemory(maple,pointer(num+$b54),@num,4,rw);
    end
    else
    begin
      readProcessMemory(maple,pointer(num+$b58),@num,4,rw);
    end;
    readProcessMemory(maple,pointer(num+$40),@num,4,rw);
    readProcessMemory(maple,pointer(num+$24),@num,4,rw);
    readProcessMemory(maple,pointer(num+$1c),@num,4,rw);
    readProcessMemory(maple,pointer(num+$24),@num,4,rw);
    readProcessMemory(maple,pointer(num+$68),@val,4,rw);
    if(state = 0 ) then
    begin
       result:=val - 225;
    end
    else
    begin
      result:=val - 333;
    end;
  end;

  Function readPetHp():Integer;
  //todo ��ȡ����Ѫ��
  var
  num,val:Integer;
  begin
    readProcessMemory(maple,pointer(pBase),@num,4,rw);
    readProcessMemory(maple,pointer(num+$1BB4),@num,4,rw);
    readProcessMemory(maple,pointer(num+$04),@num,4,rw);
    readProcessMemory(maple,pointer(num+$AC),@val,4,rw);
    result:=val;
  end;

  Function pressK(wP,lP:Integer):boolean;
  // todo ģ�ⰴ��
  begin
    postMessage(gHandle,WM_keyDown,wP,lP);
    lP:= lP + $C0000000;
    postMessage(gHandle,WM_keyUp,wP,lP);
  end;

  Function wudi():Boolean;
  // todo ���� ���޵�
  var
    i:Integer;
  begin
    for i:=0 to length(wdState)-1 do
    begin
      writeProcessMemory(maple,pointer(wdState[i]),@wdValue[i],4,rw);
    end;
  end;

  Function attk():Boolean;
  // todo ������������
  var
    i:Integer;
  begin
    for i:=0 to length(attkState)-1 do
    begin
      writeProcessMemory(maple,pointer(attkState[i]),@attkValue[i],4,rw);
    end;
  end;

  Function Mttk():Boolean;
  // todo ħ����������
  var
    i:Integer;
  begin
    for i:=0 to length(MttkState)-1 do
    begin
      writeProcessMemory(maple,pointer(MttkState[i]),@attkValue[i],4,rw);
    end;
  end;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    getGame();
    if(maple <> 0) then
    begin
       sLabel1.Caption:='�ҵ���Ϸ ';
    end
    else
    begin
       sLabel1.Caption:='δ�ҵ���Ϸ ';
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    if scheckbox1.checked then
    begin
        write(pBase,$3bc,0);
    end;

    if scheckbox2.checked then
    begin
        write(pBase,$3c4,4294967295);
    end;

    if scheckbox3.checked then
    begin
        write(pBase,$2964,0);
    end;

    if scheckbox5.checked then
    begin
      wudi();
    end;

    if scheckbox6.checked then
    begin
      attk();
    end;

    if scheckbox7.checked then
    begin
      mttk();
    end;

end;


procedure TForm1.sButton1Click(Sender: TObject);
var
  PlayerX,PlayerY:Integer;
begin
  oldLeft:=read(mBase,$24);
  oldRight:=read(mBase,$2c);
  oldUp:=read(mBase,$28);
  oldDown:=read(mBase,$30);
  PlayerX:=read(pBase,$2ed4);
  PlayerY:=read(pBase,$2ed8);
  write(mBase,$24,PlayerX);
  write(mBase,$2c,PlayerX);
  write(mBase,$28,PlayerY);
  write(mBase,$30,PlayerY);
end;

procedure TForm1.sButton2Click(Sender: TObject);
begin
  write(mBase,$24,oldLeft);
  write(mBase,$2c,oldRight);
  write(mBase,$28,oldUp);
  write(mBase,$30,oldDown);
end;



procedure TForm1.Timer2Timer(Sender: TObject);
begin
    if scheckbox4.checked then
    begin
        if(readHM(0) < 50) then
        begin
          pressK($21,$01490001);
        end;
        if(readHM(1) < 50) then
        begin
          pressK($22,$01510001);
        end;
        if(readPetHp() < 30) then
        begin
          pressK($23,$014F0001);
        end;
    end;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
   getGame();

end;


procedure TForm1.sCheckBox5Click(Sender: TObject);
begin
  wudi();
end;



procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if scheckbox8.Checked then
  begin
    pressK($41,$001E0001);
  end;
end;


end.