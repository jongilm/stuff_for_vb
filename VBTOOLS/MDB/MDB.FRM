VERSION 2.00
Begin Form frmMDB 
   BackColor       =   &H00C0C0C0&
   Caption         =   "MDB"
   ClientHeight    =   6015
   ClientLeft      =   450
   ClientTop       =   1695
   ClientWidth     =   9480
   FontBold        =   0   'False
   FontItalic      =   0   'False
   FontName        =   "MS Sans Serif"
   FontSize        =   8.25
   FontStrikethru  =   0   'False
   FontUnderline   =   0   'False
   Height          =   6705
   Icon            =   MDB.FRX:0000
   Left            =   390
   LinkTopic       =   "MDB"
   ScaleHeight     =   6015
   ScaleWidth      =   9480
   Top             =   1065
   Width           =   9600
   Begin CommonDialog CMDialog1 
      Left            =   4440
      Top             =   2760
   End
   Begin TextBox Text1 
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   6015
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   0
      Width           =   9495
   End
   Begin Menu mnuFile 
      Caption         =   "&File"
      Begin Menu mnuOpen 
         Caption         =   "&Open"
      End
      Begin Menu mnuFileExport 
         Caption         =   "&Export"
      End
      Begin Menu mnuSeparator 
         Caption         =   "-"
      End
      Begin Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin Menu mnuEdit 
      Caption         =   "&Edit"
      Begin Menu mnuEditCut 
         Caption         =   "&Cut"
         Shortcut        =   ^X
      End
      Begin Menu mnuEditCopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin Menu mnuEditPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin Menu mnuEditDelete 
         Caption         =   "&Delete"
         Shortcut        =   {DEL}
      End
   End
   Begin Menu mnuHelp 
      Caption         =   "&Help"
      Begin Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Option Explicit

Const DB_BOOLEAN = 1      'True/False  Integer (0 or 1)
Const DB_BYTE = 2         'Byte  Integer (0  255)
Const DB_INTEGER = 3      'Integer  Integer
Const DB_LONG = 4         'Long  Long
Const DB_CURRENCY = 5     'Currency Double
Const DB_SINGLE = 6       'Single   Single
Const DB_DOUBLE = 7       'Double   Double
Const DB_DATE = 8         'Date/Time   Variant
Const DB_TEXT = 10        'Text  String
Const DB_LONGBINARY = 11  'Long Binary String
Const DB_MEMO = 12        'Memo  String

Const OFN_READONLY = &H1&
Const OFN_FILEMUSTEXIST = &H1000&

Dim DatabaseName As String
Dim DatabaseInfo As String
Dim CRLF As String

Sub AddString (Text As String)
   DatabaseInfo = DatabaseInfo & Text & CRLF
End Sub

Function Field_Type (typ As Integer) As String

   Dim FldType As String

   Select Case typ
      Case DB_BOOLEAN:    FldType = "BOOLEAN   " 'True/False  Integer (0 or 1)
      Case DB_BYTE:       FldType = "BYTE      " 'Byte  Integer (0  255)
      Case DB_INTEGER:    FldType = "INTEGER   " 'Integer  Integer
      Case DB_LONG:       FldType = "LONG      " 'Long  Long
      Case DB_CURRENCY:   FldType = "CURRENCY  " 'Currency Double
      Case DB_SINGLE:     FldType = "SINGLE    " 'Single   Single
      Case DB_DOUBLE:     FldType = "DOUBLE    " 'Double   Double
      Case DB_DATE:       FldType = "DATE      " 'Date/Time   Variant
      Case DB_TEXT:       FldType = "TEXT      " 'Text  String
      Case DB_LONGBINARY: FldType = "LONGBINARY" 'Long Binary String
      Case DB_MEMO:       FldType = "MEMO      " 'Memo  String
   End Select

   Field_Type = FldType

End Function

Sub Form_Load ()
   mnuFileExport.Enabled = False
   frmMDB.Caption = "MDB"
   CRLF = Chr(13) & Chr(10)
   Call ResizeControlToForm(Text1, frmMDB)
   Show
   Text1.SetFocus
   mnuOpen_Click
End Sub

