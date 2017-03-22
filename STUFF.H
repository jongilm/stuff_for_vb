// stuff.h

extern int atoin ( char *str, int n );
extern void StrCpyAndSpaceFill ( char *pStr, CString &CStr, int cbStr );
extern CString SetFileExtension ( const CString &Filename, const CString Extension );
extern BOOL IsEmpty ( char *pStr, int cbStr );

int  EscapePressed ( void );
int FileExists ( char *Filename );
void ZString2LString ( char *pLString, int cbLString, char *szString );
void CheckErc ( WORD Erc );
void _cdecl DisplayProgress ( char *Format,... );
BOOLEAN IsSpaces( const char *szStr );
BOOLEAN IsSpaces( const char *pStr, int cbStr );
int LengthWithoutTrailingSpaces ( char *pStr, int cbStr );
void ToUpper ( char *pDataIn, int cbData );

#define MsgBox PopUp
void _cdecl PopUp ( char *Format,... );
void _cdecl PopOut(char *Format,...);
