unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sSkinManager, sButton, sCheckBox, sLabel,TLhelp32,
  sEdit, Buttons, sBitBtn;

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
    sCheckBox9: TsCheckBox;
    sCheckBox10: TsCheckBox;
    sCheckBox11: TsCheckBox;
    sCheckBox12: TsCheckBox;
    sButton4: TsButton;
    sCheckBox13: TsCheckBox;
    sEdit1: TsEdit;
    sBitBtn1: TsBitBtn;
    Timer4: TTimer;
    sButton5: TsButton;
    Timer5: TTimer;
    sCheckBox14: TsCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure sCheckBox6Click(Sender: TObject);
    procedure sCheckBox7Click(Sender: TObject);
    procedure sCheckBox9Click(Sender: TObject);
    procedure sCheckBox10Click(Sender: TObject);
    procedure sCheckBox11Click(Sender: TObject);
    procedure sCheckBox12Click(Sender: TObject);
    procedure sCheckBox5Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sCheckBox13Click(Sender: TObject);
    procedure sCheckBox8Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure sCheckBox4Click(Sender: TObject);
    procedure sButton5Click(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure sCheckBox14Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  maple:Thandle;
  gHandle:Thandle;
  index:Integer = 0;// 卖东西计数器
  itemType:Integer=0;
  pBase:Dword=$00BDD490;//游戏基址
  mBase: Dword=$00BDD498;//地址基址
  hmBase:Dword=$00BDD6F0;//血量地址
  wdState:Array[0..2] of Dword = ($00BE5174,$00BE5178,$00BE517C);
  wdValue:Array[0..2] of Dword = ($2BF1BDDB,$C95F8DC2,$7DEA7030);
  wdoffValue:Array[0..2] of Dword = ($CD2A85D3,$9E69542E,$92258FDC);

  superState:Array[0..3] of Dword = ($00BE5534,$00BE5538,$00BE553C,$00BE5540);
  superValue:Array[0..3] of Dword = ($71B1F125,$D38D83BD,$19E663C6,$773536DF);

  attkState:Array[0..2] of Dword = ($00BE4FAC,$00BE4FB0,$00BE4FB4);
  mttkState:Array[0..2] of Dword = ($00BE500C,$00BE5010,$00BE5014);
  accState:Array[0..2] of Dword = ($00BE506C,$00BE5070,$00BE5074);
  pddState:Array[0..2] of Dword = ($00BE4FDC,$00BE4FE0,$00BE4FE4);
  mddState:Array[0..2] of Dword = ($00BE503C,$00BE5040,$00BE5044);
  missState:Array[0..2] of Dword = ($00BE509C,$00BE50A0,$00BE50A4);

  attkValue:Array[0..2] of Dword = ($AE793347,$C576FB0A,$161DA124);

  rw:Dword;
  oldLeft,oldRight,oldUp,oldDown:Integer;// 储存地图旧坐标

implementation
  function GetHWndByPID(const hPID: THandle): THandle;
  //todo 通过PID获取句柄
  type
    PEnumInfo = ^TEnumInfo;
    TEnumInfo = record
    ProcessID: DWORD;
    HWND: THandle;
  end;

  function EnumWindowsProc(Wnd: DWORD; var EI: TEnumInfo): Bool; stdcall;
  //回调函数
  var
    PID: DWORD;
  begin
    GetWindowThreadProcessID(Wnd, @PID);
    Result := (PID <> EI.ProcessID) or
    (not IsWindowVisible(WND)) or
    (not IsWindowEnabled(WND));
  if not Result then EI.HWND := WND; 
  end;

  Function FindMainWindow(PID: DWORD): DWORD;
  var
    EI: TEnumInfo;
  begin
    EI.ProcessID := PID;
    EI.HWND := 0;
    EnumWindows(@EnumWindowsProc, Integer(@EI));
    Result := EI.HWND;
  end;
  begin
    if hPID<>0 then
     Result:=FindMainWindow(hPID)
    else
    Result:=0;
  end;


  Function searchGame():Dword;
  //获取游戏pid 和游戏句柄
  var
    ProcessName : string; //进程名
    FSnapshotHandle:THandle; //进程快照句柄
    FProcessEntry32:TProcessEntry32; //进程入口的结构体信息
    ContinueLoop:BOOL;
    MyHwnd:THandle;
  begin
    FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); //创建一个进程快照
    FProcessEntry32.dwSize:=Sizeof(FProcessEntry32);
    ContinueLoop:=Process32First(FSnapshotHandle,FProcessEntry32); //得到系统中第一个进程
    //循环例举
    while ContinueLoop do
    begin
      ProcessName := FProcessEntry32.szExeFile;
      if(ProcessName = 'MapleStory.exe') then begin
        MyHwnd := FProcessEntry32.th32ProcessID;
        gHandle:= GetHWndByPID(FProcessEntry32.th32ProcessID);
        result:=MyHwnd;
        break;
      end;
      ContinueLoop:=Process32Next(FSnapshotHandle,FProcessEntry32);
    end;
    CloseHandle(FSnapshotHandle); // 释放快照句柄
  end;

  Function getGame():Boolean;
  //todo 开始游戏
  var
    gamepid:Thandle;
  begin
    gamepid:=searchGame();
    maple:=openprocess(process_all_access,false,gamepid);
  end;

  Function write(addr,point,value:Integer):Integer;
  // 写入数据
  var
    num,val:Integer;
  begin
      readProcessMemory(maple,pointer(addr),@num,4,rw);
      writeProcessMemory(maple,pointer(num+point),@value,4,rw);
  end;

  Function read(addr,point:Integer):Integer;
  //读取数据
  var
    num,val:Integer;
  begin
    readProcessMemory(maple,pointer(addr),@num,4,rw);
    readProcessMemory(maple,pointer(num+point),@val,4,rw);
    result:= val;
  end;

  Function readHM(state:Integer):Integer;
  //读取血量蓝量百分比
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
  //todo 读取宠物血量
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
  // todo 模拟按键
  begin
    postMessage(gHandle,WM_keyDown,wP,lP);
    lP:= lP + $C0000000;
    postMessage(gHandle,WM_keyUp,wP,lP);
  end;
  Function mouseK(x,y:Integer):Boolean;
  // 模拟鼠标按键
  var
    point:TPoint;//当前鼠标位置
    mousePos:Integer;
  begin
    y:= y+30;
    setCursorPos(x,y);
    mousePos :=  StrToInt('$' + IntToHex( y ,4)  +''+ IntToHex( x,4));
    postMessage(gHandle,WM_LButtonDown,mousePos,1);
    postMessage(gHandle,WM_LButtonUp,mousePos,0);
  end;

  Function DropMeso():Boolean;
  // 丢钱
  var
    i,index:Integer;
    randoms:String;
  begin
    index := 0;
    randoms := IntToStr(random(10000));
    mouseK(643,273);
    sleep(50);
    for i := 0 to length(randoms) do
    begin
        postMessage(gHandle,WM_CHAR,Wparam(randoms[i]),0);
    end;
    //postmessage(gHandle,WM_Keydown,$26,$01480001);
    //postmessage(gHandle,WM_Keyup,$26,$C1480001);
    sleep(50);
    postmessage(gHandle,WM_Keydown,$D,$001C0001);
    postmessage(gHandle,WM_Keyup,$D,$C01C0001);
  end;

  Function wudi(state:Integer):Boolean;
  // todo 隐身 半无敌
  var
    i:Integer;
  begin
    if(state = 0)then
    begin
      for i:=0 to length(wdState)-1 do
      begin
        writeProcessMemory(maple,pointer(wdState[i]),@wdValue[i],4,rw);
      end;
    end
    else
    begin
      for i:=0 to length(wdState)-1 do
        begin
          writeProcessMemory(maple,pointer(wdState[i]),@wdoffValue[i],4,rw);
        end;
    end;

  end;

 Function attk():Boolean;
  // todo 攻击力
  var
    i:Integer;
  begin
    for i:=0 to length(attkState)-1 do
    begin
      writeProcessMemory(maple,pointer(attkState[i]),@attkValue[i],4,rw);
    end;
  end;

  Function Mttk():Boolean;
  // todo 魔力
  var
    i:Integer;
  begin
    for i:=0 to length(MttkState)-1 do
    begin
      writeProcessMemory(maple,pointer(MttkState[i]),@attkValue[i],4,rw);
    end;
  end;

  Function acc():Boolean;
  // todo 命中
  var
    i:Integer;
  begin
    for i:=0 to length(accState)-1 do
    begin
      writeProcessMemory(maple,pointer(accState[i]),@attkValue[i],4,rw);
    end;
  end;

  Function pdd():Boolean;
  // todo 物理防御
  var
    i:Integer;
  begin
    for i:=0 to length(pddState)-1 do
    begin
      writeProcessMemory(maple,pointer(pddState[i]),@attkValue[i],4,rw);
    end;
  end;

  Function mdd():Boolean;
  // todo 魔法防御
  var
    i:Integer;
  begin
    for i:=0 to length(mddState)-1 do
    begin
      writeProcessMemory(maple,pointer(mddState[i]),@attkValue[i],4,rw);
    end;
  end;

  Function miss():Boolean;
  // todo 回避率
  var
    i:Integer;
  begin
    for i:=0 to length(missState)-1 do
    begin
      writeProcessMemory(maple,pointer(missState[i]),@attkValue[i],4,rw);
    end;
  end;
  Function stopMove(state:Integer):Boolean;
  var
    num:Dword;
  begin
    if(state = 1) then
    begin
      num:= 0;
      writeProcessMemory(maple,pointer($00BE61C0),@num,4,rw);
    end
    else
    begin
      num:=$534436E4;
      writeProcessMemory(maple,pointer($00BE61C0),@num,4,rw);
    end;
  end;
  Function super():Boolean;
  // todo 超级属性
  var
    i:Integer;
  begin
    for i:=0 to length(superState)-1 do
    begin
      writeProcessMemory(maple,pointer(superState[i]),@superValue[i],4,rw);
    end;
  end;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    getGame();
    if(maple <> 0) then
    begin
       sLabel1.Caption:='找到游戏 ';
    end
    else
    begin
       sLabel1.Caption:='未找到游戏 ';
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
    if(readHM(0) < 50) then
    begin
        pressK($21,$01490001);
    end;
    if(readHM(1) < 50) then
    begin
        pressK($22,$01510001);
    end;
    if(readPetHp() < 50) then
    begin
        pressK($23,$014F0001);
    end;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
   getGame();
   if(maple <> 0) then
    begin
       sLabel1.Caption:='找到游戏 ';
    end
    else
    begin
       sLabel1.Caption:='未找到游戏 ';
    end;
