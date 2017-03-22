VERSION 2.00
Begin Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5820
   ClientLeft      =   1095
   ClientTop       =   1485
   ClientWidth     =   7365
   Height          =   6225
   Left            =   1035
   LinkTopic       =   "Form1"
   ScaleHeight     =   5820
   ScaleWidth      =   7365
   Top             =   1140
   Width           =   7485
End
Option Explicit

Sub Form_Click ()
   Static xDays(5) As Integer
   Static xRate(5) As Integer
   Dim TempDays As Integer
   Dim i As Integer
   Dim CarryOn As Integer

   xDays(1) = 45
   xRate(1) = 7
   xDays(2) = 60
   xRate(2) = 7
   xDays(3) = 15
   xRate(3) = 7
   xDays(4) = 90
   xRate(4) = 7
   xDays(5) = 25
   xRate(5) = 7

   i = 1
   Do While i < 5
      If xDays(i) > xDays(i + 1) Then
         TempDays = xDays(i)
         xDays(i) = xDays(i + 1)
         xDays(i + 1) = TempDays
         i = 1
      Else
         i = i + 1
      End If
   Loop

   Debug.Print "----------------------------"
   For i = 1 To 5
      Debug.Print i & " = " & xDays(i)
   Next i

End Sub

