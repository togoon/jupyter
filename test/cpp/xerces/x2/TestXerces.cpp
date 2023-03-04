#include "stdafx.h"
#include <iostream>
 
using namespace std;
 
XERCES_CPP_NAMESPACE_USE
 
class XStr
{
public :
	// -----------------------------------------------------------------------
	//  Constructors and Destructor
	// -----------------------------------------------------------------------
	XStr(const char* const toTranscode)
	{
		// Call the private transcoding method
		fUnicodeForm = XMLString::transcode(toTranscode);
	}
 
	~XStr()
	{
		XMLString::release(&fUnicodeForm);
	}
 
	// -----------------------------------------------------------------------
	//  Getter methods
	// -----------------------------------------------------------------------
	const XMLCh* unicodeForm() const
	{
		return fUnicodeForm;
	}
 
private :
	// -----------------------------------------------------------------------
	//  Private data members
	//
	//  fUnicodeForm
	//      This is the Unicode XMLCh format of the string.
	// -----------------------------------------------------------------------
	XMLCh*   fUnicodeForm;
};
 
#define X(str) XStr(str).unicodeForm()
 
/*
* This sample illustrates how you can create a DOM tree in memory.
* It then prints the count of elements in the tree.
*/
int CreateDOMDocument()
{
	// Initialize the XML4C2 system.
	try {
		XMLPlatformUtils::Initialize();
	} catch(const XMLException& toCatch) {
		char *pMsg = XMLString::transcode(toCatch.getMessage());
		XERCES_STD_QUALIFIER cerr << "Error during Xerces-c Initialization.\n"
			<< "  Exception message:"
			<< pMsg;
		XMLString::release(&pMsg);
		return 1;
	}
 
	// Watch for special case help request
	int errorCode = 0;
 
	/*{
	XERCES_STD_QUALIFIER cout << "\nUsage:\n"
	"    CreateDOMDocument\n\n"
	"This program creates a new DOM document from scratch in memory.\n"
	"It then prints the count of elements in the tree.\n"
	<< XERCES_STD_QUALIFIER endl;
	errorCode = 1;
	}*/
	if(errorCode) {
		XMLPlatformUtils::Terminate();
		return errorCode;
	}
 
	{
		//  Nest entire test in an inner block.
		//  The tree we create below is the same that the XercesDOMParser would
		//  have created, except that no whitespace text nodes would be created.
 
		// <company>
		//     <product>Xerces-C</product>
		//     <category idea='great'>XML Parsing Tools</category>
		//     <developedBy>Apache Software Foundation</developedBy>
		// </company>
		DOMImplementation* impl =  DOMImplementationRegistry::getDOMImplementation(X("Core"));
 
		if (impl != NULL) {
			try {
				DOMDocument* doc = impl->createDocument(
					0,                    // root element namespace URI.
					X("company"),         // root element name
					0);                   // document type object (DTD).
 
				DOMElement* rootElem = doc->getDocumentElement();
 
				DOMElement*  prodElem = doc->createElement(X("product"));
				rootElem->appendChild(prodElem);
 
				DOMText*    prodDataVal = doc->createTextNode(X("Xerces-C"));
				prodElem->appendChild(prodDataVal);
 
				DOMElement*  catElem = doc->createElement(X("category"));
				rootElem->appendChild(catElem);
 
				catElem->setAttribute(X("idea"), X("great"));
 
				DOMText*    catDataVal = doc->createTextNode(X("XML Parsing Tools"));
				catElem->appendChild(catDataVal);
 
				DOMElement*  devByElem = doc->createElement(X("developedBy"));
				rootElem->appendChild(devByElem);
 
				DOMText*    devByDataVal = doc->createTextNode(X("Apache Software Foundation"));
				devByElem->appendChild(devByDataVal);
 
				//
				// Now count the number of elements in the above DOM tree.
				//
				const XMLSize_t elementCount = doc->getElementsByTagName(X("*"))->getLength();
				XERCES_STD_QUALIFIER cout << "The tree just created contains: " << elementCount
					<< " elements." << XERCES_STD_QUALIFIER endl;
 
				doc->release();
			} catch (const OutOfMemoryException&) {
				XERCES_STD_QUALIFIER cerr << "OutOfMemoryException" << XERCES_STD_QUALIFIER endl;
				errorCode = 5;
			} catch (const DOMException& e) {
				XERCES_STD_QUALIFIER cerr << "DOMException code is:  " << e.code << XERCES_STD_QUALIFIER endl;
				errorCode = 2;
			} catch (...) {
				XERCES_STD_QUALIFIER cerr << "An error occurred creating the document" << XERCES_STD_QUALIFIER endl;
				errorCode = 3;
			}
		} else{// (inpl != NULL)
			XERCES_STD_QUALIFIER cerr << "Requested implementation is not supported" << XERCES_STD_QUALIFIER endl;
			errorCode = 4;
		}
	}
 
	XMLPlatformUtils::Terminate();
	return errorCode;
}
 
 
// ---------------------------------------------------------------------------
//  This is a simple class that lets us do easy (though not terribly efficient)
//  transcoding of XMLCh data to local code page for display.
// ---------------------------------------------------------------------------
class StrX
{
public :
	// -----------------------------------------------------------------------
	//  Constructors and Destructor
	// -----------------------------------------------------------------------
	StrX(const XMLCh* const toTranscode)
	{
		// Call the private transcoding method
		fLocalForm = XMLString::transcode(toTranscode);
	}
 