end;


procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if scheckbox8.Checked then
  begin
    pressK($41,$001E0001);
  end;
end;


procedure TForm1.sCheckBox6Click(Sender: TObject);
begin
  if scheckbox6.checked then
  begin
    attk();
  end;
end;

procedure TForm1.sCheckBox7Click(Sender: TObject);
begin
  if scheckbox7.checked then
  begin
    mttk();
  end;
end;

procedure TForm1.sCheckBox9Click(Sender: TObject);
begin
  if scheckbox9.checked then
  begin
    acc();
  end;
end;

procedure TForm1.sCheckBox10Click(Sender: TObject);
begin
  if scheckbox10.checked then
  begin
    pdd();
  end;
end;

procedure TForm1.sCheckBox11Click(Sender: TObject);
begin
  if scheckbox11.checked then
  begin
    mdd();
  end;
end;

procedure TForm1.sCheckBox12Click(Sender: TObject);
begin
  if scheckbox12.checked then
  begin
    miss();
  end;
end;

procedure TForm1.sCheckBox5Click(Sender: TObject);
begin
  if scheckbox5.checked then
  begin
    wudi(0);
  end
  else
  begin
    wudi(1);
  end;
end;

procedure TForm1.sButton4Click(Sender: TObject);
begin
  if(sButton4.Caption = '增幅全开')then
  begin
    //sCheckBox6.checked:=true;
    //sCheckBox7.checked:=true;
    sCheckBox1.checked:=true;
    sCheckBox2.checked:=true;
    sCheckBox3.checked:=true;
    sCheckBox4.checked:=true;
    sCheckBox9.checked:=true;
    sCheckBox10.checked:=true;
    sCheckBox11.checked:=true;
    sCheckBox12.checked:=true;
    //sCheckBox13.checked:=true;
    sCheckBox14.checked:=true;
    sButton4.Caption := '增幅全关'
  end
  else
  begin
    //sCheckBox6.checked:=false;
    //sCheckBox7.checked:=false;
    sCheckBox1.checked:=false;
    sCheckBox2.checked:=false;
    sCheckBox3.checked:=false;
    sCheckBox4.checked:=false;
    sCheckBox9.checked:=false;
    sCheckBox10.checked:=false;
    sCheckBox11.checked:=false;
    sCheckBox12.checked:=false;
    //sCheckBox13.checked:=false;
    sCheckBox14.checked:=false;
    sButton4.Caption := '增幅全开'
  end;
