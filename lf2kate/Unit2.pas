unit Unit2;

interface
    uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,tlhelp32;
    Function EnumProcess(processName:String):Integer;
    function EnumModule(PID:Integer;DllName:String):Integer;
    Function load(gameTitle:pAnsiChar;gameName,dllName:String):Boolean;
    Function pressK(wP,lP:Integer):boolean;
    Function mouseK(x,y:Integer):Boolean;
  var
    gProcess,gHandle,dllBaseAddr:Integer;
    RB:DWORD;

implementation

Function EnumModule(PID:Integer;DllName:String):Integer;
// ��ȡָ�������е�dll ģ�������ַ
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
            if(pm.szModule = DllName) then
            begin
                result := Integer(pm.modBaseAddr);
                break;
            end;
            Ret := Module32Next(moduleRec,pm);
        end;
end;
Function EnumProcess(processName:String):Integer;
//��ȡ���н���
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
        if( pe32.szExeFile = processName ) then
        begin
        result := pe32.th32ProcessID;
        break;
        end;
        Ret := Process32Next(processRec, pe32);
    end;
end;

Function load(gameTitle:pAnsiChar;gameName,dllName:String):Boolean;
var
    pid:Integer;
begin
    pid := EnumProcess(gameName);
    gProcess := openProcess(process_all_access,false,pid);
    dllBaseAddr := EnumModule(pid,dllName);
    gHandle := findWindow(nil,gameTitle);
end;
Function pressK(wP,lP:Integer):boolean;
  // todo ģ�ⰴ��
  begin
    postMessage(gHandle,WM_keyDown,wP,lP);
    lP:= lP + $C0000000;
    postMessage(gHandle,WM_keyUp,wP,lP);
  end;
Function mouseK(x,y:Integer):Boolean;
  // ģ����갴��
  var
    point:TPoint;//��ǰ���λ��
    mousePos:Integer;
  begin
    y:= y+30;
    setCursorPos(x,y);
    mousePos :=  StrToInt('$' + IntToHex( y ,4)  +''+ IntToHex( x,4));
    postMessage(gHandle,WM_LButtonDown,mousePos,1);
    postMessage(gHandle,WM_LButtonUp,mousePos,0);
  end;
end.