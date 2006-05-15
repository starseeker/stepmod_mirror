//$Id: ecco2moduleMain.js,v 1.3 2005/06/01 18:41:38 thendrix Exp $
//  Author: Tom Hendrix, Boeing
//  Purpose:  JScript to convert ECCO pseudo part 28 PDTS to XML for repository

// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

// The string added to the begining of the xml output to indent the output
var indent = "";

// If 1 then overwrite the destination directory
var overwrite = -1;

// If 1 then output user messages
var outputUsermessage = -1;


// If you do not run mkmodule from this directory
var stepmodHome = "..\\..\\..";

var sourceFile  =""


// ------------------------------------------------------------
// Call Main program
// -----------------------------------------------------------
//Main();

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

function popupInform(msg,title) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var retVal = objShell.Popup(msg,0,title,64);    
}

function yesOrNo(msg,title) {
    var objShell = WScript.CreateObject("WScript.Shell");
    var retVal = objShell.Popup(msg,0,title,36);
    switch (retVal) {
    case 6: //yes
	retVal="yes";
	break;
    case 7: //no
	retVal="no";
	break;
    }
    return(retVal);
}

function checkXMLParse(doc) {
    if (doc.parseError.errorCode !=0) {
	var strError = new String;
	strError = 'Invalid XML file!\n'
	    + 'File URL: ' + doc.parseError.url + '\n'
	    + 'Line No: ' + doc.parseError.line + '\n'
	    + 'Character: ' + doc.parseError.linepos + '\n'
	    + 'File Position: ' + doc.parseError.filepos + '\n'
	    + 'Source Text: ' + doc.parseError.srcText + '\n'
	    + 'Error Code: ' + doc.parseError.errorCode + '\n'
	    + 'Description: ' + doc.parseError.reason;
	ErrorMessage(strError);
    }
    return (doc.parseError.errorCode == 0 );
}


// ------------------------------------------------------------

function getModulePath(schemaName) {
    var module = getModuleName(schemaName);
    if (module == schemaName){
       var dir = stepmodHome+"\\data\\resources\\"+module;
    }else {
       var dir = stepmodHome+"\\data\\modules\\"+module;
    }

;   popupInform("dir: " +dir);
    userMessage(dir);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(dir)) {
    } else {
      fso.CreateFolder(dir);
    }
    userMessage(dir);
    fldr= fso.GetFolder(dir);
    return(fldr.Path);

}

function getFileExt(f) {
    var fname = f.Name;
    var dotPos = fname.lastIndexOf('.');
    var ftype = fname.substring( dotPos );
    return(ftype);
}

function getFileNameNoExt(f) {
    var fname = f.Name;
    var dotPos = fname.lastIndexOf('.');
    var ftype = fname.substring(0, dotPos );
    return(ftype);
}


function getModuleName(schemaName) {
    var pos = schemaName.lastIndexOf('_arm');
    schemaName = schemaName.toLowerCase();
    var module = schemaName;
    if (pos > 1) {
	module = schemaName.substring(0,pos);
	return(module);
    }
    pos = schemaName.lastIndexOf('_mim');
    if (pos > 1) {
	module = schemaName.substring(0,pos);
	return(module);
    }
    return(module);
}


// Given a schema name, work out if it is the schema for an arm 
// or a mim and return 'arm' or 'mim' accordingly
function getArmMimXml(schemaName) {
    schemaName = schemaName.toLowerCase();
    var module = schemaName;
    var pos = schemaName.lastIndexOf('_arm_lf');
    if (pos > 1) {
	return('arm_lf');
    }
    pos = schemaName.lastIndexOf('_mim_lf');
    if (pos > 1) {
	return('mim_lf');
    }
    pos = schemaName.lastIndexOf('_arm');
    if (pos > 1) {
	return('arm');
    }
    pos = schemaName.lastIndexOf('_mim');
    if (pos > 1) {
	return('mim');
    }
    return(module);
}

function getSchemaNameFromXML(eccoDir) {
    var replace = true; var unicode = false; //output file properties
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var geFldr = fso.GetFolder(eccoDir);
    var modelXmlFile = geFldr.Path.toString()+"\\model.xml";

    // Load in the model.xml file
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(modelXmlFile);
    var schemaName = "";
    if (checkXMLParse(xml)) {

	// Get the schema out of model.xml
	var schemaNodes = xml.selectNodes("/iso_10303_28/express_schema/schema_decl/schema_id");
	var node = schemaNodes(0);
	schemaName = node.childNodes.item(0).nodeValue;
	//userMessage("Schema: "+schemaName);
    } 
    return(schemaName);
}


