' GetSystemMetrics() codes
Global Const SM_CXSCREEN = 0
Global Const SM_CYSCREEN = 1
Global Const SM_CXVSCROLL = 2
Global Const SM_CYHSCROLL = 3
Global Const SM_CYCAPTION = 4
Global Const SM_CXBORDER = 5
Global Const SM_CYBORDER = 6
Global Const SM_CXDLGFRAME = 7
Global Const SM_CYDLGFRAME = 8
Global Const SM_CYVTHUMB = 9
Global Const SM_CXHTHUMB = 10
Global Const SM_CXICON = 11
Global Const SM_CYICON = 12
Global Const SM_CXCURSOR = 13
Global Const SM_CYCURSOR = 14
Global Const SM_CYMENU = 15
Global Const SM_CXFULLSCREEN = 16
Global Const SM_CYFULLSCREEN = 17
Global Const SM_CYKANJIWINDOW = 18
Global Const SM_MOUSEPRESENT = 19
Global Const SM_CYVSCROLL = 20
Global Const SM_CXHSCROLL = 21
Global Const SM_DEBUG = 22
Global Const SM_SWAPBUTTON = 23
Global Const SM_RESERVED1 = 24
Global Const SM_RESERVED2 = 25
Global Const SM_RESERVED3 = 26
Global Const SM_RESERVED4 = 27
Global Const SM_CXMIN = 28
Global Const SM_CYMIN = 29
Global Const SM_CXSIZE = 30
Global Const SM_CYSIZE = 31
Global Const SM_CXFRAME = 32
Global Const SM_CYFRAME = 33
Global Const SM_CXMINTRACK = 34
Global Const SM_CYMINTRACK = 35
Global Const SM_CMETRICS = 36

' MessageBox() Flags
Global Const MB_OK = &H0
Global Const MB_OKCANCEL = &H1
Global Const MB_ABORTRETRYIGNORE = &H2
Global Const MB_YESNOCANCEL = &H3
Global Const MB_YESNO = &H4
Global Const MB_RETRYCANCEL = &H5

Global Const MB_ICONHAND = &H10
Global Const MB_ICONQUESTION = &H20
Global Const MB_ICONEXCLAMATION = &H30
Global Const MB_ICONASTERISK = &H40

Global Const MB_ICONINFORMATION = MB_ICONASTERISK
Global Const MB_ICONSTOP = MB_ICONHAND

Global Const MB_DEFBUTTON1 = &H0
Global Const MB_DEFBUTTON2 = &H100
Global Const MB_DEFBUTTON3 = &H200

Global Const MB_APPLMODAL = &H0
Global Const MB_SYSTEMMODAL = &H1000
Global Const MB_TASKMODAL = &H2000

Global Const MB_NOFOCUS = &H8000

Global Const MB_TYPEMASK = &HF
Global Const MB_ICONMASK = &HF0
Global Const MB_DEFMASK = &HF00
Global Const MB_MODEMASK = &H3000
Global Const MB_MISCMASK = &HC000

' GetWindow() Constants
Global Const GW_HWNDFIRST = 0
Global Const GW_HWNDLAST = 1
Global Const GW_HWNDNEXT = 2
Global Const GW_HWNDPREV = 3
Global Const GW_OWNER = 4
Global Const GW_CHILD = 5

Global Const SC_SIZE = &HF000
Global Const SC_MOVE = &HF010
Global Const SC_MINIMIZE = &HF020
Global Const SC_MAXIMIZE = &HF030
Global Const SC_NEXTWINDOW = &HF040
Global Const SC_PREVWINDOW = &HF050
Global Const SC_CLOSE = &HF060
Global Const SC_VSCROLL = &HF070
Global Const SC_HSCROLL = &HF080
Global Const SC_MOUSEMENU = &HF090
Global Const SC_KEYMENU = &HF100
Global Const SC_ARRANGE = &HF110
Global Const SC_RESTORE = &HF120
Global Const SC_TASKLIST = &HF130

Global Const SC_ICON = SC_MINIMIZE
Global Const SC_ZOOM = SC_MAXIMIZE

' Standard Cursor IDs
Global Const IDC_ARROW = 32512&
Global Const IDC_IBEAM = 32513&
Global Const IDC_WAIT = 32514&
Global Const IDC_CROSS = 32515&
Global Const IDC_UPARROW = 32516&
Global Const IDC_SIZE = 32640&
Global Const IDC_ICON = 32641&
Global Const IDC_SIZENWSE = 32642&
Global Const IDC_SIZENESW = 32643&
Global Const IDC_SIZEWE = 32644&
Global Const IDC_SIZENS = 32645&