Sub Form_Resize ()
   Call ResizeControlToForm(Text1, frmMDB)
End Sub

Sub mnuEditCopy_Click ()
   ClipBoard.SetText Screen.ActiveControl.SelText
End Sub

Sub mnuEditCut_Click ()
   ClipBoard.SetText Screen.ActiveControl.SelText
   Screen.ActiveControl.SelText = ""
End Sub

Sub mnuEditDelete_Click ()
   Screen.ActiveControl.SelText = ""
End Sub

Sub mnuEditPaste_Click ()
   Screen.ActiveControl.SelText = ClipBoard.GetText()
End Sub

Sub mnuExit_Click ()
   Unload Me
End Sub

Sub mnuFileExport_Click ()
   Dim FName As String
   Dim FNum As Integer

   Screen.MousePointer = 11

   FNum = FreeFile
   FName = "MDB.OUT"  'DatabaseName
   Open FName For Output As FNum
   Print #FNum, DatabaseInfo
   Close ' Close all files.

   Screen.MousePointer = 0
   MsgBox "Successfully exported " & Len(DatabaseInfo) & " bytes to " & FName
End Sub

Sub mnuOpen_Click ()
   
   Dim db As Database
   Dim ListSet As SnapShot
   Dim tb As SnapShot
   
   Dim TblName As String
   Dim TblType As String
   Dim FldName As String
   Dim FldType As String
   Dim FldSize As String
   Dim I As Integer
   Dim TypeNo As Integer

   CMDialog1.Filter = "Access Database (*.mdb)|*.mdb"
   CMDialog1.FilterIndex = 1
   CMDialog1.Flags = OFN_READONLY Or OFN_FILEMUSTEXIST
   CMDialog1.CancelError = True
   CMDialog1.Filename = ""

   On Error Resume Next
   CMDialog1.Action = 1
   If Err <> 0 Then
      ' No file selected in the "File Open..." dialog.
      Exit Sub
   End If
   DatabaseName = CMDialog1.Filename
   frmMDB.Caption = "MDB - " & DatabaseName



   Screen.MousePointer = 11 'HourGlass
      
   DatabaseInfo = ""
   
   Set db = OpenDatabase(DatabaseName)
   Set ListSet = db.ListTables()
   
   AddString "Database Name    = " & db.Name
   AddString "Number of Tables = " & Str(db.TableDefs)
   AddString " "

   Do While Not ListSet.EOF
      If ListSet("Attributes") = 0 Then
	 TblName = ListSet("Name")
	 Select Case ListSet("TableType")
	    Case 1: TblType = "Table"
	    Case 5: TblType = "Query"
	    Case Else: TblType = "Unknown (" & Str(ListSet("TableType")) & ")"
	 End Select

	 AddString "   Table Name       = " & TblName
	 AddString "   Table Type       = " & TblType
	 AddString "   Record Count     = " & ListSet("RecordCount") & ""
	 AddString "   Table Attributes = " & Hex$(ListSet("Attributes"))

	 ' Fields
	 Set tb = db.CreateSnapshot(TblName)
	 AddString "      _________________________________________________________"
	 AddString "      FIELD NAME                               TYPE        SIZE"
	 AddString "      _________________________________________________________"
	 
	 For I = 0 To tb.Fields.Count - 1
	    FldName = Format(tb.Fields(I).Name, "      !@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ")
	    TypeNo = tb.Fields(I).Type
	    FldType = Field_Type(TypeNo)
	    FldType = Format(FldType, " @@@@@@@@@@")
	    FldSize = Format(Str(tb.Fields(I).Size), " @@@@@")
	    AddString FldName & FldType & FldSize
	 Next I
	 AddString "      _________________________________________________________"
	 AddString " "

	 tb.Close
      End If
      ListSet.MoveNext  ' Move to next table
   Loop

   ListSet.Close
   db.Close

   Text1.Text = DatabaseInfo
   If Text1.Text <> DatabaseInfo Then
      MsgBox "Probably out of memory.  Export will still work"
   End If
   mnuFileExport.Enabled = True
   Screen.MousePointer = 0 'Normal
   Text1.SetFocus

End Sub

