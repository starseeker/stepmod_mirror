//$Id: checkModuleMain.js,v 1.7 2003/10/09 09:47:18 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//  Purpose:
//    JScript to to test that all the modules present in repository_index 
//	exist.     



// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var stepmodHome = '..';

// If 1 then output user messages
var outputUsermessage = 1;

// A string that collects up all the user messages
var userMsgStr = "";


// A string that collects up all the error messages
var errorMsgStr = "";

// A count of all the errors
// set in testModule and incremented in errorMessage;
var errorCount = 0;

// If 1 then popup error message
var popUpErrormessage = 0;

var ForReading = 1, ForWriting = 2, ForAppending = 8;
var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;





var moduleSysFiles = new Array("main.xml", "abstract.xml", "cover.xml", "contents.xml", 
			      "introduction.xml", "foreword.xml", 
			      "1_scope.xml", "2_refs.xml", "3_defs.xml", "4_info_reqs.xml", 
			      "5_main.xml", "5_mim.xml", "5_mapping.xml", 
			      "a_short_names.xml", "b_obj_reg.xml", "c_arm_expg.xml", 
			      "d_mim_expg.xml", 
			      "e_exp.xml", 
			      "e_exp_mim.xml", "e_exp_mim_lf.xml", 
			      "e_exp_arm.xml", "e_exp_arm_lf.xml", 
			      "f_guide.xml", 
			      "biblio.xml");

var moduleNavFiles = new Array("arm_descriptions.xml",
			       "arm_long_form.xml",
			       "developer.xml",
			       "issues_dvlp.xml",
			       "mapping_view.xml",
			       "mapping_view_with_test.xml",
			       "mim_descriptions.xml",
			       "select_view.xml",
			       "summary.xml");

var moduleFiles = new Array("module.xml",
			    "arm.xml",
			    "mim.xml",
			    "arm.exp",
			    "mim.exp");



function testArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript checkModuleMain.js <module name>\n";
    if (cArgs.length != 1) {
	errorMessage(msg);
	return(0);
    } else {
	return(1);
    }
}

//------------------------------------------------------------
function userMessage(msg){
    userMsgStr += msg;
    if (outputUsermessage == 1)
	WScript.Echo(msg);  
    errorMsgStr += msg+"\n"; 
}


function errorMessage(msg){
    errorCount = errorCount+1;
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    if (popUpErrormessage == 1)
	objShell.Popup(msg);  
    errorMsgStr += msg+"\n";  
}


function checkXMLParse(doc) {
    if (doc.parseError.errorCode !=0) {
	var strError = new String;	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var file = doc.parseError.url.replace("file:///","");
	if (!fso.FileExists(file)) {
	    strError='Error: File:'+doc.parseError.url+' does not exist\n';
	}

	strError = strError+'Error: Invalid XML file!\n'
	    + '  File URL: ' + doc.parseError.url + '\n'
	    + '  Line No: ' + doc.parseError.line + '\n'
	    + '  Character: ' + doc.parseError.linepos + '\n'
	    + '  File Position: ' + doc.parseError.filepos + '\n'
	    + '  Source Text: ' + doc.parseError.srcText + '\n'
	    + '  Error Code: ' + doc.parseError.errorCode + '\n'
	    + '  Description: ' + doc.parseError.reason + '\n';
	errorMessage(strError);
    }
    return (doc.parseError.errorCode == 0 );
}

function checkXML(xmlFile) {
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(xmlFile);
    checkXMLParse(xml);
}


function NameModule(module) {

    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    var modName = module.replace(/(^\s*)|(\s*$)/g, "");

    // name must all be lower case
     modName = modName.toLowerCase();
    // no whitespace replace with  _
    re = / /g;
    modName = modName.replace(re, "_");
    
    // no - replace with  _
    re = /-/g;
    modName = modName.replace(re, "_");

    re = /__*/g;
    modName = modName.replace(re, "_");
    return(modName);
} 

function normalizeSpace(str) {
    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    var strN = str.replace(/(^\s*)|(\s*$)/g, "");
    // no whitespace replace with  _
    re = / /g;
    strN = strN.replace(re, "_");
    return(strN);
}

