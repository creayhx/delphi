unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tlhelp32, StdCtrls, sSkinManager, sButton, sLabel, sGroupBox,
  sCheckBox, ExtCtrls;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    sButton1: TsButton;
    sLabel1: TsLabel;
    sGroupBox1: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    sCheckBox6: TsCheckBox;
    sCheckBox7: TsCheckBox;
    sCheckBox8: TsCheckBox;
    Timer1: TTimer;
    sButton2: TsButton;
    sCheckBox9: TsCheckBox;
    procedure sButton1Click(Sender: TObject);
    procedure sCheckBox3Click(Sender: TObject);
    procedure sCheckBox4Click(Sender: TObject);
    procedure sCheckBox5Click(Sender: TObject);
    procedure sCheckBox6Click(Sender: TObject);
    procedure sCheckBox7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sCheckBox8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sCheckBox9Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PID : DWORD;
  server : DWORD;
  gameProcess : DWORD;
  BaseAddr : DWORD;
  // 子弹不减
  ammorOpen : Array[0..5] of byte = ($90,$90,$90,$90,$90,$90);

  pistolOff : Array[0..5] of byte = ($89,$9E,$C4,$04,$00,$00); //手枪
  RevolverOpen : Array[0..1] of byte = ($90,$90);
  RevolverOff : Array[0..1] of byte = ($89,$10);
  smgOff : Array[0..5] of byte = ($89,$AE,$C4,$04,$00,$00);
  GrenadeOpen : Array[0..6] of byte = ($90,$90,$90,$90,$90,$90,$90);
  GrenadeOff :  Array[0..6] of byte = ($89,$9C,$BE,$30,$06,$00,$00);
  BulletOff : Array[0..5] of byte = ($89,$9F,$C4,$04,$00,$00);
  oxyGenOff : Array[0..5] of byte = ($89,$86,$30,$0D,$00,$00);
implementation


{$R *.dfm}
function EnumModule(PID:DWORD):Boolean;
// 获取指定进程中的dll 模块基础地址
var
    moduleRec : Thandle;
    pm : TModuleEntry32;
    Ret : boolean;
begin
    moduleRec := CreateToolHelp32Snapshot(TH32CS_SNAPMODULE,PID);
    pm.dwSize := sizeof(TModuleEntry32);
    Ret := module32First(moduleRec,pm);
        while Ret do
        begin
            if(pm.szModule = 'server.dll') then
            begin
                server := Integer(pm.modBaseAddr);
                break;
            end;
            Ret := Module32Next(moduleRec,pm);
        end;
    CloseHandle(moduleRec);
end;

function EnumProcess():boolean;
//获取所有进程
var
    processRec:Thandle;
    pe32:TPROCESSENTRY32;
    Ret : Boolean;
begin
    processRec := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS,0);
    pe32.dwSize := sizeof(TPROCESSENTRY32);
    Ret := Process32First(processRec, pe32);
    while Ret do
    begin
        if( pe32.szExeFile = 'hl2.exe' ) then
        begin
        PID := pe32.th32ProcessID;
        EnumModule(PID);
        break;
        end;
        Ret := Process32Next(processRec, pe32);
    end;

end;


function loadInitGame():Boolean;
//初始化游戏
begin
  EnumProcess();
  gameProcess := openprocess(process_all_access,false,PID);
end;

function writeAmmor(point:Integer; arr: Array of byte):Boolean;
//修改子弹不减
var
    i:Integer;
    rw:DWORD;

begin
    for i:= 0 to length(arr)-1 do
    begin
        writeProcessMemory(gameProcess,pointer(server + point + i),@arr[i],sizeof(arr[i]),rw);
    end;
end;

function writePlayer(read:Boolean;lastPoint:DWORD;value:DWORD):DWORD;
var
num,val: Integer;
rw : DWORD;
begin
    readProcessMemory(gameProcess,pointer(server + $566EDC),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $16c),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $c),@num,4,rw);
    if( read ) then
    begin
        readProcessMemory(gameProcess,pointer(num + lastPoint),@val,4,rw);
        result:=val;
    end
    else
    begin
        writeProcessMemory(gameProcess,pointer(num + lastPoint),@value,4,rw);
    end;
end;

procedure TForm1.sButton1Click(Sender: TObject);

begin
    loadInitGame();
    if( PID > 0) then
    begin
        slabel1.Caption := '加载成功';
    end
    else
    begin
        slabel1.Caption := '未加载';
    end;
end;

procedure TForm1.sCheckBox3Click(Sender: TObject);
begin
    //手枪子弹不减
    if( scheckbox3.checked ) then
    begin
        writeAmmor($226BA6,ammorOpen);
    end
    else
    begin
        writeAmmor($226BA6,pistolOff);
    end;
end;

procedure TForm1.sCheckBox4Click(Sender: TObject);
begin
    //左轮子弹不减
    if( scheckbox4.checked ) then
    begin
        writeAmmor($1622A3,RevolverOpen);
    end
    else
    begin
        writeAmmor($1622A3,RevolverOff);
    end
end;

procedure TForm1.sCheckBox5Click(Sender: TObject);
begin
    if( scheckbox5.checked ) then
    begin
        writeAmmor($354FE,ammorOpen);
    end
    else
    begin
        writeAmmor($354FE,smgOff);
    end
end;

procedure TForm1.sCheckBox6Click(Sender: TObject);
begin
    if( scheckbox6.checked ) then
    begin
        writeAmmor($222D59,GrenadeOpen);
    end
    else
    begin
        writeAmmor($222D59,GrenadeOff);
    end
end;

procedure TForm1.sCheckBox7Click(Sender: TObject);
begin
    if( scheckbox7.checked ) then
    begin
        writeAmmor($17C0C5,ammorOpen);
    end
    else
    begin
        writeAmmor($17C0C5,BulletOff);
    end

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    loadInitGame();
    if( PID > 0) then
    begin
        slabel1.Caption := '加载成功';
    end
    else
    begin
        slabel1.Caption := '未加载';
    end;
end;

procedure TForm1.sCheckBox8Click(Sender: TObject);
begin
    if( scheckbox8.checked ) then
    begin
        writeAmmor($167F38,ammorOpen);
    end
    else
    begin
        writeAmmor($167F38,pistolOff);
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    if( scheckbox1.checked ) then
    begin
        writePlayer(false,$9c,$ff);
    end;
    if( scheckbox2.checked ) then
    begin
        writePlayer(false,$BB4,$ff);
    end;
end;



procedure TForm1.sButton2Click(Sender: TObject);
begin
    if( sButton2.Caption = '开启子弹不减' ) then
    begin
        scheckbox3.Checked := true;
        scheckbox4.Checked := true;
        scheckbox5.Checked := true;
        scheckbox6.Checked := true;
        scheckbox7.Checked := true;
        scheckbox8.Checked := true;
        sButton2.Caption:='关闭子弹不减'
    end
    else
    begin
        scheckbox3.Checked := false;
        scheckbox4.Checked := false;
        scheckbox5.Checked := false;
        scheckbox6.Checked := false;
        scheckbox7.Checked := false;
        scheckbox8.Checked := false;
        sButton2.Caption:='开启子弹不减'

    end;
end;

procedure TForm1.sCheckBox9Click(Sender: TObject);
begin
    if( scheckbox9.Checked ) then
    begin
        writeAmmor($5E360,ammorOpen);
    end
    else
    begin
        writeAmmor($5E360,oxyGenOff);
    end;
end;

end.