	~StrX()
	{
		XMLString::release(&fLocalForm);
	}
 
	// -----------------------------------------------------------------------
	//  Getter methods
	// -----------------------------------------------------------------------
	const char* localForm() const
	{
		return fLocalForm;
	}
 
private :
	// -----------------------------------------------------------------------
	//  Private data members
	//
	//  fLocalForm
	//      This is the local code page form of the string.
	// -----------------------------------------------------------------------
	char*   fLocalForm;
};
 
inline XERCES_STD_QUALIFIER ostream& operator<<(XERCES_STD_QUALIFIER ostream& target, const StrX& toDump)
{
	target << toDump.localForm();
	return target;
}
 
int SAXPrint()
{
	// ---------------------------------------------------------------------------
	//  Local data
	//
	//  doNamespaces
	//      Indicates whether namespace processing should be enabled or not.
	//      Defaults to disabled.
	//
	//  doSchema
	//      Indicates whether schema processing should be enabled or not.
	//      Defaults to disabled.
	//
	//  schemaFullChecking
	//      Indicates whether full schema constraint checking should be enabled or not.
	//      Defaults to disabled.
	//
	//  encodingName
	//      The encoding we are to output in. If not set on the command line,
	//      then it is defaulted to LATIN1.
	//
	//  xmlFile
	//      The path to the file to parser. Set via command line.
	//
	//  valScheme
	//      Indicates what validation scheme to use. It defaults to 'auto', but
	//      can be set via the -v= command.
	// ---------------------------------------------------------------------------
	static bool                     doNamespaces        = false;
	static bool                     doSchema            = false;
	static bool                     schemaFullChecking  = false;
	static const char*              encodingName    = "LATIN1";
	static XMLFormatter::UnRepFlags unRepFlags      = XMLFormatter::UnRep_CharRef;
	static char*                    xmlFile         = 0;
	static SAXParser::ValSchemes    valScheme       = SAXParser::Val_Auto;
 
	// Initialize the XML4C2 system
	try {
		XMLPlatformUtils::Initialize();
	} catch (const XMLException& toCatch) {
		XERCES_STD_QUALIFIER cerr << "Error during initialization! :\n"
			<< StrX(toCatch.getMessage()) << XERCES_STD_QUALIFIER endl;
		return 1;
	}
 
	xmlFile = "../../../../../samples/data/personal-schema.xml";
	int errorCount = 0;
 
	//
	//  Create a SAX parser object. Then, according to what we were told on
	//  the command line, set it to validate or not.
	//
	SAXParser* parser = new SAXParser;
	parser->setValidationScheme(valScheme);
	parser->setDoNamespaces(doNamespaces);
	parser->setDoSchema(doSchema);
	parser->setHandleMultipleImports (true);
	parser->setValidationSchemaFullChecking(schemaFullChecking);
 
	//
	//  Create the handler object and install it as the document and error
	//  handler for the parser-> Then parse the file and catch any exceptions
	//  that propogate out
	//
	int errorCode = 0;
	try {
		//SAXPrintHandlers handler(encodingName, unRepFlags);
		//parser->setDocumentHandler(&handler);
		//parser->setErrorHandler(&handler);
		parser->parse(xmlFile);
		errorCount = parser->getErrorCount();
	} catch (const OutOfMemoryException&) {
		XERCES_STD_QUALIFIER cerr << "OutOfMemoryException" << XERCES_STD_QUALIFIER endl;
		errorCode = 5;
	} catch (const XMLException& toCatch) {
		XERCES_STD_QUALIFIER cerr << "\nAn error occurred\n  Error: "
			<< StrX(toCatch.getMessage())
			<< "\n" << XERCES_STD_QUALIFIER endl;
		errorCode = 4;
	}
 
	if(errorCode) {
		XMLPlatformUtils::Terminate();
		return errorCode;
	}
 
	//
	//  Delete the parser itself.  Must be done prior to calling Terminate, below.
	//
	delete parser;
 
	// And call the termination method
	XMLPlatformUtils::Terminate();
 
	if (errorCount > 0)
		return 4;
	else
		return 0;
 
	return 0;
}
 
int main(int argc, char* argv[])
{
	CreateDOMDocument();
 
	SAXPrint();
 
	cout<<"ok!"<<endl;
 
	return 0;
}