function isoNameModule(module) {
    var modName = NameModule(module);
    re = /_/g;
    modName = modName.replace(re, " ");
    var char1 = modName.substr(0,1);
    var char2 = modName.substr(1,1);
    var char3 = modName.substr(2,1);
    char1 = char1.toUpperCase();

    if (char1=="A" && char2=="p" && char3=="2") {
	modName = "AP"+ modName.substr(2,modName.length);
    } else {
	modName = char1+modName.substr(1,modName.length);
    }
    return(modName);
}


function getDate(dateStr) {
    var dateStart = dateStr.indexOf("/") - 4;
    var dateStr1 = dateStr.substr(dateStart,20);
    return(dateStr1);
}

// return True if date1 is earlier than date2
function compareDates(date1, date2) {
    return(Date.parse(date1) <  Date.parse(date2));
}


function getExpXml(moduleName,armmim) {
    var xmlFile = "../data/modules/"+moduleName+"/"+armmim+".xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    var rcs_date = '0';
    xml.load(xmlFile);
    if (checkXMLParse(xml)) {
	var expr = '/express';	
	var expNodes = xml.selectNodes(expr);
	var members = expNodes.length;
	for (var i = 0; i < members; i++) {	
	    var node = expNodes(i);
	    rcs_date = node.attributes.getNamedItem("rcs.date").nodeValue;
	}
    } 
    return(rcs_date);
}

function getExpId(moduleName,armmim) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var expFileName = "../data/modules/"+moduleName+"/"+armmim+".exp";
    if (fso.FileExists(expFileName)) {
	var expF = fso.GetFile(expFileName);
	var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);
	while (!expTs.AtEndOfStream)
	    {
		var l = expTs.ReadLine();
		// find (* then read the next three lines
		var reg = /\(\*/;
		if (l.match(reg)) {
		    
		    var l1 = expTs.ReadLine(); //ID
		    var l2 = expTs.ReadLine(); // Number
		    var l3 = expTs.ReadLine(); // *) or Supersedes
		    reg = /\*\)/;
		    if (l3.match(reg)) {
			return(normalizeSpace(l2));
		    } else {
			return(normalizeSpace(l2)+normalizeSpace(l3));
		    }
		}
	    }
    } else {
	errorMessage(expFileName+" does not exist");
	return("");
    }
}

function getExpSchema(moduleName,armmim) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var expFileName = "../data/modules/"+moduleName+"/"+armmim+".exp";
    if (fso.FileExists(expFileName)) {
	var expF = fso.GetFile(expFileName);
	var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);
	while (!expTs.AtEndOfStream)
	    {
		var l = expTs.ReadLine();
		var reg = /SCHEMA /;
		if (l.match(reg)) {
		    var schemaName = normalizeSpace(l.replace(reg,''));
		    reg = /;/;
		    schemaName = schemaName.replace(reg,'');
		    return(schemaName);
		}
	    }
    } else {
	errorMessage(expFileName+" does not exist");
	return("");
    }
}


// Check that all the sys, nav and dvlp folders are present
function checkModuleFldr(moduleName, fldrName, fileArray) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var modFldr = "../data/modules/"+moduleName+"/"+fldrName;
    
    if (!fso.FolderExists(modFldr)) {
	errorMessage("Critical Error: "+modFldr + " not found");
    }
    
    for (var i=0; i<fileArray.length; i++) {
	var fileName = fileArray[i];
	var file = modFldr+"/"+fileName;
	if (!fso.FileExists(file))
	    errorMessage("Critical Error: "+file + " not found");
    }
}


// Check that every ExpressG file mentioned in module.xml is present
function checkExpressGFileInModule(moduleName,fileName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject"); 
    var modDir = "../data/modules/"+moduleName;  
    var xmlFile = modDir+"/"+fileName;
    //userMessage("Checking "+ moduleName + " " + fileName + " " + xmlFile);
    if (!fso.FileExists(xmlFile)) {
	errorMessage("Critical Error: "+fileName + " specified in "+moduleName+"/module.xml but not found");
    }
    var gifFile = xmlFile.replace('.xml','.gif');
    if (!fso.FileExists(gifFile)) {
	fileName = fileName.replace('.xml','.gif');
	errorMessage("Critical Error: "+fileName + " specified in "+moduleName+"/module.xml but not found");
    }
}

