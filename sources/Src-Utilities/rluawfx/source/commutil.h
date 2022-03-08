#include <wchar.h>
#include <sstream>

//definizione nome modulo LUA
#define LS_NAMESPACE    "rwfx"

//Ritorna l'HWND dell'DirectorExtension di Scite
HWND GetHWNDDirectorExtension (void);

//scrive un testo nel file indicato
int writeStrinToTmp(const char*, const char*);
int writeStrinToTmpW(const wchar_t*, const wchar_t*);

//converte un char in wchar_t
const wchar_t* CharToW(const char*);
void DeleteChToW(const wchar_t*); //elimna la stringa convertita da CharToW

//converte un buffer di char codificato utf-8 in wchar_t
std::wstring UTF8CharToWChar(const char*);

//visualizza messaggio di errore
void showErrorMsg ( const char*  );

//definizione per funzione esterna
typedef long (__cdecl *EXTERNALFX)(char *, const long,
	const char*, const char*, const char*, const char*, const char*,
	const long, const long, const long, const long,
	const double, const double, const double, const double);