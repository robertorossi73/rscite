        ��  ��                  	  8   �� H T M L _ R E S O U R C E       0	        <!--TOOLBAR_START--><!--TOOLBAR_EXEMPT--><!--TOOLBAR_END-->
<HTML id=dlgAbout STYLE="width: 25.9em; height: 22em">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--Attiva stili 3d per controlli-->
<meta http-equiv="MSThemeCompatible" content="yes" />

<HEAD>
	<TITLE>Sample HTML Dialog</TITLE>
</HEAD>

<SCRIPT language="JavaScript">
function loadBody()
	{
	//get the arguments
	var arrArgs = new Array();
    arrArgs = window.dialogArguments.split(";");

	//clear the list
	ArgumentList.options.length = 0;

	//add the arguments to the list
	var index;
	index = 0;
	while(index < arrArgs.length)
		{
		var tempOption = new Option(arrArgs[index]);
		ArgumentList.options[ArgumentList.options.length] = tempOption;
		index++;
		}

	//set the first argument to be selected
	ArgumentList.options[0].selected = true;

	//set the default return value
	window.returnValue = 0;
	}

function okButtonClick()
	{
	//this return value means that the OK button was clicked
    window.returnValue = ArgumentList.options[ArgumentList.selectedIndex].text;
	
	//close the dialog
	window.close();
	}

function cancelButtonClick()
	{
	//this return value means that the Cancel button was clicked
    window.returnValue = 0;
	
	//close the dialog
	window.close();
	}
</SCRIPT>

<BODY onload="loadBody()">

	<FONT SIZE="5">Select the argument to be passed back to the calling application.</FONT>

	<P><SELECT NAME="ArgumentList"></SELECT>    

	<P><INPUT type=BUTTON value="OK" id="okButton" onClick="okButtonClick()">

	&nbsp;&nbsp;

	<INPUT type=BUTTON value="Cancel" id="cancelButton" class=button onClick="cancelButtonClick()">

<P><HR><font color="black" face="ms sans serif" size="1">&copy;<a href="http://msdn.microsoft.com/isapi/gomscom.asp?TARGET=/misc/cpyright.htm" target="_top"> 2000 Microsoft Corporation.  All rights reserved.  Terms of use.</a></font>


<script type="text/javascript">

function detectspecialkeys(e){
var evtobj=window.event? event : e
  if (evtobj.keyCode == 27)
  {
    cancelButtonClick();
    //alert("you pressed 'Esc' keys")
  }
  
  if (evtobj.keyCode == 13)
  {
  //alert("you pressed 'Enter' keys");
  okButtonClick();
  }
}

document.onkeypress=detectspecialkeys

</script>

</body>
</html>
 