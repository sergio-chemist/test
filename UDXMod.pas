unit UDXMod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, FileCtrl, Buttons, Menus;

const
  id_DirName = 0;
  id_PkgName = 1;
  id_SrcName = 2;
  id_IncFile = 3;

type
  TfrmDXMod = class(TForm)
    pcPages: TPageControl;
    tsData: TTabSheet;
    tsMod: TTabSheet;
    reData: TRichEdit;
    lbeTagValue: TLabeledEdit;
    lbeIncFileName: TLabeledEdit;
    dlgOpenProj: TOpenDialog;
    btnSelect: TButton;
    sbProjectName: TStatusBar;
    btnFind: TButton;
    lbeInsValue: TLabeledEdit;
    btnInsert: TButton;
    lbeTextPos: TLabeledEdit;
    dlgSaveProj: TSaveDialog;
    btnSave: TButton;
    tsFiles: TTabSheet;
    gbxFiles: TGroupBox;
    pnlDirFiles: TPanel;
    pnlDirs: TPanel;
    dlbDirs: TDirectoryListBox;
    dcbDrives: TDriveComboBox;
    Splitter1: TSplitter;
    fcbFilter: TFilterComboBox;
    pnlFiles: TPanel;
    flbFiles: TFileListBox;
    edDirName: TEdit;
    sbnApplyDir: TSpeedButton;
    edFileName: TEdit;
    sbnApplyFile: TSpeedButton;
    tsList: TTabSheet;
    lvFiles: TListView;
    pnlFileList: TPanel;
    btnSearchFiles: TButton;
    btnProcessFiles: TButton;
    cbxCopyIncFile: TCheckBox;
    Splitter2: TSplitter;
    lvDirNames: TListView;
    lbePkgDirName: TLabeledEdit;
    lbeSrcDirName: TLabeledEdit;
    lbeProjExt: TLabeledEdit;
    lbeIncFile: TLabeledEdit;
    btnProcessOneFile: TButton;
    lbePkgVer: TLabeledEdit;
    mePackageName: TMemo;
    SpeedButton1: TSpeedButton;
    pmFiles: TPopupMenu;
    mnuGetFileList: TMenuItem;
    mnuAsDelimList: TMenuItem;
    mnuSyncroItem: TMenuItem;
    edPrefix: TEdit;
    lblPrefix: TLabel;
    mnuPutIntoEditBox: TMenuItem;
    mnuOnlySelected: TMenuItem;
    pmDirNames: TPopupMenu;
    mnuSelectFileItems: TMenuItem;
    mnuUsePrefix: TMenuItem;
    mnuFindPackage: TMenuItem;
    lblCount: TLabel;
    mnu_GetFileList: TMenuItem;
    mnuGetFileItems: TMenuItem;
    cbxUseDelphiBplPath: TCheckBox;
    edDelphiBplPath: TEdit;
    procedure btnSelectClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure dlbDirsChange(Sender: TObject);
    procedure edDirNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure sbnApplyDirClick(Sender: TObject);
    procedure flbFilesChange(Sender: TObject);
    procedure flbFilesDblClick(Sender: TObject);
    procedure btnSearchFilesClick(Sender: TObject);
    procedure btnProcessFilesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnProcessOneFileClick(Sender: TObject);
    procedure lvFilesClick(Sender: TObject);
    procedure mePackageNameEnter(Sender: TObject);
    procedure edFileNameKeyPress(Sender: TObject; var Key: Char);
    procedure edFileNameEnter(Sender: TObject);
    procedure lvFilesDblClick(Sender: TObject);
    procedure mnuGetFileListClick(Sender: TObject);
    procedure mnuSelectFileItemsClick(Sender: TObject);
    procedure mnuFindPackageClick(Sender: TObject);
    procedure mnuGetFileItemsClick(Sender: TObject);
  private
    { Private declarations }
  Temp: TStringList;
  MemStream: TMemoryStream;
  Text_Pos, PkgVersion: LongInt;
  TargetItem: TListItem;
  RootDir, PkgDir, SrcDir, IncMask: string;
  DisableDirName: Boolean;
  DisableFileName: Boolean;
    procedure ApplyDirName;
    function ProcessFileAndDir( FileName: string; SourceDir: string = '';
                                       ShowInfo: Boolean = True; QueryOnAdd: Boolean = True): Boolean;
    procedure SearchFiles();
    procedure RootDirEvent(const FileName: TFileName; const Size,
      FileTime: Integer);
    procedure TargetDirEvent(const FileName: TFileName; const Size,
      FileTime: Integer);
    procedure PackageFileEvent(const FileName: TFileName; const Size,
      FileTime: Integer);
    procedure ProcessFiles;
    function GetItemDirByIndex(Item: TListItem; Index: Integer;
      DoCheck: Boolean = True; DirIndex: Integer = id_IncFile): string;
    procedure ApplyFileName;
    procedure GetFileList(Dest: TStrings; OnlySelected: Boolean = False);
    procedure PutFileDelimList();
    procedure SelectFileItems;
    procedure FindPackage;
    procedure GetFileItems;
  public
    { Public declarations }
  end;