// Check that every expressG file in the module folder is referenced
function checkExpressGFileInModFldr(moduleName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject"); 
    var modDir = "../data/modules/"+moduleName;  
    var modFldr = fso.GetFolder(modDir);
    var fc = new Enumerator(modFldr.files);

    var xmlFile = "../data/modules/"+moduleName+"/module.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(xmlFile);
    if (checkXMLParse(xml)) {
	for (; !fc.atEnd(); fc.moveNext()) {
	    var f = fc.item();
	    var fname = f.Name;
	    var reg = /^armexpg.*xml$/;
	    if (fname.match(reg)) {
		var expr = '/module/arm/express-g/imgfile[@file=\''+fname+'\']';
		var expNodes = xml.selectNodes(expr);
		var members = expNodes.length;
		if (members == 0)
		    errorMessage("Error: "+fname+" in folder: "+modDir+" but not listed in "+modDir+"/module.xml");
	    }
	    reg = /^mimexpg.*xml$/;
	    if (fname.match(reg)) {
		var expr = '/module/mim/express-g/imgfile[@file=\''+fname+'\']';
		var expNodes = xml.selectNodes(expr);
		var members = expNodes.length;
		if (members == 0)
		    errorMessage("Error: "+fname+" in folder: "+modDir+" but not listed in "+modDir+"/module.xml");
	    }
	}
    }
}

function checkModule(moduleName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    var xmlFile = "../data/modules/"+moduleName+"/module.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    var rcs_date = '0';
    xml.load(xmlFile);
    if (checkXMLParse(xml)) {
	var expr = '/module/arm/express-g/imgfile';	
	var expNodes = xml.selectNodes(expr);
	var members = expNodes.length;
	for (var i = 0; i < members; i++) {	
	    var node = expNodes(i);
	    var fileName = node.attributes.getNamedItem("file").nodeValue;
	    //userMessage("Checking "+ moduleName + " " + fileName);
	    checkExpressGFileInModule(moduleName,fileName);
	}
	expr = '/module/mim/express-g/imgfile';	
	var expNodes = xml.selectNodes(expr);
	var members = expNodes.length;
	for (var i = 0; i < members; i++) {	
	    var node = expNodes(i);
	    var fileName = node.attributes.getNamedItem("file").nodeValue;
	    //userMessage("Checking "+ moduleName + " " + fileName);
	    checkExpressGFileInModule(moduleName,fileName);
	}
	checkExpressGFileInModFldr(moduleName);
    }
}

// Check that the express file is valid XML
// Check that the description file is present
function checkExpress(moduleName,expressXml) {
    var xmlFile = "../data/modules/"+moduleName+"/"+expressXml;
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(xmlFile);
    if (checkXMLParse(xml)) {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var expr = '/express';
	var node = xml.selectSingleNode(expr);
	var descFileAttr = node.attributes.getNamedItem("description.file")
	if (descFileAttr) {
	    var descriptionFile = descFileAttr.nodeValue;
	    descriptionFile = "../data/modules/"+moduleName+"/"+descriptionFile;
	    if (!fso.FileExists(descriptionFile)) {
		errorMessage("Critical Error: "+descriptionFile+" identified in "+xmlFile+" but not found");
	    } else 
	    // having found a reference express description file, check that it is valid XML
	    checkXML(xmlFile);
	} else {
	    // no express description file identitied so check that if one present.
	    
	    var descriptionFile = "../data/modules/"+moduleName+"/"+expressXml.replace('.xml','_descriptions.xml');
	    if (fso.FileExists(descriptionFile)) {
		errorMessage("Warning: No EXPRESS description file identified in "+xmlFile+" but found "+descriptionFile);
	    }
	}
    }
}