// ------------------------------------------------------------
// Conversion
// ------------------------------------------------------------


// Copy over the all the image maps and the GIFS
function copyAllImgMaps(eccoDir, dstDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var geFldr = fso.GetFolder(eccoDir);
    var dstFldr = fso.GetFolder(dstDir);
    var fc = new Enumerator(geFldr.files);
    // Iterate though all the graphics.xml files excluding graphics1.xml 
    // which is the schema diagram
    for (; !fc.atEnd(); fc.moveNext()) {
	var f = fc.item();
	var fExt = getFileExt(f);
	var fName = fso.GetFileName(f);

	// Need to make sure only pick up files that are graphics*.xml
	var re = /^graphics/;

	if ( (fExt == '.xml')
	     && (fName.match(re))
	     && (fName != "model.xml") 
	     && (fName !="graphics1.xml") ) {
	    var imgXmlFile = f.Path.toString();
	    // Load in the graphics.xml file
	    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
	    xml.async = false;
	    xml.load(imgXmlFile);

	    // Get the name of the schema and hence the module name
	    var expr = "/imgfile.content";
	    var imgfileNodes = xml.selectNodes(expr);
	    var members = imgfileNodes.length;
	    var schema, module;
	    for (var i = 0; i < members; i++) {
		var node = imgfileNodes(i);
		node = node.attributes.getNamedItem("schema");
		// should not need to check this as ECCO should always output schema
		if (node) {
		    schema = node.nodeValue;
		    module = getModuleName(schema);
		} else {
		    schema = "";
		    module = "";
		}
	    }
	    
	    // Get the gif file that goes with the image map
	    expr = "/imgfile.content/img";
	    var imgNodes = xml.selectNodes(expr);
	    members = imgNodes.length;
	    var gifFile;
	    for (var i = 0; i < members; i++) {	
		var node = imgNodes(i);
		gifFile = node.attributes.getNamedItem("src").nodeValue;
	    }

	    // copy the image to the module directory, renaming it
	    //Only do this if the folder has been created for the schema
	    var schemaPath = dstFldr.Path.toString()+"\\"+schema;
	    if (fso.FolderExists(schemaPath)) {
		var newGifFile = fso.getFileName(gifFile);
		newGifFile = schemaPath+"\\"+newGifFile;
		//userMessage("Copying: "+gifFile+ " == "+newGifFile);
		fso.CopyFile(gifFile,newGifFile);

		var newImgXmlFile = newGifFile.replace('.gif','.xml');
		//userMessage("Copying: "+imgXmlFile+ " == "+newImgXmlFile+"\n");
		fso.CopyFile(imgXmlFile,newImgXmlFile);	 
	    }
	}
    }
    // Rename all the image files
    // convert the graphics XML file  - correcting the href
    renameAllImgMaps(dstDir);
}

// Rename all the image files
// convert the graphics XML file  - correcting the href
function renameAllImgMaps(dstDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");    
    var dstFldr = fso.GetFolder(dstDir);
    var fc = new Enumerator(dstFldr.SubFolders);
    // Iterate though all the schema folders and rename the images
    for (; !fc.atEnd(); fc.moveNext()) {
	var f = fc.item();
	var fName = fso.GetFileName(f);
	var imgArray = new Array();
	var imgCnt = 0;

	// Collect the graphics file names
	var graphicsC = new Enumerator(f.files);
	for (; !graphicsC.atEnd(); graphicsC.moveNext()) {
	    var graphicsF = graphicsC.item();
	    var graphicsFExt = getFileExt(graphicsF);
	    var graphicsFName = fso.GetFileName(graphicsF);
	    var re = /graphics/;
	    if ( (graphicsFExt == '.xml') 		 
		 && (re.test(graphicsFName) ) ) {
		imgArray[imgCnt] = graphicsF.Path;
		imgCnt = imgCnt + 1;
	    }
	}
	// Sort the gif files
	var sortedImgArray = imgArray.sort(sortImgArr);

	// Output a dummy module.xml that details the arm
	var replace = true; var unicode = false; //output file properties
	var moduleXmlFile = f.Path.toString()+"\\module.xml";
	var moduleXml = fso.CreateTextFile( moduleXmlFile, replace, unicode );
	moduleXml.writeLine("<express-g>");
	var expgIndex = 2;

	for (var i=0; i < sortedImgArray.length; i++) {
	    var graphicsXml = sortedImgArray[i];
	    graphicsFName = fso.GetFileName(graphicsXml);
	    graphicsFldr = f;
	    var newF = getArmMimXml(fName)+'expg'+(expgIndex++);
	    var newGraphicsXml = graphicsFldr+'\\'+newF+'.xml';
	    var oldGraphicsGif = graphicsFldr+'\\'+graphicsFName.replace('.xml','.gif');
	    var newGraphicsGif = graphicsFldr+'\\'+newF+'.gif';

	    fso.MoveFile(oldGraphicsGif,newGraphicsGif);

	    // Note fName is the name of the schema
	    convertImgFile(graphicsXml,newGraphicsXml,fName);

	    moduleXml.writeLine("  <imgfile file=\""+newF+".xml"+"\"/>");

	}
	moduleXml.writeLine("</express-g>");
    }
}