var
  frmDXMod: TfrmDXMod;

implementation
uses
   StrUtils, FileUtils, FastCopy;

{$R *.dfm}

function CheckSubItemIndex(Item: TListItem; Index: Integer; CheckEmpty: Boolean = True): Boolean;
begin
  Result:= (Item<>nil) and (Item.SubItems.Count>=Index) and
           ((not CheckEmpty) or ((Item.SubItems.Count>Index) and (Item.SubItems[Index] <> '')));
end;

function TfrmDXMod.GetItemDirByIndex(Item: TListItem; Index: Integer; DoCheck: Boolean = True; DirIndex: Integer = id_IncFile): string;
begin
  Result:= '';
  try
    if (not DoCheck) or CheckSubItemIndex(Item, Index) then
    begin
      Result:= RootDir + Item.SubItems[id_DirName];
      if (Index>id_DirName) then
      begin
        if (Index = DirIndex) then
            Result:= Result + '\' + Item.SubItems[DirIndex-1];
        Result:= Result + '\' + Item.SubItems[Index];
      end;
    end;
  except
    Result:= '';
  end;
end;

procedure TfrmDXMod.btnSelectClick(Sender: TObject);
begin
  dlgOpenProj.FilterIndex:= 1;
  if dlgOpenProj.InitialDir = '' then
     dlgOpenProj.InitialDir:= ExtractFilePath(Application.ExeName);
  if dlgOpenProj.Execute then
     begin
       reData.Lines.LoadFromFile(dlgOpenProj.FileName);
       sbProjectName.SimpleText:= dlgOpenProj.FileName;
       dlgSaveProj.FileName:= dlgOpenProj.FileName;
     end;
end;

procedure TfrmDXMod.btnSaveClick(Sender: TObject);
begin
  if dlgSaveProj.Execute then
     begin
       reData.Lines.SaveToFile(dlgSaveProj.FileName);
       sbProjectName.SimpleText:= dlgSaveProj.FileName;
     end;
end;

procedure LocatePosInRichEdit(RichEdit: TRichEdit; TextPos: LongInt);
//const
//  EM_SCROLLCARET  = $00B7;
var
  Pos: TSmallPoint;
begin
  if TextPos <> -1 then begin
    SendMessage(RichEdit.Handle, EM_SETSEL, 0, 0);
    SendMessage(RichEdit.Handle, EM_SCROLLCARET, 0, 0);

    Longint(Pos) := SendMessage(RichEdit.Handle, EM_POSFROMCHAR, TextPos, 0);
    SendMessage(RichEdit.Handle, WM_VSCROLL,
        MakeWParam(SB_THUMBPOSITION, Pos.y - RichEdit.ClientHeight div 2), 0);

    SendMessage(RichEdit.Handle, EM_SETSEL, TextPos, TextPos);
  end;
