unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, StdCtrls, sGroupBox, ComCtrls, sPageControl, Menus,
  sButton, sLabel, sEdit, sCheckBox, sRadioButton;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sGroupBox1: TsGroupBox;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sButton5: TsButton;
    sButton6: TsButton;
    sButton7: TsButton;
    sButton8: TsButton;
    sButton9: TsButton;
    sButton10: TsButton;
    sGroupBox2: TsGroupBox;
    sLabel1: TsLabel;
    sTabSheet2: TsTabSheet;
    sGroupBox3: TsGroupBox;
    sRadioButton1: TsRadioButton;
    sRadioButton2: TsRadioButton;
    sRadioButton3: TsRadioButton;
    sRadioButton4: TsRadioButton;
    sEdit1: TsEdit;
    sButton11: TsButton;
    sButton13: TsButton;
    sTabSheet3: TsTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton5Click(Sender: TObject);
    procedure sButton6Click(Sender: TObject);
    procedure sButton7Click(Sender: TObject);
    procedure sButton8Click(Sender: TObject);
    procedure sButton9Click(Sender: TObject);
    procedure sButton10Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sButton11Click(Sender: TObject);
    procedure sButton13Click(Sender: TObject);

  private
    { Private declarations }
  procedure HotKeyDown(var Msg: Tmessage);message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gamehandle:Thandle;
  HotKeyid:integer;
implementation
Function code(MingLing:String):Integer;
var
i:Integer;
begin
  postmessage(gamehandle,WM_Keydown,$D,$001C0001);
  postmessage(gamehandle,WM_Keyup,$D,$C01C0001);
  MingLing:=MingLing + ' ' + IntToStr(Random(10000));
  For i:= 1 to length(MingLing) do
  begin
    PostMessage(gamehandle,WM_Char,Wparam(MingLing[i]),0);
  end;
  postmessage(gamehandle,WM_Keydown,$D,$001C0001);
  postmessage(gamehandle,WM_Keyup,$D,$C01C0001);
  postmessage(gamehandle,WM_Keydown,$D,$001C0001);
  postmessage(gamehandle,WM_Keyup,$D,$C01C0001);
end;

{$R *.dfm}



procedure TForm1.FormCreate(Sender: TObject);
begin
    gamehandle:=Findwindow(nil,'MapleStory');
    hotkeyid:=globaladdatom('Myhotkey');
    registerhotkey(handle,hotkeyid,0,VK_F1);
    registerhotkey(handle,hotkeyid,0,VK_F2);
    registerhotkey(handle,hotkeyid,0,VK_F3);
    registerhotkey(handle,hotkeyid,0,VK_F4);
    registerhotkey(handle,hotkeyid,0,VK_F5);
end;

procedure TForm1.HotKeyDown(var Msg:Tmessage);
begin
if (Msg.LparamLo = 0) AND (Msg.LParamHi = VK_F1) then // 假设热键为ALT+F8
begin
  sbutton1.Click;
end;
if (Msg.LparamLo = 0) AND (Msg.LParamHi = VK_F2) then // 假设热键为ALT+F8
begin
  sbutton2.Click;
end;
if (Msg.LparamLo = 0) AND (Msg.LParamHi = VK_F3) then // 假设热键为ALT+F8
begin
  sbutton3.Click;
end;
if (Msg.LparamLo = 0) AND (Msg.LParamHi = VK_F4) then // 假设热键为ALT+F8
begin
  sbutton4.Click;
end;
if (Msg.LparamLo = 0) AND (Msg.LParamHi = VK_F5) then // 假设热键为ALT+F8
begin
  sbutton5.Click;
end;
end;
procedure TForm1.sButton1Click(Sender: TObject);
begin
 code('!gxfz');

end;

procedure TForm1.sButton2Click(Sender: TObject);
begin
   code('!healmap');

end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
  code('!sha');

end;

procedure TForm1.sButton4Click(Sender: TObject);
begin
  code('!qc');

end;

procedure TForm1.sButton5Click(Sender: TObject);
begin
  code('@wnnpc');

end;

procedure TForm1.sButton6Click(Sender: TObject);
begin
  code('!killmap');
end;

procedure TForm1.sButton7Click(Sender: TObject);
begin
  code('@ziyou')
end;

procedure TForm1.sButton8Click(Sender: TObject);
begin
  code('@cknpc')
end;

procedure TForm1.sButton9Click(Sender: TObject);
begin
  code('@jiasi')
end;

procedure TForm1.sButton10Click(Sender: TObject);
begin
  code('@expfix')
end;



procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UnRegisterHotKey(handle, HotKeyId);
end;





procedure TForm1.sButton11Click(Sender: TObject);
begin
if sradiobutton1.Checked then
begin
code('!allocate str '+ sedit1.text);
end;
if sradiobutton2.Checked then
begin
code('!allocate dex '+ sedit1.text);
end;
if sradiobutton3.Checked then
begin
code('!allocate int '+ sedit1.text);
end;
if sradiobutton4.Checked then
begin
  code('!allocate luk '+ sedit1.text);
end;
end;



procedure TForm1.sButton13Click(Sender: TObject);
begin
if sradiobutton1.Checked then
begin
code('!allocate str -'+ sedit1.text);
end;
if sradiobutton2.Checked then
begin
code('!allocate dex -'+ sedit1.text);
end;
if sradiobutton3.Checked then
begin
code('!allocate int -'+ sedit1.text);
end;
if sradiobutton4.Checked then
begin
  code('!allocate luk -'+ sedit1.text);
end;
end;






end.