// Function used by the sort routine to order the graphics.xml files
// in the image array
function sortImgArr(a,b) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");    

    a = fso.GetFileName(a);
    a = a.replace("graphics","");
    a = a.replace(".xml","");
    a = parseInt(a);

    b = fso.GetFileName(b);
    b = b.replace("graphics","");
    b = b.replace(".xml","");
    b = parseInt(b);

    if (a==b) return(0);
    if (a<b)  return(-1);
    if (a>b)  return(+1);
}

// ECCO exports the HREFS on the image map as: ../model_doc.xml#
// replace these with the HREF for the modules
// newImgFile is passed in as a hack to deal with object proxies.
function convertHref(href,newImgFile) {

    if (href.indexOf('../model_doc.xml#') !=-1) {
	var expressRef = href.replace('../model_doc.xml#','');
	var pos = expressRef.indexOf('.');
	var schema;
	if (pos > 1) 
	    schema = expressRef.substring(0,pos);
	else
	    schema = expressRef;
	var module;
	var armpos = schema.lastIndexOf('_arm');
	var mimpos = schema.lastIndexOf('_mim');
 	var isResource ='false'; //thx added 2004-12-13 
	if (armpos > 1) {
	    module = getModuleName(schema);
	    href = "../"+module+"/sys/4_info_reqs.xml#"+expressRef;
	} else if (mimpos > 1) {
	    module = getModuleName(schema);
	    href = "../"+module+"/sys/5_mim.xml#"+expressRef;
	} else {
	    // must be an Integrated Resource
	    href = "../../resources/"+schema+"/"+schema+".xml#"+expressRef;
	    isResource ='true';
	}
    } else {
	// must be an object proxy
	var fso = new ActiveXObject("Scripting.FileSystemObject"); 
	// newImgFile will be form 
	// E:\My Documents\Models\export\modules\Work_request_arm\armexpg3.xml
	var fName = fso.GetBaseName(newImgFile);
	// get armexpg or mimexpg
	var base = fName.substr(0,7);
	// href ./graphics3.xml
	var count = fso.GetBaseName(href);
	count = href.substr(10);
	href = "./"+base+count;
    }
    return(href);
}


// ECCO exports the HREFS on the image map as: ../model_doc.xml#
// replace these with the HREF for the schema page
// schemaName is the name of the module schema - the schema in focus
function convertHrefSchema(href,schemaName) {
    if (href.indexOf('../model_doc.xml#') !=-1) {
	var expressRef = href.replace('../model_doc.xml#','');
	var pos = expressRef.indexOf('.');
	var schema;
	if (pos > 1) 
	    schema = expressRef.substring(0,pos);
	else
	    schema = expressRef;
	//userMessage("S:"+schema);
	// RBN Need to put a test in here to see if schema = schemaName
	// then decide on what HREF - to schema page or page 2 
	var module;
	var armpos = schema.lastIndexOf('_arm');
	var mimpos = schema.lastIndexOf('_mim');
	if (armpos > 1) {
	    module = getModuleName(schema);
	    if (schema == schemaName) {
		href = "../"+module+"/armexpg2.xml";
	    } else {
		href = "../"+module+"/armexpg1.xml";
	    }
	} else if (mimpos > 1) {
	    module = getModuleName(schema);
	    if (schema == schemaName) {
		href = "../"+module+"/mimexpg2.xml";
	    } else {
		href = "../"+module+"/mimexpg1.xml";
	    }
	} else {
	    // must be an Integrated Resource
	    href = "../../resources/"+schema+"/"+schema+".xml#"+expressRef;
	}
    }
    return(href);
}

