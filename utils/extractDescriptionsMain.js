//$Id: extractDescriptionsMain.js,v 1.2 2002/04/03 07:32:13 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep 
//  Purpose:  JScript to create a xxx_descriptions.xml file from a xxx.xml file
//	where xxx= arm or mim
//      cscript extractDescriptionsMain.js "e:\My Documents\projects\nist_module_repo\stepmod\data\modules\work_order\arm.xml" foo.xml 


// If 1 then output user messages
var outputUsermessage = 1;


function debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function userMessage(msg){
    if (outputUsermessage == 1)
	WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    objShell.Popup(msg);
}



function checkFile(f) {
    var retVal = true;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (!fso.FileExists(f)) {
	var msg = f+"\ndoes no exist.";
	ErrorMessage(msg);
	retVal = false;
    }
    return(retVal);
}

function extractDescription(exprXmlFile, descXmlFile) {
    var retVal = 0;
    if (checkFile(exprXmlFile) ) {
	userMessage("Reading descriptions from:\n   " + exprXmlFile);
	userMessage("Storing descriptions in:\n   " + descXmlFile); 

	var source = new ActiveXObject("Msxml2.DOMDocument.3.0");
	source.async = false;
	source.validateOnParse = false;
	source.load(exprXmlFile);
	
	var xsl = "../xsl/utils/extract_descriptions.xsl";
	var stylesheet = new ActiveXObject("Msxml2.DOMDocument.3.0");
	stylesheet.async = false;
	stylesheet.load(xsl);
	
	var result = new ActiveXObject("Msxml2.DOMDocument");
	result.async = false;
	//result.validateOnParse = true;
 
	// Parse results into a result DOM Document.
	var descNode = source.transformNode(stylesheet); 
	descNode.preserveWhiteSpace = true;

	var replace = true; var unicode = false; //output file properties
	var fso = new ActiveXObject("Scripting.FileSystemObject");   
	var descXml = fso.CreateTextFile( descXmlFile, replace, unicode );
	descXml.WriteLine("<?xml version=\"1.0\"?>"); 
	descXml.write( descNode );

    }
}



function testArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript extractDescriptionsMain.js <Express XML> <Description XML>\n";
    if ( cArgs.length != 2 ) {
	ErrorMessage(msg);
	return(0);
    } else {
	return(1);
    }
}


function Main() {
    if (testArgs()==1) {
	var cArgs = WScript.Arguments;
	var expXmlFile = cArgs(0);
	var descXmlFile = cArgs(1);
	extractDescription(expXmlFile, descXmlFile);
    }
}

//Main();
