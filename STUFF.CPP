
#include "stdafx.h"
#include "stuff.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

int atoin ( char *str, int n )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{
   char s[21];
   if (!str || !str[0] || !n) return 0;
   if (n>20) n = 20;
   memcpy ( s, str, n);
   s[n] = 0;
   return atoi(s);
}

void StrCpyAndSpaceFill ( char *pStr, CString &CStr, int cbStr )
{           
   memset ( pStr, ' ', cbStr);
   memcpy ( pStr, CStr, min(CStr.GetLength(),cbStr) ); 
}   

CString SetFileExtension ( const CString &Filename, const CString Extension )
{
   char New_Filename[_MAX_PATH];
   char drive[_MAX_DRIVE];
   char dir[_MAX_DIR];
   char fname[_MAX_FNAME];
   char ext[_MAX_EXT];

   _splitpath( Filename, drive, dir, fname, ext );
   _makepath( New_Filename, drive, dir, fname, Extension );
   return New_Filename;
}

BOOL IsEmpty ( char *pStr, int cbStr )
{
   if (!pStr) 
      return TRUE;

   for (int i=0;i<cbStr;i++)
   {
      if (pStr[i]!=0 && pStr[i]!=' ')
         return FALSE;
   }
   return TRUE;
}


#pragma optimize("lge",off)
int  EscapePressed ( void )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{
   //if (kbhit())
   //{
   //   if (getch()==27) return 1;
   //}
/*
   unsigned char key;
   _asm
   {
      mov ah, 1
      int 16h
      jz  hit
      mov al,0
      hit:
      mov key,al
   }
   if (key==27) return 1;
*/
   return 0;
}

#pragma optimize("",on)  /* restore previous values */

int FileExists ( char *Filename )
{
   FILE *f;
   f = fopen(Filename,"rb");
   if (f==NULL)
      return FALSE;
   fclose(f);
   return TRUE;
/* probably better...
   struct _find_t find;
   if( !_dos_findfirst( Filename, 0xffff, &find ) )
      return TRUE;
   return FALSE;
*/
}

void ZString2LString ( char *pLString, int cbLString, char *szString )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{
   int len;

   if (strlen(szString) > (unsigned int)cbLString)
      len = cbLString;
   else
      len = (int)strlen(szString);

   memcpy( &pLString[1], szString, len );
   pLString[0] = (char)len;
}

void CheckErc ( WORD Erc )
{
   if ( Erc != 0 )
   {
      MsgBox( "CheckErc : Error %d\n",Erc);
      exit(Erc);
   }
}

void _cdecl DisplayProgress ( char *Format,... )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{

   va_list marker;
   char *Str = new char[2000];
   if (!Str) { DisplayProgress("Insufficient memory for DisplayProgress Str"); exit(99); }

   va_start( marker, Format );
#ifdef _WINDOWS
   wvsprintf(Str,Format,marker);
#else
   vsprintf((GPSTR)Str,Format,marker);
#endif
   va_end( marker );

#ifdef _WINDOWS
   OutputDebugString(Str);
   OutputDebugString("\r\n");
#else
   printf(Str);
#endif

   delete Str;

}

void _cdecl PopUp ( char *Format,... )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{
   va_list marker;
   char *Str = new char[2000];
   if (!Str) { AfxMessageBox("Insufficient memory for PopUp Str"); exit(99); }

   va_start( marker, Format );
   wvsprintf(Str,Format,marker);
   va_end( marker );

   AfxMessageBox(Str);

   delete Str;
}

void _cdecl PopOut(char *Format,...)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{
   va_list marker;
   char *Str = new char[2000];
   if (!Str) { AfxMessageBox("Insufficient memory for PopOut Str"); exit(99); }

   va_start( marker, Format );
   wvsprintf(Str,Format,marker);
   va_end( marker );

   OutputDebugString(Str);
   OutputDebugString("\r\n");

   delete Str;
}

BOOLEAN IsSpaces( const char *szStr )
{
   if (strspn(szStr," ")==strlen(szStr))
      return TRUE;
   return FALSE;
}

BOOLEAN IsSpaces( const char *pStr, int cbStr )
{
   for ( int i=0; i<cbStr; i++ )
      if (pStr[i] != ' ') return FALSE;
   return TRUE;
}

int LengthWithoutTrailingSpaces ( char *pStr, int cbStr )
{
   int i;

   for ( i=cbStr-1; i>=0; i-- )
      if ( !isspace(pStr[i]) )
         return i+1;
   return 0;
}