end;

procedure TForm1.sCheckBox13Click(Sender: TObject);
begin
  if scheckbox13.checked then
  begin
    super();
  end;
end;

procedure TForm1.sCheckBox4Click(Sender: TObject);
begin
    if( scheckbox4.checked ) then
    begin
        timer2.Enabled := true;
    end
    else
    begin
        timer2.Enabled := false;
    end;
end;

procedure TForm1.sCheckBox8Click(Sender: TObject);
begin
  if( scheckbox8.checked ) then
  begin
    timer3.Interval := StrToInt(sedit1.text);
    timer3.enabled := true;
  end
  else
  begin
    timer3.enabled := false;
  end;
end;

procedure TForm1.sBitBtn1Click(Sender: TObject);
begin
    timer3.enabled:= false;
    sleep(5000);
    mouseK(685,585);
    sleep(500);
    mouseK(543,285);
    sleep(200);
    timer4.enabled := true;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
    if(index < 96) then
    begin
        index := index + 1;
        mouseK(485,429);
        sleep(50);
        mouseK(590,155);
        sleep(50);
        mouseK(450,330);
        sleep(50);
    end
    else
    begin
        if(itemType >= 1)then
        begin
            if(itemType >= 2) then
            begin
                index:=0;
                itemType:=0;
                mouseK(360,155);
                timer4.enabled:=false;
                timer3.enabled := true;
            end
            else
            begin
                index:=0;
                mouseK(560,238);
                itemType:= itemType+1;
            end;

        end
        else
        begin
            index:=0;
            mouseK(474,237);
            itemType:= itemType+1;
        end;
    end;
end;

procedure TForm1.sButton5Click(Sender: TObject);
begin
    DropMeso();
end;

procedure TForm1.Timer5Timer(Sender: TObject);
begin
    sBitBtn1.click;
end;

procedure TForm1.sCheckBox14Click(Sender: TObject);
begin
    if scheckbox14.Checked then
    begin
        timer5.Enabled := true;
    end
    else
    begin
        timer5.Enabled := false;
    end;
end;

end.