// check that the arm.exp and mim.exp file have the same WG Numbers as 
// arm.xml and mim.xml
// NOT FINISHED
function checkExpressFile(moduleName,armmim) {
    var xmlFile = "../data/modules/"+moduleName+"/module.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(xmlFile);
    if (checkXMLParse(xml)) {
	var expr = '/module';	
	var moduleNodes = xml.selectNodes(expr);
	var members = moduleNodes.length;
	var moduleNode = moduleNodes(0);
	var part = moduleNode.attributes.getNamedItem("part").nodeValue;
	var name = moduleNode.attributes.getNamedItem("name").nodeValue;
	var status = moduleNode.attributes.getNamedItem("status").nodeValue;
	name = isoNameModule(name);
	var sc4wg = moduleNode.attributes.getNamedItem("sc4.working_group");
	if (sc4wg) {
	    sc4wg = sc4wg.nodeValue;
	} else {
	    sc4wg = 12;
	}

	var wgnAttr = "wg.number."+armmim;
	var wgn = moduleNode.attributes.getNamedItem(wgnAttr);
	if (wgn) {
	    wgn = wgn.nodeValue;
	} else {
	    wgn = "";
	}
	var header = "ISO TC184/SC4/WG"+sc4wg+" N"+wgn+" - ISO/"+status+" 10303-"+part+" "+name+" - EXPRESS "+armmim.toUpperCase();
	var line1 = normalizeSpace(header);
	var supersedes = "";

	var wgn_supersedes = moduleNode.attributes.getNamedItem(wgnAttr+".supersedes");
	if (wgn_supersedes) {
	    wgn_supersedes = wgn_supersedes.nodeValue;
	    supersedes = "Supersedes ISO TC184/SC4/WG"+sc4wg+" N"+wgn_supersedes;
	    line1 = line1 + normalizeSpace(supersedes);
	}
	var line2 = normalizeSpace(getExpId(moduleName,armmim));
	
	if (line1 != line2) {
	    var id = "$Id: checkModuleMain.js,v 1.7 2003/10/09 09:47:18 robbod Exp $";
	    var msg = "Error - Header of "+armmim+".exp is incorrect. It should be\n(*";
	    if (wgn_supersedes) {
		msg = msg+"\n "+id+"\n "+header+"\n "+supersedes+"\n*)\n";
	    } else {
		msg = msg+"\n "+id+"\n "+header+"\n*)\n";
	    }
	    errorMessage(msg);
	    //userMessage(line1);
	    //userMessage(line2);
	}

	var schema = getExpSchema(moduleName,armmim);
	schema = schema.toLowerCase();
	var module_exp = moduleName+"_"+armmim;
	module_exp = module_exp.toLowerCase();
	if (schema != module_exp) {
	    var msg = "Error - The schema (" + schema + ") in the file (" +moduleName+"/"+armmim+ ".exp) does not correspond to the module.";
	    errorMessage(msg);
	}
    }
}

function testModule(moduleName) {
    errorCount = 0;
    userMessage("____________________________________________________________\nChecking module: "+moduleName+"\n");
    checkModuleFldr(moduleName,'.',moduleFiles);
    checkModuleFldr(moduleName,'sys',moduleSysFiles);
    checkModuleFldr(moduleName,'nav',moduleNavFiles);
    checkModule(moduleName);
    checkExpress(moduleName,"arm.xml");
    checkExpress(moduleName,"mim.xml");
    checkExpressFile(moduleName,"arm");
    checkExpressFile(moduleName,"mim");

    if (errorCount > 0) {
	userMessage("There are "+errorCount+" errors in the module files\n");
    } else {
	userMessage("Module OK\n");
    }
    return(errorMsgStr);
}


// Test all the modules in the repository
function testRepository() {
    var repoIndexXml = "../repository_index.xml";
    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = true;
    objXML.load(repoIndexXml);
    if (checkXMLParse(objXML)) {
	var expr = "/repository_index/modules/module";
	var moduleNodes = objXML.selectNodes(expr);
	var members = moduleNodes.length;
	for (var i = 0; i < members; i++) {	
	    var node = moduleNodes(i);
	    var moduleName = node.attributes.getNamedItem("name").nodeValue;
	    testModule(moduleName);
	}
    }
}

function MainWindowOld(module) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var modName = NameModule(module);
    var dateArmExp = getDate(getExpId(module,'arm'));
    userMessage(dateArmExp);

    var dateArmXml = getDate(getExpXml(module,'arm'));
    userMessage(dateArmXml);

    if (compareDates(dateArmExp,dateArmXml)) {
	errorMessage("arm.exp (date: "+dateArmExp+") has not been created from arm.xml (date:"+dateArmXml+")");
    }
}



function Main() {
    if (testArgs()==1) {
	var cArgs = WScript.Arguments;
	var moduleName = cArgs(0);
	var errStr = testModule(moduleName);
	if (errorCount > 0) {
	    errorMessage("There are "+errorCount+" errors in the module files");
	} 	    
    }
}

//Main();

//MainWindow("ap239_management_resource_information");
//testModule("condition");
//testModule("ap239_product_definition_information");
//checkExpressFile("condition", "arm");
//checkExpressFile("ap239_product_definition_information", "arm");
//checkExpressFile("ap239_document_management","arm");
//testRepository();


