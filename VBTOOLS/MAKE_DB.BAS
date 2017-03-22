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

Function Create_Database (DBName As String) As Integer
   Dim DB As Database
   Dim rc As Integer
   Const MB_YESNO = 4
   Const MB_ICONQUESTION = 32
   Const IDYES = 6
   Const IDNO = 7

   On Error GoTo ErrorHandler
   Set DB = CreateDatabase(DBName, DB_CREATE_GENERAL, 0)
   DB.Close
   Create_Database = True
   Exit Function

ErrorHandler:
   rc = MsgBox("Database already exists. Overwrite ?", MB_YESNO Or MB_ICONQUESTION, "Create Database")
   
   If rc = IDYES Then
      Kill DBName
      Set DB = CreateDatabase(DBName, DB_CREATE_GENERAL, 0)
      DB.Close
      Create_Database = True
   Else
      Create_Database = False
   End If

   Exit Function

End Function

Sub Create_Field (DBName As String, TblName As String, FldName As String, FldType As String, FldSize As Integer)
   Dim DB As Database
   Dim Fld As Field

   Set Fld = New Field
   
   Fld.Name = FldName
   Fld.Type = GetFieldType(FldType)
   If FldType = "Counter" Then
     Fld.Attributes = &H10   'counter type
   End If
   Fld.Size = FldSize
   Set DB = OpenDatabase(DBName)
   DB.TableDefs(TblName).Fields.Append Fld

   DB.Close
End Sub

Sub Create_Index (DBName As String, TblName As String, IdxName As String, Fields As String, Unique As Integer, Primary As Integer)
   Dim DB As Database
   Dim Ind As Index

   Set Ind = New Index

   Ind.Name = IdxName
   Ind.Fields = Fields
   Ind.Unique = Unique
   Ind.Primary = Primary

   Set DB = OpenDatabase(DBName)
   DB.TableDefs(TblName).Indexes.Append Ind
   DB.Close
End Sub

Function Create_Table (DBName As String, TblName As String, FldName As String, FldType As String, FldSize As Integer) As Integer
   Dim DB As Database
   Dim Tbl As New TableDef
   Dim Fld As Field
   Dim i As Integer

   Set DB = OpenDatabase(DBName)

   Tbl.Name = TblName

   'search to see if table exists
   For i = 0 To DB.TableDefs.Count - 1
     If UCase(DB.TableDefs(i).Name) = UCase(Tbl.Name) Then
       If MsgBox(Tbl.Name + " already exists, delete it?", 4) = YES Then
          DB.TableDefs.Delete DB.TableDefs(Tbl.Name)
       Else
          Create_Table = False
          Exit Function
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
   Create_Table = True

End Function

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

