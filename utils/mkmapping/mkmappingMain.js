//$Id: mkmappingMain.js,v 1.1 2002/08/22 15:06:47 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep 
//  Purpose:  JScript to copy all the express files from the repository to
//      Generate the XML for a module from GraphicalExpress pblished XML
//      Convert the HTML files containing a single image map that have been 
//      exported from GraphicalExpress to XML files
//      Copy the GIFs
//      Extract the Schema for the module
//      e.g.
//      cscript mkmappingMain.js activity


// If 1 then output user messages
var outputUsermessage = 1;


var stepmodHome = "../../";


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



function checkModule(module) {
    var retVal = true;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    armFile = stepmodHome +'data/modules/'+module+'/arm.xml';

    if (!fso.FileExists(armFile)) {
	var msg = armFile+"\ndoes no exist.";
	ErrorMessage(msg);
	retVal = false;
    }
    return(retVal);
}

function mkMapping(module) {
    var retVal = false;
    if (checkModule(module) ) {
	var armFile = stepmodHome+'data/modules/'+module+'/arm.xml';
	var mappingFile =  stepmodHome+'data/modules/'+module+'/dvlp/mapping.xml';
	userMessage("Reading ARM:\n   " + armFile);
	userMessage("Storing mapping in:\n   " + mappingFile); 

	var armXmlDom = new ActiveXObject("Msxml2.DOMDocument.3.0");
	armXmlDom.async = false;
	armXmlDom.validateOnParse = false;
	armXmlDom.load(armFile);
	armXmlDom.preserveWhiteSpace = true;

	var xslFile = "./mkmapping.xsl";
	var xslXmlDom = new ActiveXObject("Msxml2.DOMDocument.3.0");
	xslXmlDom.async = false;
	xslXmlDom.validateOnParse = false;
	xslXmlDom.load(xslFile);

	var result = new ActiveXObject("Msxml2.DOMDocument");
	result.async = false;
	//result.validateOnParse = true;

 
	// Parse results into a result DOM Document.
	var mapNode = armXmlDom.transformNode(xslXmlDom); 
	mapNode.preserveWhiteSpace = true;

	var replace = true; var unicode = false; //output file properties
	var fso = new ActiveXObject("Scripting.FileSystemObject");   
	var mappingXml = fso.CreateTextFile( mappingFile, replace, unicode );
	mappingXml.WriteLine("<?xml version=\"1.0\"?>"); 
	mappingXml.write( mapNode );
	retVal = mappingFile;
    }
    return(retVal);
}



function testArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript makmappingMain.js <module>\n";
    if ( cArgs.length != 1 ) {
	ErrorMessage(msg);
	return(0);
    } else {
	return(1);
    }
}


function Main() {
    if (testArgs()==1) {
	var cArgs = WScript.Arguments;
	var module = cArgs(0);
	mkMapping(module);
    }
}

//Main();
