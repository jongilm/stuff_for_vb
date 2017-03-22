Option Explicit

'global constants
Global Const DEFAULTDRIVER = "SQL Server"
Global Const MODAL = 1
Global Const HOURGLASS = 11
Global Const DEFAULT_MOUSE = 0
Global Const YES = 6
Global Const MSGBOX_TYPE = 4 + 48 + 256
Global Const TRUE_ST = "True"
Global Const FALSE_ST = "False"
Global Const EOF_ERR = 626
Global Const FTBLS = 0
Global Const FFLDS = 1
Global Const FINDX = 2
Global Const MAX_GRID_ROWS = 31999
Global Const MAX_MEMO_SIZE = 20000
Global Const GETCHUNK_CUTOFF = 50

'field type constants
Global Const FT_TRUEFALSE = 1
Global Const FT_BYTE = 2
Global Const FT_INTEGER = 3
Global Const FT_LONG = 4
Global Const FT_CURRENCY = 5
Global Const FT_SINGLE = 6
Global Const FT_DOUBLE = 7
Global Const FT_DATETIME = 8
Global Const FT_STRING = 10
Global Const FT_BINARY = 11
Global Const FT_MEMO = 12

'table type constants
Global Const DB_TABLE = 1
Global Const DB_ATTACHEDTABLE = 6
Global Const DB_ATTACHEDODBC = 4
Global Const DB_QUERYDEF = 5
Global Const DB_SYSTEMOBJECT = &H80000002

'dynaset option parameter constants
Global Const VBDA_DENYWRITE = &H1
Global Const VBDA_DENYREAD = &H2
Global Const VBDA_READONLY = &H4
Global Const VBDA_APPENDONLY = &H8
Global Const VBDA_INCONSISTENT = &H10
Global Const VBDA_CONSISTENT = &H20
Global Const VBDA_SQLPASSTHROUGH = &H40

'db create/compact constants
Global Const DB_CREATE_GENERAL = ";langid=0x0809;cp=1252;country=0"
Global Const DB_VERSION10 = 1

' Microsoft Access QueryDef types
Global Const DB_QACTION = &HF0
Global Const DB_QCROSSTAB = &H10
Global Const DB_QDELETE = &H20
Global Const DB_QUPDATE = &H30
Global Const DB_QAPPEND = &H40
Global Const DB_QMAKETABLE = &H50

' Index Attributes
Global Const DB_UNIQUE = 1
Global Const DB_PRIMARY = 2
Global Const DB_PROHIBITNULL = 4
Global Const DB_IGNORENULL = 8
Global Const DB_DESCENDING = 1  'For each field in Index

Sub Create_Database (DbName As String)
   Dim DB As Database

   Set DB = CreateDatabase(DbName, DB_CREATE_GENERAL, 0)
   DB.Close
End Sub

Sub Create_Diary_Database ()
   Dim DbName As String
   Dim TblName As String

   On Error GoTo ATErr

   DbName = "C:\TMP\Diary.MDB"
   Call Create_Database(DbName)

   TblName = "Diary"
   Call Create_Table(DbName, TblName, "DiaryRefNo"          , "String", 10)
   Call Create_Field(DbName, TblName, "OriginatingSystem"   , "String",  4)
   Call Create_Field(DbName, TblName, "NextEvent"           , "String", 14)
   Call Create_Field(DbName, TblName, "DiaryAction"         , "Integer", 0)
   Call Create_Field(DbName, TblName, "WorkDayAction"       , "Integer", 0)
   Call Create_Field(DbName, TblName, "RepeatType"          , "Integer", 0)
   Call Create_Field(DbName, TblName, "RepeatInterval"      , "Integer", 0)
   Call Create_Field(DbName, TblName, "DayOfWeek"           , "Integer", 0)
   Call Create_Field(DbName, TblName, "WeekendType"         , "Integer", 0)
   Call Create_Field(DbName, TblName, "IndexIntoMonth"      , "Integer", 0)
   Call Create_Field(DbName, TblName, "OffsetOnDate"        , "Integer", 0)
   Call Create_Field(DbName, TblName, "MaxReminders"        , "Integer", 0)
   Call Create_Field(DbName, TblName, "RepeatCount"         , "Integer", 0)
   Call Create_Field(DbName, TblName, "EventTime"           , "String", 6)
   Call Create_Field(DbName, TblName, "BasisForRegen"       , "String", 8)
   Call Create_Field(DbName, TblName, "ReminderDate"        , "String", 8)
   Call Create_Field(DbName, TblName, "FirstDate"           , "String", 8)
   Call Create_Field(DbName, TblName, "LastDate"            , "String", 8)
   Call Create_Field(DbName, TblName, "BaseDate"            , "String", 8)
   Call Create_Field(DbName, TblName, "ApRef1"              , "String", 20)
   Call Create_Field(DbName, TblName, "ApRef2"              , "String", 20)
   Call Create_Field(DbName, TblName, "ApRef3"              , "String", 20)
   Call Create_Field(DbName, TblName, "BlobLen"             , "Integer", 0)
   Call Create_Field(DbName, TblName, "BlobData"            , "String", 255)

   Call Create_Index(DbName, TblName, "Primary"    , "DiaryRefNo"                 , True,  True  )
   Call Create_Index(DbName, TblName, "SystemEvent", "OriginatingSystem;NextEvent", False, False )

   Exit Sub

