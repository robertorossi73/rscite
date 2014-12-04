//definizione nome modulo LUA
#define LS_NAMESPACE    "rwfx"

//Ritorna l'HWND dell'DirectorExtension di Scite
HWND GetHWNDDirectorExtension (void);

//scrive un testo nel file indicato
int writeStrinToTmp (const char*, const char *);

//visualizza messaggio di errore
void showErrorMsg ( const char*  );

//definizione per funzione esterna
typedef long (__cdecl *EXTERNALFX)(char *, const long,
	const char*, const char*, const char*, const char*, const char*,
	const long, const long, const long, const long,
	const double, const double, const double, const double);