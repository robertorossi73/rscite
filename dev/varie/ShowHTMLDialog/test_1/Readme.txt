=============================================
Reusing Browser Technology -- ShowHTMLDialog 
=============================================
Last Updated: November 10, 1999.


SUMMARY
========
HTML Dialog is a simple example that demonstrates how to use the 
ShowHTMLDialog function. This example shows how to use the function 
and pass parameters to and receive parameters from an HTML dialog box. 
The HTML source also shows how to access the parameters that are passed 
into the dialog box and set the return parameters from the dialog box 
using script. The HTML source for the dialog box is contained as a resource 
in the application itself and is accessed using the res: protocol.


DETAILS
========
One of the most important ways for an application to control Internet Explorer 
is by monitoring what it is doing. For this reason, Internet Explorer exposes 
an event interface so applications can monitor its activity and perform certain 
actions. For example, by intercepting the BeforeNavigate2 event, an application 
can examine the requested URL and prevent the browser from navigating there. Thus, 
this sample application shows you how to implement event handling in your MFC 
application in order to receive events from Internet Explorer. By hosting an 
instance of the WebBrowser Control, the sample application demonstrates how 
applications wishing to directly integrate Web browsing capabilities can receive 
and respond to the Internet Explorer events that are fired as a result of actions 
taken in the embedded WebBrowser Control. In addition, the sample application also 
shows how to start (and control) a new, separate instance of Internet Explorer and 
receive events from it. 


BROWSER/PLATFORM COMPATIBILITY
===============================
The showHTMLDialog function is supported in both Internet Explorer 4 and 
Internet Explorer 5. The HTML Dialog sample can be compiled on Win32 platforms.
	

SOURCE FILES
=============
resource.h
HTMLDlg.cpp
makefile
HTMLDlg.htm
HTMLDlg.dsp
HTMLDlg.dsw
HTMLDlg.rc


SEE ALSO
=========
For more information on Reusing Browser Technology go to:
http://msdn.microsoft.com/workshop/browser/default.asp


==================================
© Microsoft Corporation 1999-2000