// If a schemaname is given, then it is a schema page
function convertImgFile(imgFile, newImgFile, schemaName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");    
    // Load in the image xml file    
    var imgXml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    imgXml.async = false;
    imgXml.load(imgFile);
    
    // replace the src attribute with the new GIF
    // it would have been better to do this in the XSL but can't work 
    // out how to pass a parameter in
    var expr = "/imgfile.content/img";
    var node = imgXml.selectSingleNode(expr);    
    var newGif = fso.getFileName(newImgFile).replace(".xml",".gif");
    node.setAttribute("src",newGif);

    // Change the hrefs

    // first check if dealing with a schema page
    var re = /graphics1.xml/;
    var schemaPage = false;
    if (imgFile.match(re)) schemaPage = true;
        expr = "/imgfile.content/img/img.area";
    var nodes = imgXml.selectNodes(expr);
    var members = nodes.length;
    for (var i = 0; i < members; i++) {
	var node = nodes(i);
	var href = node.attributes.getNamedItem("href").nodeValue;
	if (schemaPage) 
	    href = convertHrefSchema(href,schemaName);
	else
	    href = convertHref(href,newImgFile);
	node.setAttribute("href",href);
    } 

    // now set file and module xxxx
    expr="/imgfile.content";
    var moduleName = getModuleName(schemaName);
    var newImgFileName = fso.GetFileName(newImgFile);
    // Now add file and module attributes

    // Load style sheet.
    var xsl = "./convert_imgfile.xsl";
    var objStyle = new ActiveXObject("Msxml2.FreeThreadedDOMDocument");
    objStyle.async = false;
    objStyle.load(xsl);


    var objTransformer = new ActiveXObject("Msxml2.XSLTemplate");
    objTransformer.stylesheet = objStyle.documentElement;
    var objProcessor = objTransformer.createProcessor();
    objProcessor.input = imgXml;
//file is the name of the image file
    objProcessor.addParameter("file",newImgFileName, "");
//module is module name or ir doc name
    objProcessor.addParameter("module",moduleName, "");
//source is the ECCO file name
    objProcessor.addParameter("source",sourceFile, "");
    objProcessor.transform();
    userMessage("file: "+newImgFileName);
    userMessage("module: "+moduleName);
    userMessage("source: "+sourceFile);


    // The resulting XML
    var replace = true; var unicode = false; //output file properties
    var newImgXmlFile = fso.CreateTextFile( newImgFile, replace, unicode );

    var theXml = objProcessor.output;

    newImgXmlFile.WriteLine("<?xml version=\"1.0\"?>"); 
    newImgXmlFile.write( theXml );
    
    fso.DeleteFile(imgFile);
    
}

// Extract the schema page - not used
function convertSchemaPage(eccoDir,schemaName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var modDir = eccoDir+"/modules";
    var schDir  = modDir+"/schemaPage";
    var modFldr, schFldr, dstFldr;
    if (fso.FolderExists(modDir)) {
	if (fso.FolderExists(schDir)) {
	    schFldr= fso.GetFolder(schDir);
	} else {
	    schFldr = fso.CreateFolder(schDir);
	}
    } else {
	fso.CreateFolder(modDir);
	schFldr = fso.CreateFolder(schDir);
    }

}

