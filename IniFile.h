class CIniFile
{
public:
   CIniFile(CString &IniFilename);
   CIniFile(CString &IniFilename,CString &Section);
   ~CIniFile();
   void SetSection(CString &Section);
   CString Read(const CString &Label);
   void Write(const CString &Label, const CString &Value);
private:
   CString m_IniFilename;
   CString m_Section;

};

//#define INI_LABEL_NOT_FOUND 1
class CIniFileException
{

public:
   CString m_IniFilename;
   CString m_Section;
   CString m_Label;
   CString m_Value;
   int ErrorNo;
   CString ErrorMsg;
   enum ErrorNos {INI_SECTION_NOT_FOUND=1, INI_LABEL_NOT_FOUND=2};
};
