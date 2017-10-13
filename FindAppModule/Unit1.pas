unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tlhelp32, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PID : DWORD;
  hw : DWORD;
  gameHandle : DWORD;
  
implementation

{$R *.dfm}

function EnumProcess():boolean;
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
        break;
        end;
        Process32Next(processRec, pe32)
    end;

end;

function EnumModule(PID:DWORD):Boolean;
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
            Module32Next(moduleRec,pm);
        end;
    CloseHandle(moduleRec);
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  EnumProcess();
  EnumModule(PID);
  gameHandle := openProcess
  showMessage(IntToStr(PID));
  showMessage(IntToStr(hw));
end;

end.
