unit Unit1;

interface

uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
StdCtrls, TLHelp32;
type

TForm1 = class(TForm)
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button1: TButton;
    Button2: TButton;

procedure Button1Click(Sender: TObject);
procedure FormCreate(Sender: TObject);
procedure ListBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
private
{ Private declarations }
public
{ Public declarations }
    FSnapshotHandle: THandle;
    ModuleArray: array of TModuleEntry32;
    function GetProcessID(var List: TStringList; FileName: string = ''): TProcessEntry32;
    function shows(arr:Array of String):Boolean;
end;

var
Form1: TForm1;
arr1 : Array[0..1] of String = ('1','1');

implementation
function shows(arr:Array of String):Boolean;
var
    i: Integer;
begin
    for i:= 0 to length(arr) do
    begin
        showMessage( arr[i] );
    end;
end;

{$R *.DFM}

function Tform1.GetProcessID(var List: TStringList; FileName: string = ''): TProcessEntry32;
var
    Ret: BOOL;
    s: string;
    FProcessEntry32: TProcessEntry32;
begin
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
    Ret := Process32First(FSnapshotHandle, FProcessEntry32);
while Ret do
begin
    s := ExtractFileName(FProcessEntry32.szExeFile);
if (FileName = '') then
    List.Add(PChar(s))
else if (AnsicompareText(Trim(s),Trim(FileName))=0) and (FileName <> '')  then
begin
    List.Add(Pchar(s));
    result := FProcessEntry32;
    break;
end;
    Ret := Process32Next(FSnapshotHandle, FProcessEntry32);
end;
    CloseHandle(FSnapshotHandle);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    FProcessEntry32: TProcessEntry32;
    PID: integer;
    List: TStringList;
    ModuleListHandle: Thandle;
    ModuleStruct: TMODULEENTRY32;
    J: integer;
    Yn: boolean;
begin
if Combobox1.itemindex = -1 then exit;
    List := TStringList.Create;
    FProcessEntry32 := GetProcessID(List, Combobox1.text);
    PID := FProcessEntry32.th32ProcessID;
    ModuleListHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, PID);
    ListBox1.Items.Clear;
    ModuleStruct.dwSize := sizeof(ModuleStruct);
    yn := Module32First(ModuleListHandle, ModuleStruct);
    j := 0;
while (yn) do
begin
    SetLength(ModuleArray, j + 1);
    ModuleArray[j] := ModuleStruct;
    ListBox1.Items.Add(ModuleStruct.szExePath);
    yn := Module32Next(ModuleListHandle, ModuleStruct);
    J := j + 1;
end;
    CloseHandle(ModuleListHandle);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    List: TStringList;
    i: integer;
begin
    Combobox1.clear;
    List := TStringList.Create;
    GetProcessID(List);
for i := 0 to List.Count - 1 do
begin
    Combobox1.items.add(Trim(List.strings[i]));
end;
    List.Free;
    Combobox1.itemindex := 0;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
    I: integer;
begin
    Listbox2.Clear;
if Listbox1.itemindex = -1 then exit;
    for i := 0 to Length(ModuleArray) do
    begin
        if UpperCase(Listbox1.items[Listbox1.itemindex]) = UpperCase(ModuleArray[i].szExePath) then
        begin
            Listbox2.Items.add('模块名称:' + ModuleArray[0].szModule);
            Listbox2.items.add('模块ID:' + IntToStr(ModuleArray[0].th32ModuleID));
            Listbox2.items.add('所属进程ID:' + IntToStr(ModuleArray[0].th32ProcessID));
            Listbox2.Items.add('全局使用数:' + intToStr(ModuleArray[0].GlblcntUsage));
            Listbox2.items.add('进程使用数:' + IntToStr(ModuleArray[0].ProccntUsage));
            ListBox2.items.add(format('模块基地址:%.8X' ,[Integer(ModuleArray[0].modBaseAddr)]));
            Listbox2.items.add(format('模块大小:%.8X' ,[ModuleArray[0].modBaseSize]));
            Listbox2.items.add(format('模块句柄:%.8X' ,[ModuleArray[0].hModule]));
            exit;
        end;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    show(arr1);
end;

end.
