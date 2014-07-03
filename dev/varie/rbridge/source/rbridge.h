
#ifndef RBRIDGE_HEADER_DEF
#define BRIDGE_HEADER_DEF

// modelli per funzioni eserne utilizzabili
// il primo parametro è il valore di ritorno
typedef void (__cdecl *EXTERNALFX0)(void *);
typedef void (__cdecl *EXTERNALFX1)(void *, void *);
typedef void (__cdecl *EXTERNALFX2)(void *, void *, void *);
typedef void (__cdecl *EXTERNALFX3)(void *, void *, void *, void *);
typedef void (__cdecl *EXTERNALFX4)(void *, void *, void *, void *, void *);
typedef void (__cdecl *EXTERNALFX5)(void *, void *, void *, void *, void *,
									  void *);
typedef void (__cdecl *EXTERNALFX6)(void *, void *, void *, void *, void *,
									  void *, void *);
typedef void (__cdecl *EXTERNALFX7)(void *, void *, void *, void *, void *,
									  void *, void *, void *);
typedef void (__cdecl *EXTERNALFX8)(void *, void *, void *, void *, void *,
									  void *, void *, void *, void *);
typedef void (__cdecl *EXTERNALFX9)(void *, void *, void *, void *, void *,
									  void *, void *, void *, void *, void *);
typedef void (__cdecl *EXTERNALFX10)(void *,
									  void *, void *, void *, void *, void *,
									  void *, void *, void *, void *, void *);

//numero massimo parametri passabili a funzione esterna richiamata
#define BRIDGE_MAX_PAR 10

//tipi gestiti
#define BRIDGE_TYPE_NULL 0
#define BRIDGE_TYPE_STRING 1
#define BRIDGE_TYPE_INT 2
#define BRIDGE_TYPE_REAL 3


#endif