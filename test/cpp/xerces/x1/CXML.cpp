#include <string>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <list>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <unistd.h>
#include <iconv.h>
#include "CXML.h"
bool XMLStringTranslate::UTF8_2_GB2312(char *in, int inLen, char *out, int outLen)     //码型转换
{
iconv_t cd = iconv_open( "gbk", "UTF-8" ); 
// check cd
if( (int)cd == -1 )
{
  cout << "iconv is ERROR" << endl;
  return false;
}
char *pin = in, *pout = out;
int  inLen_ = inLen + 1;
int  outLen_ = outLen;

iconv( cd, &pin, (size_t*)&inLen_, &pout, (size_t*)&outLen_ );
iconv_close(cd);
return true;
}
bool XMLStringTranslate::TranslatorUTF8ToChinese(string &strTranslatorMsg)      
{
char*  pstrSource = const_cast<char*>(strTranslatorMsg.c_str());
char   pstrDestination[strTranslatorMsg.length()*2+1];  //如此处编译出错，可改为char   *pstrDestination = new char[strTranslatorMsg.length()*2+1], 但要记住释放
memset(pstrDestination, '\0', strTranslatorMsg.length()*2+1);
if(!UTF8_2_GB2312(pstrSource, strTranslatorMsg.length(), pstrDestination, strTranslatorMsg.length()))
  return false;

strTranslatorMsg = pstrDestination;  
return true;
}
CXML::CXML()
{
    try
    {   
        // Initialize Xerces-C++ library
        XMLPlatformUtils::Initialize();
    }
    catch(xercesc::XMLException & excp)  
    {
        char* msg = XMLString::transcode(excp.getMessage());
        printf("XML toolkit initialization error: %s\n", msg);
        XMLString::release(&msg);
    }
    
    XMLTan = new XMLStringTranslate("utf-8");
    //创建 XercesDOMParser 对象，用于解析文档 
    m_DOMXmlParser = new XercesDOMParser;
}
CXML::~CXML()
{
    try
    {
        delete XMLTan;
        XMLPlatformUtils::Terminate();
    }
    catch(XMLException& excp)
    {
        char* msg = XMLString::transcode(excp.getMessage());
        printf("XML toolkit terminate error: %s\n", msg);
        XMLString::release(&msg);
    } 
}
void CXML::xmlParser(string & xmlFile) throw( std::runtime_error )
{
//获取文件信息状态 
    struct stat fileStatus;
    int iretStat = stat(xmlFile.c_str(), &fileStatus);
    if( iretStat == ENOENT )
  throw ( std::runtime_error("file_name does not exist, or path is an empty string.") );
    else if( iretStat == ENOTDIR )
  throw ( std::runtime_error("A component of the path is not a directory."));
    else if( iretStat == ELOOP )
  throw ( std::runtime_error("Too many symbolic links encountered while traversing the path."));
    else if( iretStat == EACCES )
  throw ( std::runtime_error("ermission denied."));
    else if( iretStat == ENAMETOOLONG )
        throw ( std::runtime_error("File can not be read\n"));
    
    //配置DOMParser
    m_DOMXmlParser->setValidationScheme( XercesDOMParser::Val_Auto );
    m_DOMXmlParser->setDoNamespaces( false );
    m_DOMXmlParser->setDoSchema( false );
    m_DOMXmlParser->setLoadExternalDTD( false );
    
    try
    {
        //调用 Xerces C++ 类库提供的解析接口 
        m_DOMXmlParser->parse(xmlFile.c_str()) ;
        
        //获得DOM树
  DOMDocument* xmlDoc = m_DOMXmlParser->getDocument();
  DOMElement *pRoot = xmlDoc->getDocumentElement();
  if (!pRoot )
  {
   throw(std::runtime_error( "empty XML document" ));
  }
  

     // create a walker to visit all text nodes.
  /**********************************************
  DOMTreeWalker *walker = 
  xmlDoc->createTreeWalker(pRoot, DOMNodeFilter::SHOW_TEXT, NULL, true);
  // use the tree walker to print out the text nodes.
  std::cout<< "TreeWalker:\n";
  
    for (DOMNode *current = walker->nextNode(); current != 0; current = walker->nextNode() )
    { 
    
   char *strValue = XMLString::transcode( current->getNodeValue() );
            std::cout <<strValue;
            XMLString::release(&strValue);
   }
   std::cout << std::endl;
  
  *************************************************/
  
  // create an iterator to visit all text nodes.
  DOMNodeIterator* iterator = xmlDoc->createNodeIterator(pRoot, 
   DOMNodeFilter::SHOW_TEXT,  NULL, true);
  
  // use the tree walker to print out the text nodes.
  std::cout<< "iterator:\n";
  
  for ( DOMNode * current = iterator->nextNode();
  current != 0; current = iterator->nextNode() )
  {
                   string strValue = XMLTan->translate(current->getNodeValue() );
          XMLTan->TranslatorUTF8ToChinese(strValue);
                   std::cout <<strValue<<endl;
     }
  
  std::cout<< std::endl; 
  
}
catch( xercesc::XMLException& excp )
{
  char* msg = xercesc::XMLString::transcode( excp.getMessage() );
  ostringstream errBuf;
  errBuf << "Error parsing file: " << msg << flush;
  XMLString::release( &msg );
} 
}
XMLStringTranslate::XMLStringTranslate(const char * const encoding):fFormatter(0),
m_value(0),fEncodingUsed(0),toFill(0)
{ 
XMLFormatTarget * myFormTarget = this;
fEncodingUsed=XMLString::transcode(encoding);
fFormatter = new XMLFormatter(fEncodingUsed
  ,myFormTarget
  ,XMLFormatter::NoEscapes
  ,XMLFormatter::UnRep_CharRef);
toFill=new XMLCh[kTmpBufSize];
clearbuffer();
}
XMLStringTranslate::~XMLStringTranslate()
{
if(fFormatter)
  delete fFormatter;
if(fEncodingUsed)
  delete [] fEncodingUsed;
if(m_value)
  free(m_value); 
if(toFill)
  free(toFill);

fFormatter=0;
fEncodingUsed=0;
m_value=0;
toFill=0;
}
void XMLStringTranslate::writeChars(const XMLByte* const  toWrite
         , const unsigned int    count
         , XMLFormatter* const   formatter)
{
  if(m_value)
  free(m_value);
m_value=0;
m_value=new char[count+1];
memset(m_value,0,count+1);
memcpy(m_value,(char *)toWrite,count+1); 
}
void XMLStringTranslate::clearbuffer()
{
if(!toFill)
  return;
for(int i=0;i<kTmpBufSize;i++)
  toFill[i]=0;
}
string XMLStringTranslate::translate(const XMLCh* const value)   //实现从 XMLCh* 到 string类型的转换
{
*fFormatter<<value; 
string strValue=string(m_value);
return strValue;
}
const XMLCh * const XMLStringTranslate::translate(const char * const value)
{ 
clearbuffer();
const unsigned int  srcCount=XMLString::stringLen(value);
unsigned char fCharSizeBuf[kCharBufSize];
XMLTranscoder * pTranscoder=(XMLTranscoder *)fFormatter->getTranscoder();  
unsigned int bytesEaten;
unsigned int size=pTranscoder->transcodeFrom(
                                           (XMLByte *)value,
                                                  srcCount,
                                            toFill,
                                            kTmpBufSize,
                                            bytesEaten,
                                            fCharSizeBuf
                                            );
toFill[size]=0; 
string t1=string(value);
string t2=translate(toFill);
assert(t1==t2);
return toFill;
}
#ifdef  MAIN_TEST
int main()
{
string xmlFile = "sample.xml"; 
CXML cxml;
cxml.xmlParser(xmlFile);
return 0;
}
#endif