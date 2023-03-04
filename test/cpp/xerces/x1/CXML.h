#ifndef XML_PARSER_HPP
#define XML_PARSER_HPP
#include <xercesc/util/TransService.hpp>
#include <xercesc/dom/DOM.hpp>
#include <xercesc/dom/DOMDocument.hpp>
#include <xercesc/dom/DOMDocumentType.hpp>
#include <xercesc/dom/DOMElement.hpp>
#include <xercesc/dom/DOMImplementation.hpp>
#include <xercesc/dom/DOMImplementationLS.hpp>
#include <xercesc/dom/DOMNodeIterator.hpp>
#include <xercesc/dom/DOMNodeList.hpp>
#include <xercesc/dom/DOMText.hpp>
#include <xercesc/dom/DOMAttr.hpp>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/util/XMLUni.hpp>
#include <xercesc/framework/XMLFormatter.hpp>
#include <xercesc/util/XMLString.hpp> 
#include <stdlib.h>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;
using namespace xercesc;
class XMLStringTranslate;  
class CXML
{
public:
     CXML();
     ~CXML();
     XMLTransService::Codes tranServiceCode;
     void xmlParser(string&) throw(std::runtime_error);
private:
     XMLStringTranslate *XMLTan;
     xercesc::XercesDOMParser *m_DOMXmlParser;   //定义解析对象
};
class XMLStringTranslate  : public XMLFormatTarget 
{
public:
    
     XMLStringTranslate(const char * const encoding);
     bool TranslatorUTF8ToChinese(string &strTranslatorMsg);
     bool UTF8_2_GB2312(char *in, int inLen, char *out, int outLen);
     string translate(const XMLCh* const value);
     const XMLCh * const translate(const char * const value);
     virtual ~XMLStringTranslate();

protected:
     XMLFormatter * fFormatter;
     XMLCh        *  fEncodingUsed;
     XMLCh        *  toFill;  
     char *  m_value;
protected:
    enum Constants
    {
        kTmpBufSize     = 16 * 1024, 
     kCharBufSize    = 16 * 1024
    };
   void clearbuffer();
    virtual void writeChars(const XMLByte* const toWrite
                          , const unsigned int   count
                          , XMLFormatter* const  formatter);
};
#endif