void ToUpper ( char *pDataIn, int cbData )
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*/
/*³                                                  ³*/
/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
{
   int i;
   for ( i=0; i<=cbData-1; i++ )
      pDataIn[i] = toupper(pDataIn[i]);
}

char *GetErrorMessage ( unsigned int ErcReqd, char *szMessage81, char *szFilename )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³
//³ If szFilename is NULL, the last filename specified is used. 
//³
//³ If an error occurs one of the following are returned:
//³    "*** Unable to retrieve message. Insufficient memory ***"
//³    "*** Unable to retrieve message. Filename not specified ***"
//³    "*** Unable to retrieve message. Failed to open file ***"
//³
//³ If an error occurs one of the following are returned:
//³
//³ The message file must have the following format:
//³
//³ <Leader><Code><Delimiter><Message><Terminator>
//³ Where: <Leader>    = Zero or more non-numeric characters (ignored).
//³        <Code>      = Numeric message code (value 1..65535).
//³        <Delimiter> = Any non-numeric character (ignored).
//³        <Message>   = Any message string (first 80 chars are significant).
//³        <Terminator>= CR or LF or both
//³
//³ eg. If the file c:\doddle\ERRORS.MSG contained the line 
//³           "   00027 Sector not found\r\n" 
//³
//³     char TempBuffer81[81];
//³     GetErrorMessage(27,TempBuffer81,"c:\\doddle\\ERRORS.MSG");
//³     would return with "Sector not found\0" in TempBuffer81.
//³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
{
   static char  ErrorFileName[_MAX_PATH] = {0};
   unsigned int ErcFound                 = 0;
   int          DecodeMsg                = FALSE;
   FILE        *pErrorFile               = NULL;
   char        *pBuffer                  = NULL;
   int          j;
    
   strcpy ( szMessage81, "*** Unable to retrieve message. " );
   pBuffer = new char [400+1]; // extra 1 incase we need to add a '\n' to the end of the last block
   if ( !pBuffer )
   {
      strcat ( szMessage81, "Insufficient memory ***" );
      return szMessage81;
   }

   if (szFilename) strcpy ( ErrorFileName, szFilename );
   if (ErrorFileName[0] == 0) 
   {
      delete pBuffer;
      strcat ( szMessage81, "Filename not specified ***" );
      return szMessage81;
   }

   pErrorFile = fopen ( ErrorFileName, "rb" );
   if ( !pErrorFile )
   {
      delete pBuffer;
      strcat ( szMessage81, "Failed to open file ***" );
      return szMessage81;
   }

   szMessage81[0] = 0;
   while ( !feof(pErrorFile) )
   {
      int cnt = fread ( pBuffer, 1, 400, pErrorFile );
      if (feof(pErrorFile) && pBuffer[cnt-1] != '\r' && pBuffer[cnt-1] != '\n')
      {
         pBuffer[cnt] = '\n';
         cnt++;
      }

      for ( j=0; j<cnt; j++ )
      {
         if ( DecodeMsg )
         {
            if ( pBuffer[j] == '\r' || pBuffer[j] == '\n' )
            {
               if ( ErcReqd == ErcFound )
               {
                  fclose ( pErrorFile );
                  delete pBuffer;
                  return szMessage81;
               }
               DecodeMsg      = FALSE;
               szMessage81[0] = 0;
               ErcFound       = 0;
               continue;
            }
            if ( strlen(szMessage81) < 80 )
            {
               int len = strlen(szMessage81);
               szMessage81[len] = pBuffer[j];
               szMessage81[len+1] = 0;
            }
            // If this is the last byte in the file
            //if (feof(pErrorFile) && j==cnt-1)
            //   break;
            continue;
         }

         if ( pBuffer[j] < '0' || pBuffer[j] > '9' )
         {
            if ( ErcFound > 0 ) DecodeMsg = TRUE;
            continue;
         }
         ErcFound = ErcFound*10 + pBuffer[j] - '0';
      }
   }
   fclose ( pErrorFile );
   delete pBuffer;
   return szMessage81;
}

int GetErrorMessageTest ( void )
{
   //char TempBuffer81[81];
   //printf("\"%s\"\n",GetErrorMessage(1,TempBuffer81,"c:\\doddle\\ERRORS.MSG") );
   //printf("\"%s\"\n",GetErrorMessage(400,TempBuffer81,"c:\\doddle\\ERRORS.MSG") );
   //printf("\"%s\"\n",GetErrorMessage(40098,TempBuffer81,NULL) );
   //printf("\"%s\"\n",GetErrorMessage(30098,TempBuffer81,NULL) );
   //printf("\"%s\"\n",GetErrorMessage(2,TempBuffer81,"ERRORS.MSG") );
   return 0;
}
