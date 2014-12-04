#include <windows.h>

#ifndef _MODRMSGBX_
#define _MODRMSGBX_

  typedef enum rMsgBx {
	  NullButton1, 
      OkButtonLabel, //1
	  CancelButtonLabel, //2
      AbortButtonLabel, //3
	  RetryButtonLabel, //4
	  IgnoreButtonLabel, //5
	  YesButtonLabel, //6
      NoButtonLabel, //7
	  NullButton2,
	  NullButton3,
	  TryAgainButtonLabel, //10
	  ContinueButtonLabel //11	  
   } rMsgBx;

  int rMsgBx_show(HWND, const char [], const char [], UINT); //show messagebox			
  void rMsgBx_setLabel(int, const char []); //set button text
  void rMsgBx_new (void); //initialize dialog
  int rMsgBx_is_customized (void); //check customize button
#endif

