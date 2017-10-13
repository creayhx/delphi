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
    procedure sButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PID : DWORD;
  hw : DWORD;
  gameProcess : DWORD;
  BaseAddr : DWORD;

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
            if(pm.szModule = 'hw.dll') then
            begin
                hw := Integer(pm.modBaseAddr);
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
        if( pe32.szExeFile = 'svencoop.exe' ) then
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
  baseAddr := hw + $D3B0C8;
end;

function writePlayer(read:Boolean;lastPoint:DWORD;value:DWORD):DWORD;
var
num,val: Integer;
rw : DWORD;
begin
    readProcessMemory(gameProcess,pointer(baseAddr),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $7c),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $4),@num,4,rw);
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

function writeWeapon(read:Boolean;lastPoint:DWORD;value:DWORD):DWORD;
var
num,val: Integer;
rw : DWORD;
begin
    readProcessMemory(gameProcess,pointer(baseAddr),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $7c),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $8c0),@num,4,rw);
    readProcessMemory(gameProcess,pointer(num + $7c),@num,4,rw);
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

procedure BinToHex(Buffer: PAnsiChar; Text: PAnsiChar; BufSize: Integer); assembler;  
const  
  Convert: array[0..15] of AnsiChar = AnsiString('0123456789ABCDEF');  
var  
  I: Integer;  
begin  
  for I := 0 to BufSize - 1 do  
  begin  
    Text[0] := Convert[Byte(Buffer[I]) shr 4];  
    Text[1] := Convert[Byte(Buffer[I]) and $F];  
    Inc(Text, 2);  
  end;
end;

Function FloatToHex(Value: single): string;  
var  
  l, i: integer;  
  HexText,tempHexText,temp: String;  
begin  
  SetLength(HexText, 2 * SizeOf(Value));  
  BinToHex(pchar(@Value), pchar(@HexText[1]), SizeOf(Value));  
  l := length(HexText);  
  for i := (l div 2) downto 1 do  
  begin  
    temp:=copy(HexText,(2*i-1),2);  
    tempHexText := tempHexText + temp;  
  end;  
    result := tempHexText;  
end;

function BytesToSingle(value:DWORD):Single;
var  
  bSingle:Dword;  
begin
  Result := PSingle(@bSingle)^;  
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

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    if( scheckbox1.Checked) then
    begin
        writePlayer(false,$160,$437F0000)
    end;
    if( scheckbox2.Checked) then
    begin
        writePlayer(false,$1BC,$437F0000)
    end;
    if( scheckbox3.Checked) then
    begin
        writeWeapon(false,$1A4,100)
    end;
    if( scheckbox4.Checked) then
    begin
        writeWeapon(false,$1B8,1)
    end;
    if( scheckbox5.Checked) then
    begin
        writeWeapon(false,$18c,$BF800000)
    end;
    if( scheckbox6.Checked) then
    begin
        writeWeapon(false,$190,$BF800000)
    end;
    if( scheckbox7.Checked) then
    begin
        writePlayer(false,$68,$80000000)
    end;


end;

end.
