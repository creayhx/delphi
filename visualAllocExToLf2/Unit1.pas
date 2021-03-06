unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton,TlHelp32;

type
  TForm1 = class(TForm)
    sButton1: TsButton;
    sButton2: TsButton;
    procedure sButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dll,gameProcess,PID,baseAddr : Dword;
  visualAddr:Pointer;
implementation

{$R *.dfm}
function EnumModule(PID:DWORD;dName:String):Boolean;
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
            if(pm.szModule = dName) then
            begin
                dll := Integer(pm.modBaseAddr);
                break;
            end;
            Ret := Module32Next(moduleRec,pm);
        end;
    CloseHandle(moduleRec);
end;
function EnumProcess(gName,dName:String):boolean;
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
        if( pe32.szExeFile = gName ) then
        begin
        PID := pe32.th32ProcessID;
        EnumModule(PID,dName);
        break;
        end;
        Ret := Process32Next(processRec, pe32);
    end;
end;
function loadGame():Boolean;
//初始化游戏
begin
  EnumProcess('lf2.exe','lf2.exe');
  gameProcess := openprocess(process_all_access,false,PID);
  baseAddr := dll + $58C94;
end;

procedure TForm1.sButton1Click(Sender: TObject);
var
    buff : Array[0..3] of byte;
    num,val,len:Integer;
    RB:DWORD;
begin
    num := $FFCC0000;
    //showMessage('基址是'+ IntToStr( baseAddr ) );
    //visualAddr := VirtualAllocEx(gameProcess,nil,$100,MEM_COMMIT,PAGE_EXECUTE_READWRITE);
    //writeProcessmemory( gameProcess,Pointer(visualAddr),@num,sizeof(num), RB);
    //showMessage( '虚拟地址' + IntToStr( Integer( visualAddr ) ) );

    move(num,buff[0],4);
    showMessage( IntToStr( buff[0] ) );
    showMessage( IntToStr( buff[1] ) );
    showMessage( IntToStr( buff[2] ) );
    showMessage( IntToStr( buff[3] ) );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    loadGame();
    if( PID > 0 ) then
    begin
        
    end;
end;

procedure TForm1.sButton2Click(Sender: TObject);
begin
    VirtualFreeEx(gameProcess,visualAddr,0,MEM_RELEASE);
end;

end.
 