end;

procedure TfrmDXMod.btnFindClick(Sender: TObject);
var
  TextPos: LongInt;
  TextToFind: string;
begin
  TextToFind:= '<' + lbeTagValue.Text + '>';
  with reData do
  begin
    TextPos := reData.FindText(TextToFind, 0, MaxInt, []);
      if TextPos <> -1 then
      begin
        lbeTextPos.Text:= IntToStr(TextPos);
        pcPages.ActivePage:= tsData;
        SetFocus;
        LocatePosInRichEdit(reData, TextPos);
        //SelStart := TextPos;
        SelLength := Length(TextToFind);
      end else
      ShowMessage('Not found: ' + TextToFind);
      Text_Pos:= TextPos;
  end;
end;

procedure TfrmDXMod.btnInsertClick(Sender: TObject);
var
  TextPos, StartPos: LongInt;
  TextToFind: string;
begin
  TextToFind:= '</' + lbeTagValue.Text + '>';
  with reData do
  begin
    StartPos:= Text_Pos + Length(TextToFind) - 1;
    TextPos := reData.FindText(TextToFind, StartPos, MaxInt, []);
      if TextPos <> -1 then
      begin
        lbeTextPos.Text:= IntToStr(TextPos);      
        pcPages.ActivePage:= tsData;
        SetFocus;
        LocatePosInRichEdit(reData, StartPos);
        //SelStart := TextPos;
        SelLength := TextPos - StartPos;
        SelText:= lbeInsValue.Text;
      end else
      ShowMessage('Not found: ' + TextToFind);
  end;
end;

function FindTagByName(Source: PChar; SrcLen: LongInt; TagName: string; var TagPos, TagLen: LongInt): Boolean;
var
  TextPos: LongInt;
  Tag: string;
  Start, Next: PChar;
begin
  Result:= False;
  Tag:= '<' + TagName + '>';
  Start:= SearchBuf(Source, SrcLen, 0, 0, Tag, [soDown]);
  if (Start<>nil) then
  begin
    Inc(Start, Length(Tag));
    TagPos:= Start - Source;
    Tag:= '</' + TagName + '>';
    Dec(SrcLen, TagPos);
    Next:= SearchBuf(Start, SrcLen, 0, 0, Tag, [soDown]);
    if (Next<>nil) then
       begin
         TagLen:= Next - Start;
         Result:= True;
       end;
  end;
end;

function TfrmDXMod.ProcessFileAndDir( FileName: string; SourceDir: string = '';
                                       ShowInfo: Boolean = True; QueryOnAdd: Boolean = True): Boolean;
var
  Stream: TStream; P: PChar; TagName, s, s_ins: string; TagPos, TagLen: LongInt; Found, Exists: Boolean;