// Get all the schema from a model.xml file
// Create a directory called modules
// Create a directory for each schema: modules/<schema> 
// where <schema> is the name of the schema.
//       <expr> is the XPath expression
function extractSchemaFromXML(eccoDir,expr) {

    var replace = true; var unicode = false; //output file properties
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var geFldr = fso.GetFolder(eccoDir);
    var modelXmlFile = geFldr.Path.toString()+"\\model.xml";
    var dstDir = eccoDir+"/modules";
    var dstFldr;
    if (fso.FolderExists(dstDir)) {
	dstFldr= fso.GetFolder(dstDir);
    } else {
	dstFldr = fso.CreateFolder(dstDir);    
    }

    // Load in the model.xml file
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(modelXmlFile);
    checkXMLParse(xml);

    // Load style sheet.
    var xsl = "./extract_schema.xsl";
    var stylesheet = new ActiveXObject("Msxml2.DOMDocument.3.0");
    stylesheet.async = false;
    stylesheet.load(xsl);
    var schemaNodes = xml.selectNodes(expr);
    var members = schemaNodes.length;
    for (var i = 0; i < members; i++) {	
	var node = schemaNodes(i);
	var schemaName = node.childNodes.item(i).childNodes.item(0).nodeValue;

	// create a directory to store the schema in
	var moduleDir = dstDir+"/"+schemaName;
	var moduleFldr = fso.CreateFolder(moduleDir);    
	var schemaXmlFile = moduleFldr.Path.toString()+"\\"+getArmMimXml(schemaName)+'.xml';

	// Extract the schema to a file
	var schemaXml = fso.CreateTextFile( schemaXmlFile, replace, unicode );


	var theXml = node.transformNode( stylesheet );

	// Set up the resulting document.
	var result = new ActiveXObject("Msxml2.DOMDocument");
	result.async = false;
 
	schemaXml.WriteLine("<?xml version=\"1.0\"?>"); 
	schemaXml.write( theXml );
    }

    //  not implemented Copy across the image maps and gifs
    //    imgArr = copyAllImgMaps(eccoDir, dstDir);
}


// Extract named schema from model.xml file
function convertSchema(eccoDir,schemaName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (checkEccoDir(eccoDir) == 0) {
	var dstDir = eccoDir+"/modules";	
	if (checkDstDir(dstDir) == 0) {
	    if (checkSchema(eccoDir, schemaName) == 0 ) {
	      //		var expr = "/iso_10303_28/express_schema/schema_decl/schema_id[.=\""+schemaName+"\"]";
		var expr = "/iso_10303_28/express_schema/schema_decl[schema_id=\""+schemaName+"\"]";
		extractSchemaFromXML(eccoDir,expr);
		convertSchemaPage(eccoDir,schemaName);
	    }
	}
    }
}


// Extract all schema from model.xml file
function convertAll(eccoDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (checkEccoDir(eccoDir) == 0) {
	var dstDir = eccoDir+"/modules";
	if (checkDstDir(dstDir) == 0) {
	    var expr = "/express/schema";
	    extractSchemaFromXML(eccoDir,expr);
	    // need to fix convertSchemaPage to deal with ALL schemas
	    convertSchemaPage(eccoDir);
	}
    }
}




// ------------------------------------------------------------
// Checks
// ------------------------------------------------------------
function testArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript ecco2moduleMain.js <ECCO graphics directory> <schema name>\n";
    if ( !((cArgs.length == 1) || (cArgs.length == 2)) ) {
	ErrorMessage(msg);
	return(0);
    } else {
	return(1);
    }
}

function checkSchema(eccoDir, schemaName) {
    var retVal = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var geFldr = fso.GetFolder(eccoDir);
    var modelXmlFile = geFldr.Path.toString()+"\\model.xml";

    // Load data.
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(modelXmlFile);
    //    var expr = "//express/schema[@name=\""+schemaName+"\"]";
    var expr = "/iso_10303_28/express_schema/schema_decl/schema_id[.=\""+schemaName+"\"]";
    var schemaNamedNodes = xml.selectNodes(expr);
    //ErrorMessage("expr in checkSchema: "+expr);
    if (schemaNamedNodes.length != 1) {
	expr = "//iso_10303_28/express_schema/schema_decl/schema_id";
	var schemaNodes = xml.selectNodes(expr);
	var errMsg = "Schema "+schemaName+" not found in: "+ modelXmlFile +"\n";
	errMsg += "\nThe schemas found are:\n";	
	for (var i = 0; i < schemaNodes.length; i++) {
	    node = schemaNodes(i);
	    schemaName = node.childNodes.item(0).nodeValue;
	    errMsg +=  "   "+schemaName+"\n";
	}
	ErrorMessage(errMsg);
	retVal = -1;
    }
    return(retVal);
}


function checkEccoDir(eccoDir) {
    var retVal = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (!fso.FolderExists(eccoDir)) {
	retVal = -1;
	ErrorMessage(eccoDir+"\nGraphicalExpress folder does not exist.");
	return(retVal);
    }
    // Check for model.xml
    var geFldr = fso.GetFolder(eccoDir);
    var modelXmlFile = geFldr.Path.toString()+"\\model.xml";
    if (!fso.FileExists(modelXmlFile)) {
	retVal = -1
	ErrorMessage(modelXmlFile+"\ndoes not exist.");
	return(retVal);
    }
    return(retVal);
}

