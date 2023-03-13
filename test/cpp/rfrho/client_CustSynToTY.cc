//----------------------------------------------------------------
//
//      FILE        : client_CustSynToTY.cc
//
//      DATE        : Jan 05, 2022
//
//      PURPOSE     : Sync up Customer infomation to TY system
//
//      AUTHOR      :
//
//---------------------------------------------------------------
/*
SId; $
*/

#include "client/stkpublicapi.h"
#include "dbmappingapi/su_dbmapping.h"
#include "sutools/su_cstring_slist.h"
#include "xml/xml_entity_utils.h"
#include <string>
#include <fstream>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stringhelper.h>
#include <boost/locale/encoding.hpp>

using namespace std;

int LogMessage(const string& message, const string& cust,const string& prefix, const string& action)