begin
  Result:= False;
  if (FileName = '') then Exit;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    MemStream.LoadFromStream(Stream);
    TagName:= lbeTagValue.Text;
    Found:= FindTagByName(PChar(MemStream.Memory), MemStream.Size, TagName, TagPos, TagLen);
    if Found then
       begin
         SetLength(s, TagLen);
         MemStream.Position:= TagPos;
         MemStream.ReadBuffer(Pointer(s)^, TagLen);
         Result:= True;
         if ShowInfo then
            ShowMessage('Tag contents: ' + s + '; TagLen: ' + IntToStr(TagLen));
       end else
       if ShowInfo then
          ShowMessage('Not found: ' + TagName);
  finally
    Stream.Free;
  end;
  if Found then
  begin
    Temp.Text:= StringReplace(s, ';', #10, [rfReplaceAll]) ;  
    s_ins:= SourceDir;
    if (s_ins = '') then
       s_ins:= lbeInsValue.Text;
    Exists:= Temp.IndexOf(s_ins) >= 0;
    if not Exists then
    if (not QueryOnAdd) or (MessageDlg('Add item as ' + s_ins, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
       Stream := TFileStream.Create(FileName, fmCreate);
       try
         P:= PChar(MemStream.Memory);
         Inc(TagPos, TagLen);
         Stream.WriteBuffer(P^, TagPos);
         if (Temp.Count>0) then s_ins:= ';' + s_ins;
         Stream.WriteBuffer(Pointer(s_ins)^, Length(s_ins));
         Inc(P, TagPos);
         Stream.WriteBuffer(P^, MemStream.Size - TagPos);
       finally
         Stream.Free;
       end;
    end;
  end;
end;

procedure TfrmDXMod.RootDirEvent(
          const FileName: TFileName;
          const Size: Integer; const FileTime: Integer);
var Item: TListItem;
begin
  if (FileName='.') or (FileName='..') then Exit;
  Item:= lvDirNames.Items.Add;
  Item.Caption:= IntToStr(lvDirNames.Items.Count);
  Item.SubItems.Add(FileName);
end;

procedure TfrmDXMod.TargetDirEvent(
          const FileName: TFileName;
          const Size: Integer; const FileTime: Integer);
var i: Integer;
begin
  if (FileName='.') or (FileName='..') then Exit;
  i:= 0;
  if SameText(FileName, PkgDir) then i:= id_PkgName else
  if SameText(FileName, SrcDir) then i:= id_SrcName else
  if SameText(FileName, IncMask) then i:= id_IncFile;
  if (i>0) then
     begin
        while TargetItem.SubItems.Count <= i do
          TargetItem.SubItems.Add('');
        TargetItem.SubItems[i]:= FileName;
     end;
end;

procedure TfrmDXMod.PackageFileEvent(
          const FileName: TFileName;
          const Size: Integer; const FileTime: Integer);
var Item: TListItem; s: string;
begin
  s:= OnlyFileName(FileName);
  s:= Copy(s, Length(s)-1, 2);
  if StrToIntDef(s, -1) <> PkgVersion then Exit;
  Item:= lvFiles.Items.Add;
  Item.Caption:= IntToStr(lvFiles.Items.Count);
  Item.SubItems.Add(TargetItem.SubItems[0]);
  Item.SubItems.Add(PkgDir);
  Item.SubItems.Add(FileName);
end;

procedure TfrmDXMod.ProcessFiles();

function IndexOfIncFile(): Integer;
var Item: TListItem;
begin
  for Result := 0 to lvDirNames.Items.Count - 1 do
    begin
      Item:= lvDirNames.Items[Result];
      if CheckSubItemIndex(Item, id_IncFile) then
         Exit;
    end;
  Result := -1;
end;

procedure CopyIncFile();
var i, k: Integer; IncFileName, DstFileName: string;
begin
  PkgDir:= lbePkgDirName.Text; SrcDir:= lbeSrcDirName.Text;
  IncMask:= lbeIncFile.Text;
  IncFileName:= '';
  i:= IndexOfIncFile();
  if (i>=0) then IncFileName:=
     GetItemDirByIndex(lvDirNames.Items[i], id_IncFile, False)
     else
  begin
      dlgOpenProj.FilterIndex:= 2;
  if dlgOpenProj.InitialDir = '' then
     dlgOpenProj.InitialDir:= ExtractFilePath(Application.ExeName);
  if dlgOpenProj.Execute then
     IncFileName:= dlgOpenProj.FileName;
  end;
  if (IncFileName <> '') and FileExists(IncFileName) then
     begin
        for k := 0 to lvDirNames.Items.Count - 1 do
        if (k<>i) then
          begin
            TargetItem:= lvDirNames.Items[k];
            if  CheckSubItemIndex(TargetItem, id_SrcName, True) and
                CheckSubItemIndex(TargetItem, id_IncFile, False) and
                (not CheckSubItemIndex(TargetItem, id_IncFile, True)) then
                begin
                  DstFileName:= GetItemDirByIndex(TargetItem, id_SrcName, False);
                  if DirectoryExists(DstFileName) then
                  begin
                    DstFileName:= DstFileName + '\' + ExtractFileName(IncFileName);
                    FastCopyFile(IncFileName, DstFileName);
                  end;
                end;
          end;
     end;
end;

function ExistsBpl(BplDir, FileName: string): Boolean;
begin
  Result:= True;
  if (BplDir<>'') then
  begin
    FileName:= BplDir + OnlyFileName(ExtractFileName(FileName)) + '.bpl';
    Result:= FileExists(FileName);
  end;
end;

procedure ProcessProjFiles();
var i, k: Integer; SourceDir, BplDir, DstFileName: string;
begin
  SourceDir:= '..\' + lbeSrcDirName.Text;
  if cbxUseDelphiBplPath.Checked then
     BplDir:= IncludeTrailingBackslash(Trim(edDelphiBplPath.Text)) else
     BplDir:= '';
  for k := 0 to lvFiles.Items.Count - 1 do
    begin
      TargetItem:= lvFiles.Items[k];
      DstFileName:= GetItemDirByIndex(TargetItem, id_SrcName, False, 2);
      if FileExists(DstFileName) and
         ProcessFileAndDir(DstFileName, SourceDir, False, False) and
         ExistsBpl(BplDir, DstFileName) then
         TargetItem.Checked:= True else
         TargetItem.Checked:= False;
    end;
end;


begin
  if Ord(cbxCopyIncFile.State)>0 then
     CopyIncFile();
  if Ord(cbxCopyIncFile.State) in [0,2] then
     ProcessProjFiles();
     //ProcessFileAndDir('');
end;

procedure TfrmDXMod.SearchFiles();

procedure SearchInRootDir();
begin
  lvDirNames.Clear;
  ExtractFileNames(Self.RootDirEvent, RootDir, '*.*', [ftDirectory]);
end;

procedure FindTargetDirs();
var i: Integer;
begin
  PkgDir:= lbePkgDirName.Text; SrcDir:= lbeSrcDirName.Text;
  IncMask:= lbeIncFile.Text;
  for i := 0 to lvDirNames.Items.Count - 1 do
    begin
      TargetItem:= lvDirNames.Items[i];
      ExtractFileNames( Self.TargetDirEvent,
                        GetItemDirByIndex(TargetItem, id_DirName),
                        '*.*', [ftDirectory]);
      if CheckSubItemIndex(TargetItem, id_SrcName) then
         begin
            ExtractFileNames( Self.TargetDirEvent,
                              GetItemDirByIndex(TargetItem, id_SrcName),
                              IncMask, [ftArchive, ftNormal]);
         end;
      TargetItem.Checked:=
      (TargetItem.SubItems.Count = 4) and
       (TargetItem.SubItems[id_PkgName] <> '') and
       (TargetItem.SubItems[id_SrcName] <> '') and
       (TargetItem.SubItems[id_IncFile] <> '');
    end;
end;

procedure SearchInPackageDir(DirIndex: Integer; Mask: string);
begin
    if (TargetItem.SubItems.Count>DirIndex) then
       begin
         PkgDir:= TargetItem.SubItems[DirIndex];
         if (PkgDir <> '') then
            begin
              ExtractFileNames( Self.PackageFileEvent,
                                RootDir +
                                TargetItem.SubItems[id_DirName] + '\' + PkgDir,
                                Mask, [ftArchive, ftNormal]);
            end;
       end;
end;

procedure SearchInPackageDirs();
var i: Integer; PkgMask: string;
begin
  lvFiles.Clear;
  PkgMask:= '*.' + lbeProjExt.Text;
  //IncMask:= lbeIncFile.Text;
for i := 0 to lvDirNames.Items.Count - 1 do
  begin
    TargetItem:= lvDirNames.Items[i];
    SearchInPackageDir(id_PkgName, PkgMask);
    //SearchInPackageDir(2, IncMask);
  end;
end;

begin
  SearchInRootDir();
  FindTargetDirs();
  SearchInPackageDirs();
end;

procedure TfrmDXMod.dlbDirsChange(Sender: TObject);
begin
  if DisableDirName then Exit;
  edDirName.Text:= dlbDirs.Directory;
  edDirName.Font.Color:= clBlack;
end;

procedure TfrmDXMod.ApplyDirName();
begin
   DisableDirName:= True;
   if DirectoryExists(edDirName.Text) then
      begin
        dlbDirs.Directory:= edDirName.Text;
        edDirName.Font.Color:= clBlack;
      end else
      edDirName.Font.Color:= clRed;
   DisableDirName:= False;
end;

procedure TfrmDXMod.ApplyFileName();
begin
   DisableFileName:= True;
   if FileExists(edFileName.Text) then
      begin
        flbFiles.FileName:= edFileName.Text;
        edFileName.Font.Color:= clBlack;
      end else
      edFileName.Font.Color:= clRed;
   DisableFileName:= False;
end;

procedure TfrmDXMod.edDirNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
     ApplyDirName;
end;

procedure TfrmDXMod.FormCreate(Sender: TObject);
begin
  dlbDirsChange(dlbDirs);
  Temp:= TStringList.Create;
  MemStream:= TMemoryStream.Create;
end;

procedure TfrmDXMod.sbnApplyDirClick(Sender: TObject);
begin
  ApplyFileName;
end;

procedure TfrmDXMod.flbFilesChange(Sender: TObject);
begin
  if DisableFileName then Exit;
  edFileName.Text:= flbFiles.FileName;
  edFileName.Font.Color:= clBlack;
end;

procedure TfrmDXMod.flbFilesDblClick(Sender: TObject);
begin
  ProcessFileAndDir(flbFiles.FileName);
end;

procedure TfrmDXMod.btnSearchFilesClick(Sender: TObject);
begin
  RootDir:= IncludeTrailingBackslash(dlbDirs.Directory);
  PkgVersion:= StrToIntDef(lbePkgVer.Text, 0);
  SearchFiles();
end;

procedure TfrmDXMod.btnProcessFilesClick(Sender: TObject);
begin
  ProcessFiles();
end;

procedure TfrmDXMod.FormDestroy(Sender: TObject);
begin
  MemStream.Free;
  Temp.Free;
end;

procedure TfrmDXMod.btnProcessOneFileClick(Sender: TObject);
begin
  ProcessFileAndDir(dlgOpenProj.FileName);
end;

procedure TfrmDXMod.lvFilesClick(Sender: TObject);
begin
  if mnuSyncroItem.Checked then
     if (lvFiles.Selected<>nil) then
        mePackageName.Text:= GetItemDirByIndex(lvFiles.Selected, id_SrcName, False, id_SrcName) else
        mePackageName.Text:= '';
end;

procedure TfrmDXMod.mePackageNameEnter(Sender: TObject);
begin
  mePackageName.SelectAll;
end;

procedure TfrmDXMod.edFileNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
     ApplyFileName;
end;

procedure TfrmDXMod.edFileNameEnter(Sender: TObject);
begin
  edFileName.SelectAll;
end;

procedure TfrmDXMod.lvFilesDblClick(Sender: TObject);
var DstFileName: string;
begin
  TargetItem:= lvFiles.Selected;
  DstFileName:= GetItemDirByIndex(TargetItem, id_SrcName, False, 2);
  if FileExists(DstFileName) and
     ProcessFileAndDir(DstFileName) then
     TargetItem.Checked:= True else
     TargetItem.Checked:= False;
end;

function FindSubItem(ListView: TListView; Index: Integer; Value: String): TListItem;
var i: Integer; s, p: string;
begin
  ListView.ClearSelection;
  for i := 0 to ListView.Items.Count - 1 do
    begin
      Result:= ListView.Items[i];
      s:= Result.SubItems[Index];
      if SameText(s, Value) then
      begin
        Result.Selected:= True;
        Result.Focused:= True;
        Exit;
      end;
    end;
  Result:= nil;
end;


procedure TfrmDXMod.FindPackage();
var i: Integer; p: string; Item: TListItem;
begin
  p:= OnlyFileName(Trim(mePackageName.Text)) + '.' + lbeProjExt.Text;
  Item:= FindSubItem(lvFiles, id_SrcName, p);
  if (Item<>nil) then
     begin
       p:= Item.SubItems[id_DirName];
       FindSubItem(lvDirNames, id_DirName, p);
     end else
    ShowMessage('Not found: ' + p);
end;

procedure TfrmDXMod.SelectFileItems();
var i, n: Integer; s, pfx, dir: string;
    Item: TListItem;
    UsePrefix, UsePackage, Select: Boolean;
begin
  UsePrefix:= mnuUsePrefix.Checked;
  pfx:= edPrefix.Text;
  if lvDirNames.Selected <> nil then
     dir:= lvDirNames.Selected.SubItems[id_DirName] else
     dir:= '';
  Select:= True; n:= 0;
    for i := 0 to lvFiles.Items.Count - 1 do
      begin
        Item:= lvFiles.Items[i];
        Select:= False;
        if UsePrefix or (dir<>'') then
        begin
          s:= Item.SubItems[2];
          if (dir='') or (dir=Item.SubItems[id_DirName]) then
             if UsePrefix then
                Select:= AnsiStartsText(pfx, s) else
                Select:= True;
        end;
        if Select then Inc(n);
        lvFiles.Items[i].Selected:= Select;
      end;
    lblCount.Caption:= 'Sel: ' + IntToStr(n);
end;

procedure TfrmDXMod.GetFileList(Dest: TStrings; OnlySelected: Boolean = False);
var i: Integer; s, p: string; UsePrefix, Select: Boolean;
begin
  Dest.BeginUpdate;
  UsePrefix:= mnuUsePrefix.Checked;
  p:= edPrefix.Text;
  Select:= True;
  try
    Dest.Clear;
    for i := 0 to lvFiles.Items.Count - 1 do
      begin
        s:= lvFiles.Items[i].SubItems[2];
        if OnlySelected then
           Select:= (lvFiles.Items[i].Selected);
        if Select then Dest.Add(s);
      end;
  finally
    Dest.EndUpdate;
  end;
end;

function QoutedList(List: TStrings; Qoute: Char): String;
var i, h: Integer;
begin
  Result:= '';
  h:= List.Count - 1;
  for i := 0 to h do
  begin
    Result:= Result + AnsiQuotedStr(List[i], Qoute);
    if i < h then
       Result:= Result + List.Delimiter;
  end;
end;

procedure TfrmDXMod.PutFileDelimList();
begin
  GetFileList(Temp, mnuOnlySelected.Checked);
  if mnuAsDelimList.Checked then
     begin
        Temp.Delimiter:= ';';
        mePackageName.Text:= Temp.DelimitedText;
     end else
     begin
        Temp.Delimiter:= ' ';
        mePackageName.Text:= QoutedList(Temp, '"');
     end;  
end;

procedure TfrmDXMod.mnuGetFileListClick(Sender: TObject);
begin
  if mnuPutIntoEditBox.Checked then
     PutFileDelimList() else
     GetFileList(reData.Lines);
end;

procedure TfrmDXMod.mnuSelectFileItemsClick(Sender: TObject);
begin
  SelectFileItems();
end;

procedure TfrmDXMod.mnuFindPackageClick(Sender: TObject);
begin
  FindPackage();
end;

procedure TfrmDXMod.GetFileItems();
begin
  SelectFileItems();
  PutFileDelimList()
end;

procedure TfrmDXMod.mnuGetFileItemsClick(Sender: TObject);
begin
  GetFileItems();
end;

end.
