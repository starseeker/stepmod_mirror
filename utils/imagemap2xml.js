//$Id: express2xml.js,v 1.4 2001/12/14 11:56:28 robbod Exp $

// Convert an HTML file containing a single image map into
// an XML file

// The string added to the begining of the xml ouput to indent the output
var indent = "";


// ------------------------------------------------------------
// Call Main program
// -----------------------------------------------------------
Main();


function debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function userMessage(msg){
    WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    WScript.Echo(msg);
    objShell.Popup(msg);
}


function xmlXMLhdr(xmlTs) {
    xmlTs.Writeline("<?xml version=\"1.0\"?>");
    xmlTs.Writeline("<!-- $Id: imagemap2xml.js,v 1.4 2001/12/14 11:56:28 robbod Exp $ -->");
    xmlTs.Writeline("<?xml-stylesheet type=\"text\/xsl\" href=\"..\/..\/..\/xsl\/imgfile.xsl\"?>");
    xmlTs.Writeline("<!DOCTYPE imgfile.content SYSTEM \"../../../dtd/text.ent\">");
}

function xmlOpenElement(xmlElement, xmlTs) {
    var txt = indent+xmlElement;
    xmlTs.Write(txt);
    indent = indent+"  ";
}

function xmlCloseElement(xmlElement, xmlTs) {
    if (indent.length >= 2) {
	indent = indent.substr(2);
    } else {
	indent = indent+"-------";
    }
    var txt = indent+xmlElement;
    xmlTs.WriteLine(txt);
}


// Output an indented attribute.
function xmlAttr(name, value, xmlTs) {
    var txt = indent+name+"=\""+value+"\"";
    xmlTs.WriteLine();
    xmlTs.Write(txt);
}

function xmlCloseAttr(xmlTs) {
    xmlTs.WriteLine("/>");    
    if (indent.length >= 2) {
	indent = indent.substr(2);
    } else {
	indent = indent+"-------";
    }
}


function getAttribute(attr,element) {
    element = element.replace(/\s*=\s*/g,"=");
    var reg = new RegExp("\\b"+attr+"=","i");
    var pos = element.search(reg);
    if (pos != -1) {
	element = element.substr(pos+attr.length+2);
	element = element.replace(/\".*/g,"");
    } else {
	element="";
    }
    return(element);
}

function elementName(element) {
    var name = "";
    var reg = /<\/.*\b/;
    name = element.match(reg);
    if (name) {
	name = null;
    } else {
	reg = /<.*\b/;
	name = element.match(reg);
	name = name.toString();
	name = name.substr(1);
	name = name.replace(/ .*/,"");
	name = name.toLowerCase();
    }
    return(name);
}

function readElement(tStream) {
    var element, inElement=0;
    while (!tStream.AtEndOfStream) {
	var c = tStream.Read(1);
	switch (c) {
	case "<" :
	    inElement=1;
	    element = element+c;
	    break;
	case ">" :
	    return(element+c);
	    break;
	default:
	    if (inElement==1)
		element = element+c;
	}
    }
    return(element);
}


function Output2xml(htmFile, xmlFile, module, title) {
    var ForReading = 1, ForWriting = 2, TristateUseDefault = -2;   
    userMessage("Reading HTML: " + htmFile);
    userMessage("Writing XML: " + xmlFile);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var htmF = fso.GetFile(htmFile);
    var htmTs = htmF.OpenAsTextStream(ForReading, TristateUseDefault);

    fso.CreateTextFile(xmlFile,true);
    var xmlF = fso.GetFile(xmlFile);
    var xmlTs = xmlF.OpenAsTextStream(ForWriting, TristateUseDefault);
    xmlXMLhdr(xmlTs);

    xmlOpenElement("<imgfile.content", xmlTs);
    xmlAttr("module", module, xmlTs);
    xmlAttr("title", title, xmlTs);
    xmlTs.WriteLine(">");


    while (!htmTs.AtEndOfStream) {
	var element = readElement(htmTs);
	var eName;
	if (element) {
	    eName = elementName(element);
	}
	switch (eName) {
	case "img" :
	    var imgfile = getAttribute("SRC",element);
	    xmlOpenElement("<img", xmlTs);
	    xmlAttr("src",imgfile,xmlTs);
	    xmlTs.WriteLine(">");
	    break;
	case "area" :
	    xmlOpenElement("<img.area", xmlTs);
	    var shape = getAttribute("shape",element);
	    var coords = getAttribute("coords",element);
	    var href = getAttribute("href",element);
	    xmlAttr("shape",shape,xmlTs);
	    xmlAttr("coords",coords,xmlTs);
	    xmlAttr("href",href,xmlTs);
	    xmlCloseAttr(xmlTs);
	    break;
	default:
	    break;
	}
    }
    xmlCloseElement("</img>", xmlTs);
    xmlCloseElement("</imgfile.content>",xmlTs);
    htmTs.Close();    
    xmlTs.Close();

}


function testArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript imagemap2xml.js <module> <imagemap.html> <file.xml> <optional title>\n";
    if ( !((cArgs.length == 3) || (cArgs.length == 4)) ) {
	ErrorMessage(msg);
	return(0);
    } else {
	return(1);
    }
}


// ------------------------------------------------------------
// Main program
// -----------------------------------------------------------
function Main() {
    if (testArgs()==1) {
	var cArgs = WScript.Arguments;
	var module = cArgs(0);
	var htmFile = cArgs(1);
	var xmlFile = cArgs(2);
	var title ="";
	if (cArgs.length == 4) 
	    title = cArgs(3);
	xmlFile='../data/modules/'+module+'/'+xmlFile;
	Output2xml(htmFile, xmlFile, module, title);
    }
}