' Standard Icon IDs
Global Const IDI_APPLICATION = 32512&
Global Const IDI_HAND = 32513&
Global Const IDI_QUESTION = 32514&
Global Const IDI_EXCLAMATION = 32515&
Global Const IDI_ASTERISK = 32516&

' Dialog Box Command IDs
Global Const IDOK = 1
Global Const IDCANCEL = 2
Global Const IDABORT = 3
Global Const IDRETRY = 4
Global Const IDIGNORE = 5
Global Const IDYES = 6
Global Const IDNO = 7


Type Rect
	Left As Integer
	Top As Integer
	right As Integer
	bottom As Integer
End Type

Type POINTAPI
	x As Integer
	y As Integer
End Type

Type TEXTMETRIC
	tmHeight As Integer
	tmAscent As Integer
	tmDescent As Integer
	tmInternalLeading As Integer
	tmExternalLeading As Integer
	tmAveCharWidth As Integer
	tmMaxCharWidth As Integer
	tmWeight As Integer
	tmItalic As String * 1
	tmUnderlined As String * 1
	tmStruckOut As String * 1
	tmFirstChar As String * 1
	tmLastChar As String * 1
	tmDefaultChar As String * 1
	tmBreakChar As String * 1
	tmPitchAndFamily As String * 1
	tmCharSet As String * 1
	tmOverhang As Integer
	tmDigitizedAspectX As Integer
	tmDigitizedAspectY As Integer
End Type


Declare Function WinExec Lib "Kernel" (ByVal lpCmdLine As String, ByVal nCmdShow As Integer) As Integer
Declare Sub OutputDebugString Lib "Kernel" (ByVal lpOutputString As String)

