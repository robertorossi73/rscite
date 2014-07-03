#include <objbase.h>

/*
 * UnicodeToAnsi converts the Unicode string pszW to an ANSI string
 * and returns the ANSI string through ppszA. Space for the
 * the converted string is allocated by UnicodeToAnsi.
 */ 

HRESULT UnicodeToAnsi(LPCOLESTR pszW, char *buffer, int maxLen);