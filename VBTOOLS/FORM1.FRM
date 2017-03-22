VERSION 2.00
Begin Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3975
   ClientLeft      =   1095
   ClientTop       =   1485
   ClientWidth     =   7320
   Height          =   4380
   Left            =   1035
   LinkTopic       =   "Form1"
   ScaleHeight     =   3975
   ScaleWidth      =   7320
   Top             =   1140
   Width           =   7440
   Begin SSPanel Panel3D1 
      BevelInner      =   1  'Inset
      Height          =   3975
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   7335
      Begin TextBox Text1 
         Height          =   495
         Left            =   2160
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   2400
         Width           =   3615
      End
   End
End

Sub Form_Resize ()
    ResizeControlToForm Panel3d1, Form1
End Sub

