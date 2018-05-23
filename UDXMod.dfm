object frmDXMod: TfrmDXMod
  Left = 506
  Top = 170
  Caption = 'DX Project Modifier GitHub Test'
  ClientHeight = 494
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pcPages: TPageControl
    Left = 0
    Top = 0
    Width = 659
    Height = 472
    ActivePage = tsFiles
    Align = alClient
    TabOrder = 0
    object tsData: TTabSheet
      Caption = 'Data'
      object reData: TRichEdit
        Left = 0
        Top = 0
        Width = 651
        Height = 444
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        Zoom = 100
      end
    end
    object tsMod: TTabSheet
      Caption = 'Mod'
      ImageIndex = 1
      DesignSize = (
        651
        444)
      object lbeTagValue: TLabeledEdit
        Left = 32
        Top = 40
        Width = 193
        Height = 21
        EditLabel.Width = 49
        EditLabel.Height = 13
        EditLabel.Caption = 'Tag Value'
        TabOrder = 0
        Text = 'DCC_UnitSearchPath'
      end
      object lbeIncFileName: TLabeledEdit
        Left = 32
        Top = 96
        Width = 193
        Height = 21
        EditLabel.Width = 62
        EditLabel.Height = 13
        EditLabel.Caption = 'Inc FileName'
        TabOrder = 1
        Text = 'cxVer.inc'
      end
      object btnSelect: TButton
        Left = 40
        Top = 144
        Width = 97
        Height = 25
        Caption = 'Load ...'
        TabOrder = 2
        OnClick = btnSelectClick
      end
      object btnFind: TButton
        Left = 184
        Top = 144
        Width = 89
        Height = 25
        Caption = 'Find'
        TabOrder = 3
        OnClick = btnFindClick
      end
      object lbeInsValue: TLabeledEdit
        Left = 272
        Top = 40
        Width = 185
        Height = 21
        EditLabel.Width = 56
        EditLabel.Height = 13
        EditLabel.Caption = 'Insert Value'
        TabOrder = 4
        Text = '..\Sources'
      end
      object btnInsert: TButton
        Left = 304
        Top = 144
        Width = 75
        Height = 25
        Caption = 'Insert'
        TabOrder = 5
        OnClick = btnInsertClick
      end
      object lbeTextPos: TLabeledEdit
        Left = 208
        Top = 216
        Width = 121
        Height = 21
        EditLabel.Width = 53
        EditLabel.Height = 13
        EditLabel.Caption = 'lbeTextPos'
        TabOrder = 6
      end
      object btnSave: TButton
        Left = 40
        Top = 184
        Width = 97
        Height = 25
        Caption = 'Save ...'
        TabOrder = 7
        OnClick = btnSaveClick
      end
      object btnProcessOneFile: TButton
        Left = 40
        Top = 224
        Width = 97
        Height = 33
        Caption = 'Process File'
        TabOrder = 8
        OnClick = btnProcessOneFileClick
      end
      object cbxUseDelphiBplPath: TCheckBox
        Left = 48
        Top = 276
        Width = 129
        Height = 17
        Caption = 'Use Delphi Bpl Path'
        TabOrder = 9
      end
      object edDelphiBplPath: TEdit
        Left = 48
        Top = 296
        Width = 585
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 10
      end
    end
    object tsFiles: TTabSheet
      Caption = 'Files'
      ImageIndex = 2
      object gbxFiles: TGroupBox
        Left = 0
        Top = 0
        Width = 651
        Height = 444
        Align = alClient
        Caption = 'File Selection'
        TabOrder = 0
        DesignSize = (
          651
          444)
        object sbnApplyDir: TSpeedButton
          Left = 616
          Top = 15
          Width = 20
          Height = 18
          Anchors = [akTop, akRight]
          Caption = '...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Calibri'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = sbnApplyDirClick
        end
        object sbnApplyFile: TSpeedButton
          Left = 514
          Top = 266
          Width = 19
          Height = 18
          Anchors = [akTop, akRight]
          Caption = '...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Calibri'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = sbnApplyDirClick
        end
        object SpeedButton1: TSpeedButton
          Left = 621
          Top = 413
          Width = 20
          Height = 19
          Anchors = [akRight, akBottom]
          Caption = '...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Calibri'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = sbnApplyDirClick
        end
        object pnlDirFiles: TPanel
          Left = 2
          Top = 36
          Width = 640
          Height = 368
          Align = alCustom
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object Splitter1: TSplitter
            Left = 170
            Top = 1
            Height = 366
            Beveled = True
          end
          object pnlDirs: TPanel
            Left = 1
            Top = 1
            Width = 169
            Height = 366
            Align = alLeft
            TabOrder = 0
            DesignSize = (
              169
              366)
            object dlbDirs: TDirectoryListBox
              Left = 1
              Top = 1
              Width = 167
              Height = 318
              Align = alTop
              Anchors = [akLeft, akTop, akRight, akBottom]
              FileList = flbFiles
              TabOrder = 0
              OnChange = dlbDirsChange
              OnDblClick = dlbDirsChange
            end
            object dcbDrives: TDriveComboBox
              Left = 2
              Top = 343
              Width = 162
              Height = 19
              Anchors = [akLeft, akRight, akBottom]
              DirList = dlbDirs
              TabOrder = 1
            end
            object fcbFilter: TFilterComboBox
              Left = 2
              Top = 322
              Width = 163
              Height = 21
              Anchors = [akLeft, akRight, akBottom]
              FileList = flbFiles
              Filter = 
                'All files (*.*)|*.*|Delphi X Projects (*.dproj)|*.dproj|Delphi X' +
                ' Packages (*.dpk)|*.dpk|cxVer.inc|cxVer.inc'
              TabOrder = 2
            end
          end
          object pnlFiles: TPanel
            Left = 173
            Top = 1
            Width = 466
            Height = 366
            Align = alClient
            TabOrder = 1
            DesignSize = (
              466
              366)
            object flbFiles: TFileListBox
              Left = 1
              Top = 1
              Width = 461
              Height = 359
              Anchors = [akLeft, akTop, akRight, akBottom]
              ItemHeight = 13
              TabOrder = 0
              OnChange = flbFilesChange
              OnDblClick = flbFilesDblClick
            end
          end
        end
        object edDirName: TEdit
          Left = 0
          Top = 14
          Width = 610
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnKeyPress = edDirNameKeyPress
        end
        object edFileName: TEdit
          Left = 5
          Top = 411
          Width = 610
          Height = 21
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 2
          OnEnter = edFileNameEnter
          OnKeyPress = edFileNameKeyPress
        end
      end
    end
    object tsList: TTabSheet
      Caption = 'List'
      ImageIndex = 3
      object Splitter2: TSplitter
        Left = 0
        Top = 207
        Width = 651
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Beveled = True
      end
      object lvFiles: TListView
        Left = 0
        Top = 211
        Width = 651
        Height = 211
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'ID'
            Width = 41
          end
          item
            Caption = 'File Dir'
            Width = 170
          end
          item
            Caption = 'Pkg/Src Dir'
            Width = 100
          end
          item
            Caption = 'File name'
            Width = 300
          end>
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmFiles
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lvFilesClick
        OnDblClick = lvFilesDblClick
      end
      object pnlFileList: TPanel
        Left = 0
        Top = 0
        Width = 651
        Height = 49
        Align = alTop
        TabOrder = 1
        object lblPrefix: TLabel
          Left = 176
          Top = 24
          Width = 15
          Height = 13
          Caption = 'Pfx'
        end
        object lblCount: TLabel
          Left = 248
          Top = 27
          Width = 27
          Height = 13
          Caption = 'Sel: 0'
        end
        object btnSearchFiles: TButton
          Left = 9
          Top = 7
          Width = 72
          Height = 30
          Caption = 'Search Files'
          TabOrder = 0
          OnClick = btnSearchFilesClick
        end
        object btnProcessFiles: TButton
          Left = 87
          Top = 7
          Width = 80
          Height = 30
          Caption = 'Process Files'
          TabOrder = 1
          OnClick = btnProcessFilesClick
        end
        object cbxCopyIncFile: TCheckBox
          Left = 176
          Top = 6
          Width = 83
          Height = 14
          AllowGrayed = True
          Caption = 'Copy IncFile'
          TabOrder = 2
        end
        object lbePkgDirName: TLabeledEdit
          Left = 312
          Top = 16
          Width = 81
          Height = 21
          EditLabel.Width = 87
          EditLabel.Height = 13
          EditLabel.Caption = 'Package DirName'
          TabOrder = 3
          Text = 'Packages'
        end
        object lbeSrcDirName: TLabeledEdit
          Left = 408
          Top = 16
          Width = 81
          Height = 21
          EditLabel.Width = 78
          EditLabel.Height = 13
          EditLabel.Caption = 'Source DirName'
          TabOrder = 4
          Text = 'Sources'
        end
        object lbeProjExt: TLabeledEdit
          Left = 496
          Top = 16
          Width = 65
          Height = 21
          EditLabel.Width = 36
          EditLabel.Height = 13
          EditLabel.Caption = 'Proj Ext'
          TabOrder = 5
          Text = 'dproj'
        end
        object lbeIncFile: TLabeledEdit
          Left = 576
          Top = 16
          Width = 65
          Height = 21
          EditLabel.Width = 34
          EditLabel.Height = 13
          EditLabel.Caption = 'Inc File'
          TabOrder = 6
          Text = 'cxVer.inc'
        end
        object lbePkgVer: TLabeledEdit
          Left = 664
          Top = 24
          Width = 41
          Height = 21
          EditLabel.Width = 38
          EditLabel.Height = 13
          EditLabel.Caption = 'Pkg Ver'
          TabOrder = 7
          Text = '25'
        end
        object edPrefix: TEdit
          Left = 198
          Top = 22
          Width = 43
          Height = 21
          TabOrder = 8
          Text = 'dcl'
        end
      end
      object lvDirNames: TListView
        Left = 0
        Top = 49
        Width = 651
        Height = 158
        Align = alTop
        Checkboxes = True
        Columns = <
          item
            Caption = 'ID'
            Width = 41
          end
          item
            Caption = 'File Dir'
            Width = 170
          end
          item
            Caption = 'Package Dir'
            Width = 170
          end
          item
            Caption = 'Source Dir'
            Width = 170
          end
          item
            Caption = 'Inc File'
            Width = 100
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmDirNames
        TabOrder = 2
        ViewStyle = vsReport
      end
      object mePackageName: TMemo
        Left = 0
        Top = 422
        Width = 651
        Height = 22
        Align = alBottom
        TabOrder = 3
        OnEnter = mePackageNameEnter
      end
    end
  end
  object sbProjectName: TStatusBar
    Left = 0
    Top = 472
    Width = 659
    Height = 22
    Panels = <>
    SimplePanel = True
  end
  object dlgOpenProj: TOpenDialog
    Filter = 'Delphi X Project (*.dproj)|*.dproj|cxVer.inc|cxVer.inc'
    Left = 316
    Top = 128
  end
  object dlgSaveProj: TSaveDialog
    Left = 268
    Top = 128
  end
  object pmFiles: TPopupMenu
    Left = 236
    Top = 352
    object mnuSyncroItem: TMenuItem
      AutoCheck = True
      Caption = 'Syncronize Item'
      Checked = True
    end
    object mnuAsDelimList: TMenuItem
      AutoCheck = True
      Caption = 'As Delim List'
    end
    object mnuPutIntoEditBox: TMenuItem
      AutoCheck = True
      Caption = 'Put Into Box'
      Checked = True
    end
    object mnuOnlySelected: TMenuItem
      AutoCheck = True
      Caption = 'Only Selected'
      Checked = True
    end
    object mnuGetFileList: TMenuItem
      Caption = 'Get File List'
      OnClick = mnuGetFileListClick
    end
    object mnuFindPackage: TMenuItem
      Caption = 'Find Package'
      OnClick = mnuFindPackageClick
    end
  end
  object pmDirNames: TPopupMenu
    Left = 180
    Top = 120
    object mnuGetFileItems: TMenuItem
      Caption = 'Get File Items'
      OnClick = mnuGetFileItemsClick
    end
    object mnuSelectFileItems: TMenuItem
      Caption = 'Select File Items'
      OnClick = mnuSelectFileItemsClick
    end
    object mnu_GetFileList: TMenuItem
      Caption = 'Get File List'
      OnClick = mnuGetFileListClick
    end
    object mnuUsePrefix: TMenuItem
      AutoCheck = True
      Caption = 'Use Prefix'
      Checked = True
    end
  end
end