ATErr:
   ShowError
   Exit Sub

End Sub

Sub Create_Field (DbName As String, TblName As String, FldName As String, FldType As String, FldSize As Integer)
   Dim DB As Database
   Dim Fld As Field


   Set Fld = New Field
   
   Fld.Name = FldName
   Fld.Type = GetFieldType(FldType)
   If FldType = "Counter" Then
     Fld.Attributes = &H10   'counter type
   End If
   Fld.Size = FldSize
   Set DB = OpenDatabase(DbName)
   DB.TableDefs(TblName).Fields.Append Fld

   DB.Close


End Sub

Sub Create_Index (DbName As String, TblName As String, IdxName As String, Fields As String, Unique As Integer, Primary As Integer)
   Dim DB As Database
   Dim Ind As Index

   Set Ind = New Index

   Ind.Name = IdxName
   Ind.Fields = Fields
   Ind.Unique = Unique
   Ind.Primary = Primary

   Set DB = OpenDatabase(DbName)
   DB.TableDefs(TblName).Indexes.Append Ind
   DB.Close
End Sub

Sub Create_Table (DbName As String, TblName As String, FldName As String, FldType As String, FldSize As Integer)
   Dim DB As Database
   Dim Tbl As New TableDef
   Dim Fld As Field
   Dim i As Integer

   Set DB = OpenDatabase(DbName)

   Tbl.Name = TblName

   'search to see if table exists
   For i = 0 To DB.TableDefs.Count - 1
     If UCase(DB.TableDefs(i).Name) = UCase(Tbl.Name) Then
       If MsgBox(Tbl.Name + " already exists, delete it?", 4) = YES Then
          DB.TableDefs.Delete DB.TableDefs(Tbl.Name)
       Else
          Exit Sub
       End If
       Exit For
     End If
   Next

   'FIRST FIELD
   Set Fld = New Field
   Fld.Name = FldName
   Fld.Type = GetFieldType(FldType)
   If FldType = "Counter" Then
     Fld.Attributes = &H10   'counter type
   End If
   Fld.Size = FldSize
   
   Tbl.Fields.Append Fld
   DB.TableDefs.Append Tbl

   DB.Close

End Sub

'sub used to create a sample table and fill it
'with NumbRecs number of rows
'can only be called from the debug window
'for example:
'CreateSampleTable "mytbl",100
Sub CreateSampleTable (gCurrentDB As Database, TblName As String, NumbRecs As Long)
  
  Dim ds As Dynaset
  Dim ii As Long
  Dim t1 As New TableDef
  Dim f1 As New Field
  Dim f2 As New Field
  Dim f3 As New Field
  Dim f4 As New Field
  Dim i1 As New Index
  Dim i2 As New Index

  'create the data holding table
  t1.Name = TblName
  
  f1.Name = "name"
  f1.Type = FT_STRING
  f1.Size = 25
  t1.Fields.Append f1

  f2.Name = "address"
  f2.Type = FT_STRING
  f2.Size = 25
  t1.Fields.Append f2

  f3.Name = "record"
  f3.Type = FT_STRING
  f3.Size = 10
  t1.Fields.Append f3

  f4.Name = "id"
  f4.Type = FT_LONG
  f4.Size = 4
  t1.Fields.Append f4

  gCurrentDB.TableDefs.Append t1

  'add the indexes
  i1.Name = TblName + "1"
  i1.Fields = "name"
  i1.Unique = False
  gCurrentDB.TableDefs(TblName).Indexes.Append i1

  i2.Name = TblName + "2"
  i2.Fields = "id"
  i2.Unique = True
  gCurrentDB.TableDefs(TblName).Indexes.Append i2

  'add records to the table in reverse order
  'so indexes have some work to do
  Set ds = gCurrentDB.CreateDynaset(TblName)
  For ii = NumbRecs To 1 Step -1
    ds.AddNew
    ds(0) = "name" + CStr(ii)
    ds(1) = "addr" + CStr(ii)
    ds(2) = "rec" + CStr(ii)
    ds(3) = ii
    ds.Update
  Next

End Sub