' User Profile Routines
' NOTE: The lpKeyName argument for GetProfileString, WriteProfileString,
'       GetPrivateProfileString, and WritePrivateProfileString can be either
'       a string or NULL.  This is why the argument is defined as "By Any".
'          For example, to pass a string specify   ByVal "wallpaper"
'          To pass NULL specify                    ByVal 0&
'       You can also pass NULL for the lpString argument for WriteProfileString
'       and WritePrivateProfileString
Declare Function GetProfileInt Lib "Kernel" (ByVal lpAppName As String, ByVal lpKeyName As String, ByVal nDefault As Integer) As Integer
Declare Function GetProfileString Lib "Kernel" (ByVal lpAppName As String, lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Integer) As Integer
Declare Function WriteProfileString Lib "Kernel" (ByVal lpApplicationName As String, lpKeyName As Any, lpString As Any) As Integer
Declare Function GetPrivateProfileInt Lib "Kernel" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal nDefault As Integer, ByVal lpFileName As String) As Integer
Declare Function GetPrivateProfileString Lib "Kernel" (ByVal lpApplicationName As String, lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Integer, ByVal lpFileName As String) As Integer
Declare Function WritePrivateProfileString Lib "Kernel" (ByVal lpApplicationName As String, lpKeyName As Any, lpString As Any, ByVal lplFileName As String) As Integer
Declare Function GetWindowsDirectory Lib "Kernel" (ByVal lpBuffer As String, ByVal nSize As Integer) As Integer
Declare Function GetSystemDirectory Lib "Kernel" (ByVal lpBuffer As String, ByVal nSize As Integer) As Integer
Declare Function GetTextMetrics Lib "GDI" (ByVal hDC As Integer, lpMetrics As TEXTMETRIC) As Integer
Declare Function wvsprintf Lib "User" (ByVal lpOutput As String, ByVal lpFormat As String, lpArglist As Integer) As Integer
Declare Function lstrcmp Lib "User" (ByVal lpString1 As Any, ByVal lpString2 As Any) As Integer
Declare Function lstrcmpi Lib "User" (ByVal lpString1 As Any, ByVal lpString2 As Any) As Integer
Declare Function lstrcpy Lib "Kernel" (ByVal lpString1 As Any, ByVal lpString2 As Any) As Long
Declare Function lstrcat Lib "Kernel" (ByVal lpString1 As Any, ByVal lpString2 As Any) As Long
Declare Function lstrlen Lib "Kernel" (ByVal lpString As Any) As Integer
Declare Function SendMessage Lib "User" (ByVal hWnd As Integer, ByVal wMsg As Integer, ByVal wParam As Integer, lParam As Any) As Long
Declare Function PostMessage Lib "User" (ByVal hWnd As Integer, ByVal wMsg As Integer, ByVal wParam As Integer, lParam As Any) As Integer
Declare Function PostAppMessage Lib "User" (ByVal hTask As Integer, ByVal wMsg As Integer, ByVal wParam As Integer, lParam As Any) As Integer
Declare Sub PostQuitMessage Lib "User" (ByVal nExitCode As Integer)
Declare Function IsWindow Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function IsChild Lib "User" (ByVal hWndParent As Integer, ByVal hWnd As Integer) As Integer
Declare Function DestroyWindow Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function GetSystemMetrics Lib "User" (ByVal nIndex As Integer) As Integer
Declare Function SetProp Lib "User" (ByVal hWnd As Integer, ByVal lpString As String, ByVal hData As Integer) As Integer
Declare Function GetProp Lib "User" (ByVal hWnd As Integer, ByVal lpString As Any) As Integer
Declare Function RemoveProp Lib "User" (ByVal hWnd As Integer, ByVal lpString As String) As Integer
Declare Sub SetWindowText Lib "User" (ByVal hWnd As Integer, ByVal lpString As String)
Declare Function GetWindowText Lib "User" (ByVal hWnd As Integer, ByVal lpString As String, ByVal aint As Integer) As Integer
Declare Function GetWindowTextLength Lib "User" (ByVal hWnd As Integer) As Integer
Declare Sub GetClientRect Lib "User" (ByVal hWnd As Integer, lpRect As Rect)
Declare Sub GetWindowRect Lib "User" (ByVal hWnd As Integer, lpRect As Rect)
Declare Sub AdjustWindowRect Lib "User" (lpRect As Rect, ByVal dwStyle As Long, ByVal bMenu As Integer)
Declare Sub AdjustWindowRectEx Lib "User" (lpRect As Rect, ByVal dsStyle As Long, ByVal bMenu As Integer, ByVal dwEsStyle As Long)
Declare Sub ClientToScreen Lib "User" (ByVal hWnd As Integer, lpPoint As POINTAPI)
Declare Sub ScreenToClient Lib "User" (ByVal hWnd As Integer, lpPoint As POINTAPI)
Declare Function WindowFromPoint Lib "User" (ByVal ptScreen As Any) As Integer
Declare Function ChildWindowFromPoint Lib "User" (ByVal hWnd As Integer, ByVal ptScreen As Any) As Integer
Declare Function GetCurrentTime Lib "User" () As Long
Declare Function GetTickCount Lib "User" () As Long
Declare Function GetWindowWord Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Integer
Declare Function SetWindowWord Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer, ByVal wNewWord As Integer) As Integer
Declare Function GetWindowLong Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Long
Declare Function SetWindowLong Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer, ByVal dwNewLong As Long) As Long
Declare Function GetClassWord Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Integer
Declare Function SetClassWord Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer, ByVal wNewWord As Integer) As Integer
Declare Function GetClassLong Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Long
Declare Function SetClassLong Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer, ByVal dwNewLong As Long) As Long
Declare Function GetDesktopHwnd Lib "User" () As Integer
Declare Function GetDesktopWindow Lib "User" () As Integer
Declare Function GetParent Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function SetParent Lib "User" (ByVal hWndChild As Integer, ByVal hWndNewParent As Integer) As Integer
Declare Function FindWindow Lib "User" (ByVal lpClassName As Any, ByVal lpWindowName As Any) As Integer
Declare Function GetClassName Lib "User" (ByVal hWnd As Integer, ByVal lpClassName As String, ByVal nMaxCount As Integer) As Integer
Declare Function GetTopWindow Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function GetNextWindow Lib "User" (ByVal hWnd As Integer, ByVal wFlag As Integer) As Integer
Declare Function GetWindowTask Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function GetLastActivePopup Lib "User" (ByVal hwndOwnder As Integer) As Integer

Declare Function GetWindow Lib "User" (ByVal hWnd As Integer, ByVal wCmd As Integer) As Integer

Sub ResizeControlToForm (aCtl As Control, aForm As Form)
   Dim aRect As Rect
   aCtl.Left = 0
   aCtl.Top = 0
   GetClientRect aForm.hWnd, aRect
   aCtl.Width = aRect.right * screen.TwipsPerPixelY
   aCtl.Height = aRect.bottom * screen.TwipsPerPixelX
End Sub

Function ScreenWidth () As Integer
  ScreenWidth = GetSystemMetrics(SM_CXSCREEN)
End Function