function checkDstDir(dstDir) {
    var retVal = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(dstDir)) {	
	var msg = dstDir+"\nAlready exists.\nDo you want to delete it?";
	var del = yesOrNo(msg,"Warning");
	if (del == "yes") {
	    // Delete the folder
	    fso.DeleteFolder(dstDir);
	    retVal = 0;
	} else {
	    retVal = -1;
	}
    }
    return(retVal);
}

function xmlError(xmlDoc) {
    if (xmlDoc.errorCode != 0) {
	var strError = new String;
	strError = 'Invalid XML file!\n'
	    + 'File URL: ' + xmlDoc.parseError.url  + '\n'
	    + 'Line No ' + xmlDoc.parseError.line  + '\n'
	    + 'Character: ' + xmlDoc.parseError.linepos  + '\n'
	    + 'File position: ' + xmlDoc.parseError.filepos + '\n'
	    + 'Source text : ' + xmlDoc.parseError.srcText  + '\n'
	    + 'Error code: ' + xmlDoc.parseError.errorCode  + '\n'
	    + 'Description: ' + xmlDoc.parseError.reason  + '\n';
	ErrorMessage(strError);
    }
    return(xmlDoc.errorCode);
}

function copyToModuleDir(eccoDir, schemaName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    var modDir = eccoDir+"\\modules";

    var schPaeccoDir  = modDir+"\\schemaPage";
    var schPageFldr = fso.GetFolder(schPaeccoDir);

    var schDir = modDir+"\\"+schemaName;
    var schFldr = fso.GetFolder(schDir);


    var moduleName = getModuleName(schemaName);
    userMessage("modulename: "+moduleName);
    userMessage("schemaname: "+schemaName);
	if (moduleName == schemaName){
		var toModuleDir = stepmodHome+"\\data\\resources\\"+moduleName+"\\";
        }else {
		var toModuleDir = stepmodHome+"\\data\\modules\\"+moduleName+"\\";
	}
    if (!fso.FolderExists(toModuleDir)) {
	toModuleDir = eccoDir+"\\tomodule\\";	
	userMessage("Module "+toModuleDir+
		    " not created,\n copying files to: "+
		    toModuleDir+"\n");       
	if (fso.FolderExists(toModuleDir)) {
	    var toModuleFldr= fso.GetFolder(toModuleDir);
	    toModuleFldr.Delete();
	    fso.CreateFolder(toModuleDir); 
	} else {
	    fso.CreateFolder(toModuleDir);    
	}
    }
    //userMessage(toModuleDir);


    var filesC = new Enumerator(schPageFldr.files);
    for (; !filesC.atEnd(); filesC.moveNext()) {
	var f1 = filesC.item();
	fso.CopyFile(f1,toModuleDir);
	userMessage("Cp: "+f1+" to "+ toModuleDir);
    }
    filesC = new Enumerator(schFldr.files);
    var fileCount = 1;
    for (; !filesC.atEnd(); filesC.moveNext()) {
	var f1 = filesC.item();
	var fName = fso.GetFileName(f1);
	if (fName != "module.xml") {
	    fileCount++;
	    fso.CopyFile(f1,toModuleDir);
	    userMessage("Cp: "+f1+" to "+ toModuleDir);
	}
    }
    var modPath = getModulePath(schemaName);
    popupInform("Extracted schema: "+schemaName+"\nto "+modPath+"\n\n"+fileCount/2+
		" Express-G files copied.\nUpdate <express-g> in module.xml accordingly");
}

// ------------------------------------------------------------
// Main program
// Arg 1 
//   GraphicalExpress directory containing model.xml and graphics
// Arg 2
//   Destination directory where XML will be stored
// Arg 3
//  Name of the schema being extracted from
// -----------------------------------------------------------
function Main() {
    if (testArgs()==1) {
	var cArgs = WScript.Arguments;
	var eccoDir = cArgs(0);
	if (checkEccoDir(eccoDir) == 0) {
	    if (cArgs.length == 1) {
		convertAll(eccoDir);
	    } else {
		var schemaName = cArgs(1);
		convertSchema(eccoDir,schemaName);
		//convertAll(eccoDir);
		copyToModuleDir(eccoDir, schemaName);
	    }
	}
    }
}


//copyToModuleDir("E:\\rbn\\1export","External_class_mim");


//getModulePath("Product_group_arm");
//convertSchema("d:\\rbn\\1export", "Product_group_mim");