Function GetFieldType (ft As String) As Integer
   Select Case ft
      Case "String": GetFieldType = FT_STRING
      Case "Counter": GetFieldType = FT_LONG
      Case "True/False": GetFieldType = FT_TRUEFALSE
      Case "Byte": GetFieldType = FT_BYTE
      Case "Integer": GetFieldType = FT_INTEGER
      Case "Long": GetFieldType = FT_LONG
      Case "Currency": GetFieldType = FT_CURRENCY
      Case "Single": GetFieldType = FT_SINGLE
      Case "Double": GetFieldType = FT_DOUBLE
      Case "Date/Time": GetFieldType = FT_DATETIME
      Case "Binary": GetFieldType = FT_BINARY
      Case "Memo": GetFieldType = FT_MEMO
   End Select
End Function

Sub Outlines (formname As Form)
    Dim drkgray As Long, fullwhite As Long
    Dim i As Integer
    Dim ctop As Integer, cleft As Integer, cright As Integer, cbottom As Integer

    ' Outline a form's controls for 3D look unless control's TAG
    ' property is set to "skip".

    Dim cname As Control
    drkgray = RGB(128, 128, 128)
    fullwhite = RGB(255, 255, 255)

    For i = 0 To (formname.Controls.Count - 1)
        Set cname = formname.Controls(i)
        If TypeOf cname Is Menu Then
            'Debug.Print "menu item"
        ElseIf (UCase(cname.Tag) = "OL") Then
                ctop = cname.Top - screen.TwipsPerPixelY
                cleft = cname.Left - screen.TwipsPerPixelX
                cright = cname.Left + cname.Width
                cbottom = cname.Top + cname.Height
                formname.Line (cleft, ctop)-(cright, ctop), drkgray
                formname.Line (cleft, ctop)-(cleft, cbottom), drkgray
                formname.Line (cleft, cbottom)-(cright, cbottom), fullwhite
                formname.Line (cright, ctop)-(cright, cbottom), fullwhite
        End If
    Next i
End Sub

Sub PicOutlines (pic As Control, ctl As Control)
    Dim drkgray As Long, fullwhite As Long
    Dim ctop As Integer, cleft As Integer, cright As Integer, cbottom As Integer

    ' Outline a form's controls for 3D look unless control's TAG
    ' property is set to "skip".

    Dim cname As Control
    drkgray = RGB(128, 128, 128)
    fullwhite = RGB(255, 255, 255)

    ctop = ctl.Top - screen.TwipsPerPixelY
    cleft = ctl.Left - screen.TwipsPerPixelX
    cright = ctl.Left + ctl.Width
    cbottom = ctl.Top + ctl.Height
    pic.Line (cleft, ctop)-(cright, ctop), drkgray
    pic.Line (cleft, ctop)-(cleft, cbottom), drkgray
    pic.Line (cleft, cbottom)-(cright, cbottom), fullwhite
    pic.Line (cright, ctop)-(cright, cbottom), fullwhite

End Sub

Sub ResetMouse (f As Form)
  'VDMDI.MousePointer = DEFAULT_MOUSE
  f.MousePointer = DEFAULT_MOUSE
End Sub

Function SetFldProperties (ft As String) As String
  Dim gwFldType As Integer
  Dim gwFldSize As Integer

  'return field length
  If ft = "String" Then
    gwFldType = FT_STRING
  Else
    Select Case ft
      Case "Counter"
        SetFldProperties = "4"
        gwFldType = FT_LONG
        gwFldSize = 4
      Case "True/False"
        SetFldProperties = "1"
        gwFldType = FT_TRUEFALSE
        gwFldSize = 1
      Case "Byte"
        SetFldProperties = "1"
        gwFldType = FT_BYTE
        gwFldSize = 1
      Case "Integer"
        SetFldProperties = "2"
        gwFldType = FT_INTEGER
        gwFldSize = 2
      Case "Long"
        SetFldProperties = "4"
        gwFldType = FT_LONG
        gwFldSize = 4
      Case "Currency"
        SetFldProperties = "8"
        gwFldType = FT_CURRENCY
        gwFldSize = 8
      Case "Single"
        SetFldProperties = "4"
        gwFldType = FT_SINGLE
        gwFldSize = 4
      Case "Double"
        SetFldProperties = "8"
        gwFldType = FT_DOUBLE
        gwFldSize = 8
      Case "Date/Time"
        SetFldProperties = "8"
        gwFldType = FT_DATETIME
        gwFldSize = 8
      Case "Binary"
        SetFldProperties = "0"
        gwFldType = FT_BINARY
        gwFldSize = 0
      Case "Memo"
        SetFldProperties = "0"
        gwFldType = FT_MEMO
        gwFldSize = 0
    End Select
  End If
End Function

Sub SetHourglass (f As Form)
  DoEvents  'cause forms to repaint before going on
  'VDMDI.MousePointer = HOURGLASS
  f.MousePointer = HOURGLASS
End Sub

Sub ShowError ()
   Dim s As String
   Dim crlf As String

   crlf = Chr(13) + Chr(10)
   s = "The following Error occurred:" + crlf + crlf
   s = s + Error$ + crlf           'add the error string
   s = s + "Number: " + CStr(Err)  'add the error number
   Beep                            'beep and show the error
   MsgBox (s)
End Sub
