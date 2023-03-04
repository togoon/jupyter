#include "stdafx.h"
 
// reference any additional headers you need in STDAFX.H
// and not in this file
#ifdef _DEBUG
	#pragma comment(lib, "../../../../../Build/Win32/VC10/Static Debug/xerces-c_static_3D.lib") 
#else
	#pragma comment(lib, "../../../../../Build/Win32/VC10/Static Release/xerces-c_static_3.lib") 
#endif
