
#include "stdafx.h"
#include "..\stuff\inifile.h"

CIniFile::CIniFile(CString &IniFilename)
{
   m_IniFilename = IniFilename;
   m_Section = "";
}

CIniFile::CIniFile(CString &IniFilename,CString &Section)
{
   m_IniFilename = IniFilename;
   m_Section = Section;
}

CIniFile::~CIniFile()
{
}

void CIniFile::SetSection(CString &Section)
{
   m_Section = Section;
}

void CIniFile::Write(const CString &Label, const CString &Value)
{
   WritePrivateProfileString ( m_Section, Label, Value, m_IniFilename );
}

CString CIniFile::Read(const CString &Label)
{
   CString Value;

   GetPrivateProfileString ( m_Section, Label, "NotFound", Value.GetBuffer(256), _MAX_PATH, m_IniFilename);
   Value.ReleaseBuffer();
   if (Value=="NotFound")
   {
      CIniFileException e;
      e.m_IniFilename = m_IniFilename;
      e.m_Section = m_Section;
      e.m_Label = Label;
      e.m_Value = Value;
      e.ErrorNo = CIniFileException::INI_LABEL_NOT_FOUND;
      e.ErrorMsg = "[" + m_Section + "] " + Label + " not found in " + m_IniFilename;
      throw e;
   }
   return Value;
}
