//$Id: getExpressMain.js,v 1.11 2003/03/10 01:27:38 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep 
//  Purpose:  JScript to copy all the express files from the repository to
//            a directory. 
//
//            The script is called from getExpress.wsf
//
//            Given the name of a new directory, <dir> create a three sub
//            directories 
//                     <dir>/arm - the ARM express
//                     <dir>/mim - the MIM express
//                     <dir>/resources - the Integrated resources express
//            Copy the all the ARM, MIM and Integrated Resource express
//            from the repository renaming each express file to be the same
//            as the schema it contains and storing it in the relevant
//            directory  
//               cscript getExpressMain.js <dir>
//            e.g.
//               cscript getExpressMain.js "../express"
//
//------------------------------------------------------------

// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var stepmodHome = '..';

// If 1 then output user messages
var outputUsermessage = 1;


function Debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function UserMessage(msg){
    WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    if (outputUsermessage == 1)
	WScript.Echo(msg);
    objShell.Popup(msg);
}


// Add a function called trim as a method of the prototype 
// object of the String constructor.
String.prototype.trim = function()
{
    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    return this.replace(/(^\s*)|(\s*$)/g, "");
}


function getDate() {
    var d, s="";
    d = new Date();                           //Create Date object.
    s += d.getYear();                         //Get year.
    s += d.getMonth() + 1;            //Get month
    s += d.getDate();                   //Get day
   return(s);                                //Return date.
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

// Copy across the Integrated Resource express
// and concatenate them.
function GetIrExpress(expDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;
    var irFldr = fso.GetFolder(expDir+"/resources");

    var resourceFile = expDir+"/resources/resource.exp";    
    // make sure that the resource.exp file does not exist
    if (fso.FileExists(resourceFile)) {
	ErrorMessage("The "+resourceFile+" already exists. Delete to proceed\n"+resourceFile);
	return(0);
    }

    var resourceStr = fso.CreateTextFile(resourceFile, true);    

    var index = "../repository_index.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(index);
    checkXMLParse(xml);
    var expr = "/repository_index/resources/resource";
    var resourceNodes = xml.selectNodes(expr);
    var members = resourceNodes.length;
    for (var i = 0; i < members; i++) {	
	var node = resourceNodes(i);
	var resourceName = node.attributes.getNamedItem("name").nodeValue;
	var src, dst;

	// Copy across resource express file
	var resourceFileName = "../data/resources/"+resourceName+"/"+resourceName+".exp";
	var newResourceFileName = expDir+"/resources/"+resourceName+".exp";
	//UserMessage(resourceFileName+"->"+newResourceFileName);

	if (fso.FileExists(resourceFileName)) {
	    //copy across resource file
	    src = fso.GetFile(resourceFileName);
	    dst = newResourceFileName;
	    src.Copy(dst);
	    
	    // append into resources.exp
	    var srcStr = fso.OpenTextFile(src,ForReading);	
	    resourceStr.WriteLine("");
	    resourceStr.WriteLine("");
	    resourceStr.WriteLine("(*");
	    resourceStr.WriteLine("   ------------------------------------------------------------");
	    resourceStr.WriteLine(src);
	    resourceStr.WriteLine("   ------------------------------------------------------------");
	    resourceStr.WriteLine("*)");
	    resourceStr.WriteLine("");
	    while (!srcStr.AtEndOfStream) {
		var l =  srcStr.ReadLine();
		// ignore 
		// {iso standard 10303 part (11) version (4)} 
		var reg = /{.*iso\b/;
		if (!l.match(reg))
		    resourceStr.WriteLine(l);
	    }
	    srcStr.Close();    
	} else {
	    UserMessage("File does not exist:\n"+resourceFileName);
	}
	    
    }
}


// Copy across the MIM and the ARM express
function GetArmMimExpressOld(expDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var armFldr = fso.GetFolder(expDir+"/arm");
    var mimFldr = fso.GetFolder(expDir+"/mim");

    var index = "../repository_index.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(index);
    checkXMLParse(xml);
    var expr = "/repository_index/modules/module";
    var moduleNodes = xml.selectNodes(expr);
    var members = moduleNodes.length;
    UserMessage("Making:"+members);
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	var src, dst;

	// Copy across mim file
	var mimFileName = "../data/modules/"+moduleName+"/mim.exp";
	var newMimFileName = expDir+"/mim/"+moduleName+"_mim.exp";
	//UserMessage(mimFileName+"->"+newMimFileName);

	if (fso.FileExists(mimFileName)) {
	    src = fso.GetFile(mimFileName);
	    dst = newMimFileName;
	    src.Copy(dst);
	} else {
	    UserMessage("File does not exist:\n"+mimFileName);
	}

	// Copy across arm file
	var armFileName = "../data/modules/"+moduleName+"/arm.exp";
	var newArmFileName = expDir+"/arm/"+moduleName+"_arm.exp";
	if (fso.FileExists(armFileName)) {
	    src = fso.GetFile(armFileName);
	    dst = newArmFileName;
	    src.Copy(dst);
	} else {
	    UserMessage("File does not exist:\n"+armFileName);
	}
    }
}

// Copy across the Integrated Resource express listed in irList
// and concatenate them.
function GetIrListExpress(expDir, irList) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;

    if (!fso.FileExists(irList)) {
	ErrorMessage("The "+irList+" file does not exist");
	return(0);
    }

    var irFldr = fso.GetFolder(expDir+"/resources");

    var resourceFile = expDir+"/resources/resource.exp";    
    // make sure that the resource.exp file does not exist
    if (fso.FileExists(resourceFile)) {
	ErrorMessage("The "+resourceFile+" already exists. Delete to proceed\n"+resourceFile);
	return(0);
    }

    var resourceStr = fso.CreateTextFile(resourceFile, true);    

    var irListStr = fso.OpenTextFile(irList,1);

    while (!irListStr.AtEndOfStream) {
	var resourceName =  irListStr.ReadLine();
	// strip white space - read word
	resourceName = resourceName.trim();

	var src, dst;
	// any module starting with // is assumed commented out
	var reg=/^\w+/;
	var word = resourceName.match(reg);
	if (word) {
	    // Copy across resource express file
	    var resourceFileName = "../data/resources/"+resourceName+"/"+resourceName+".exp";
	    var newResourceFileName = expDir+"/resources/"+resourceName+".exp";
	    //UserMessage(resourceFileName+"->"+newResourceFileName);
	    if (fso.FileExists(resourceFileName)) {
		//copy across resource file
		src = fso.GetFile(resourceFileName);
		dst = newResourceFileName;
		src.Copy(dst);
		
		// append into resources.exp
		var srcStr = fso.OpenTextFile(src,ForReading);	
		resourceStr.WriteLine("");
		resourceStr.WriteLine("");
		resourceStr.WriteLine("(*");
		resourceStr.WriteLine("   ------------------------------------------------------------");
		resourceStr.WriteLine(src);
		resourceStr.WriteLine("   ------------------------------------------------------------");
		resourceStr.WriteLine("*)");
		resourceStr.WriteLine("");
		while (!srcStr.AtEndOfStream) {
		    var l =  srcStr.ReadLine();
		    // ignore 
		    // {iso standard 10303 part (11) version (4)} 
		    var reg = /{.*iso\b/;
				if (!l.match(reg))
				resourceStr.WriteLine(l);
		    }
		    srcStr.Close();    
		} else {
		    UserMessage("File does not exist:\n"+resourceFileName);
		}
	    }
    }
}

function GetArmMimExpress(expDir, modList) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var armFldr = fso.GetFolder(expDir+"/arm");
    var mimFldr = fso.GetFolder(expDir+"/mim");

    if (!fso.FileExists(modList)) {
	ErrorMessage("The "+modList+" file does not exist");
	return(0);
    }

    var modListStr = fso.OpenTextFile(modList,1);

    while (!modListStr.AtEndOfStream) {
	var moduleName =  modListStr.ReadLine();
	// strip white space - read word
	moduleName = moduleName.trim();
	var src, dst;

	// any module starting with // is assumed commented out
	var reg=/^\w+/;
	var word = moduleName.match(reg);
	if (word) {
	    //UserMessage(moduleName);
	    // Copy across mim file
	    var mimFileName = "../data/modules/"+moduleName+"/mim.exp";
	    var newMimFileName = expDir+"/mim/"+moduleName+"_mim.exp";
	    //UserMessage(mimFileName+"->"+newMimFileName);
	    
	    if (fso.FileExists(mimFileName)) {
		src = fso.GetFile(mimFileName);
		dst = newMimFileName;
		src.Copy(dst);
	    } else {
		UserMessage("File does not exist:\n"+mimFileName);
	    }

	    // Copy across arm file
	    var armFileName = "../data/modules/"+moduleName+"/arm.exp";
	    var newArmFileName = expDir+"/arm/"+moduleName+"_arm.exp";
	    if (fso.FileExists(armFileName)) {
		src = fso.GetFile(armFileName);
		dst = newArmFileName;
		src.Copy(dst);
		//UserMessage(armFileName+"->"+newArmFileName);
	    } else {
		UserMessage("File does not exist:\n"+armFileName);
	    }
	} 
    }
}

function MakeDirs(expDir) {
    var retVal = 1;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FolderExists(expDir)) {
	ErrorMessage("Directory exists:\n"+expDir);
	return(-1);

    } else {
	fso.CreateFolder(expDir);
	fso.CreateFolder(expDir+"/arm");
	fso.CreateFolder(expDir+"/mim");
	fso.CreateFolder(expDir+"/resources");
    }
    return(retVal);
}

function AppendFiles(src, dst) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;
    var srcStr = fso.OpenTextFile(src,ForReading);
    var dstStr = fso.OpenTextFile(dst,ForAppending);

    while (!srcStr.AtEndOfStream) {
	var l =  srcStr.ReadLine();
	dstStr.WriteLine(l);
    }
    srcStr.Close();
    dstStr.Close();
}

// Append the concatenated Mim.exp and resource.exp
function AppendMimResources(expDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;
    
    var dateSuffix="_"+getDate()+"v1";

    var mimFile = expDir+"/mim/mim"+dateSuffix+".exp";
    var mimStr = fso.OpenTextFile(mimFile,ForReading);

    var mimResFile = expDir+"\\mim\\mim_resources"+dateSuffix+".exp";
    var mimResStr = fso.CreateTextFile(mimResFile, true);	

    var resourceFile = expDir+"/resources/resource.exp";
    var resourceStr = fso.OpenTextFile(resourceFile, ForReading);

    mimResStr.WriteLine("");
    mimResStr.WriteLine("(*");
    mimResStr.WriteLine("   ------------------------------------------------------------");
    mimResStr.WriteLine("    MIM SCHEMAS ");
    mimResStr.WriteLine("   ------------------------------------------------------------");
    mimResStr.WriteLine("*)");
    mimResStr.WriteLine("");

    while (!mimStr.AtEndOfStream) {
	var l =  mimStr.ReadLine();
	mimResStr.WriteLine(l);
    }

    mimResStr.WriteLine("");
    mimResStr.WriteLine("(*");
    mimResStr.WriteLine("   ------------------------------------------------------------");
    mimResStr.WriteLine("    COMMON RESOURCE SCHEMAS");
    mimResStr.WriteLine("   ------------------------------------------------------------");
    mimResStr.WriteLine("*)");
    mimResStr.WriteLine("");

    while (!resourceStr.AtEndOfStream) {
	var l =  resourceStr.ReadLine();
	mimResStr.WriteLine(l);
    }

    mimStr.Close();
    mimResStr.Close();
    resourceStr.Close();
    return(mimResFile);
}

// Append all the express files
function AppendMimArm(armOrMim, expDir, modList) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;
    var schemaArr = new Array;

    var dateSuffix="_"+getDate()+"v1";
    
    var armFile = expDir+"\\"+armOrMim+"\\"+armOrMim+dateSuffix+".exp"
    // make sure that the arm.exp file does not exist
    if (fso.FileExists(armFile)) {
	ErrorMessage("The "+armOrMim+".exp already exists. Delete to proceed\n"+armFile);
	return(0);
    }  

    if (!fso.FileExists(modList)) {
	ErrorMessage("The "+modList+" file does not exist");
	return(0);
    }  
    var modListStr = fso.OpenTextFile(modList,ForReading);
    var armStr = fso.CreateTextFile(armFile, true);

    var srcPath = fso.GetFolder(expDir).Path.toString();

    var reg = /{.*iso\b/;
    while (!modListStr.AtEndOfStream) {
	var src =  modListStr.ReadLine();
	// strip white space - read word
	src = src.trim();
	// any module starting with // is assumed commented out
	var word = src.match(/^\w+/);
	if (word) {
	    src = srcPath+"\\"+armOrMim+"\\"+src+"_"+armOrMim+".exp";
	    if (fso.FileExists(src)) {
		var srcStr = fso.OpenTextFile(src,ForReading);	
		armStr.WriteLine("");
		armStr.WriteLine("");
		armStr.WriteLine("(*");
		armStr.WriteLine("   ------------------------------------------------------------");
		armStr.WriteLine(src);
		armStr.WriteLine("   ------------------------------------------------------------");
		armStr.WriteLine("*)");
		armStr.WriteLine("");
		while (!srcStr.AtEndOfStream) {
		    var l =  srcStr.ReadLine();
		    // ignore 
		    // {iso standard 10303 part (11) version (4)} 
		    if (!l.match(reg))
			armStr.WriteLine(l);
		}
		srcStr.Close();    
	    }
	}
    }
   armStr.Close();
   return(armFile);		
}

function AppendMimArmOld(armOrMim, expDir, modList) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ForAppending = 8;
    var ForReading = 1;
    var schemaArr = new Array;

    var armFile = expDir+"/"+armOrMim+"/"+armOrMim+".exp";    
    // make sure that the arm.exp file does not exist
    if (fso.FileExists(armFile)) {
	ErrorMessage("The "+armOrMim+".exp already exists. Delete to proceed\n"+armFile);
	return(0);
    }

    var armFldr = fso.GetFolder(expDir+"/"+armOrMim);
    var fc = new Enumerator(armFldr.files);
    for (; !fc.atEnd(); fc.moveNext()) {
	    var fpath = fc.item();
	    if (fpath.type == "EXP File") 
		schemaArr.push(fpath);
    }

    var armStr = fso.CreateTextFile(armFile, true);

    var reg = /{.*iso\b/;

    for (var i=0; i<schemaArr.length; i++) {	
	var src = schemaArr[i];
	var srcStr = fso.OpenTextFile(src,ForReading);
	armStr.WriteLine("");
	armStr.WriteLine("");
	armStr.WriteLine("(*");
	armStr.WriteLine("   ------------------------------------------------------------");
	armStr.WriteLine(src);
	armStr.WriteLine("   ------------------------------------------------------------");
	armStr.WriteLine("*)");
	armStr.WriteLine("");
	while (!srcStr.AtEndOfStream) {
	    var l =  srcStr.ReadLine();
	    // ignore 
	    // {iso standard 10303 part (11) version (4)} 
	    if (!l.match(reg))
		armStr.WriteLine(l);
	}
	srcStr.Close();    
    }
    armStr.Close();
}



function outputModuleList(ballot) {
    var ballotIndexXml = stepmodHome + "/ballots/ballots/"
	+ballot+"/ballot_index.xml";
    UserMessage("Loading: "+ballotIndexXml);
    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = false;
    objXML.load(ballotIndexXml);
    checkXMLParse(objXML);

    var expr = "/ballot_index/ballot_package/module";
    var moduleNodes = objXML.selectNodes(expr);
    //moduleNodes = objXML.getElementsByTagName("ballot_index");
    var members = moduleNodes.length;
    UserMessage("Making:"+members);
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	UserMessage(moduleName);
    }

}


function TestArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript getExpress.js <new directory>\n";
    if (cArgs.length != 1) {
	ErrorMessage(msg);
	return(-1);
    } else {
	return(1);
    }
}

function TestParams(expDir, modList) {
    var armFile = expDir+"/arm/arm.exp";    
    var mimFile = expDir+"/mim/mim.exp";    
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    if (fso.FolderExists(expDir)) {
	ErrorMessage("Directory exists:\n"+expDir);
	return(-1);
    } else if (!fso.FileExists(modList)) {
	ErrorMessage("The "+modList+" file does not exist");
	return(-1);
    } else if (fso.FileExists(armFile)) {
	ErrorMessage("The "+armFile+" already exists. Delete to proceed\n"+armFile);
	return(-1);
    } else  if (fso.FileExists(mimFile)) {
	ErrorMessage("The "+mimFile+" already exists. Delete to proceed\n"+armFile);
	return(-1);
    }  
    return(1);
}



// Given the name of a new directory, <dir> create a three sub directories
// <dir>/arm - the ARM express
// <dir>/mim - the MIM express
// <dir>/resources - the Integrated resources express
// Copy the all the ARM, MIM and Integrated Resource express from the 
// repository renaming each express file to be the same as the schema it 
// contains and storing it in the relevant directory 
function Main() {
    if (TestArgs()==1) {
	var cArgs = WScript.Arguments;
	var expDir = cArgs(0);	
	if (MakeDirs(expDir) == 1) {
	    GetArmMimExpress(expDir);
	    GetIrExpress(expDir);
	    UserMessage("Created directory:\n  "+expDir);
	}
    }
}

//Run from getExpress.wsf
function MainWindow(expDir, modList) {
    if (TestParams(expDir, modList) == 1) {
	MakeDirs(expDir);
	GetArmMimExpress(expDir, modList);
	GetIrExpress(expDir);
	var armFile = AppendMimArm("arm",expDir,modList);
	var mimFile = AppendMimArm("mim",expDir,modList);
	var resFile = AppendMimResources(expDir);
	UserMessage("Created directory:\n  "+expDir
		    + "\nConcatenated ARM EXPRESS: "+armFile
		    + "\nConcatenated MIM EXPRESS: "+mimFile
		    + "\nConcatenated MIM+Resource EXPRESS: "+resFile);
    }
}

function MainWindowIrList(expDir, modList, irList) {
    if (TestParams(expDir, modList) == 1) {
	MakeDirs(expDir);
	GetArmMimExpress(expDir, modList);
	GetIrListExpress(expDir, irList);
	var armFile = AppendMimArm("arm",expDir,modList);
	var mimFile = AppendMimArm("mim",expDir,modList);
	var resFile = AppendMimResources(expDir);

	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var newArmFile = expDir+"/"+fso.GetFileName(armFile);
	fso.CopyFile(armFile,newArmFile);

	var newMimFile = expDir+"/"+fso.GetFileName(mimFile);
	fso.CopyFile(mimFile,newMimFile);

	var newResFile = expDir+"/"+fso.GetFileName(resFile);
	fso.CopyFile(resFile,newResFile);

	UserMessage("Created directory:\n  "+expDir
		    + "\nConcatenated ARM EXPRESS: "+newArmFile
		    + "\nConcatenated MIM EXPRESS: "+newMimFile
		    + "\nConcatenated MIM+Resource EXPRESS: "+newResFile);
    }
}


function getAbstractFileName(moduleName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var moduleXmlFile = "../data/modules/"+moduleName+"/module.xml";
    var fileName ="";
    if (!fso.FileExists(moduleXmlFile)) {
	ErrorMessage("The "+moduleXmlFile+" does not exist");
    } else {
	return(moduleName+"_abstract");
    }
}

function getExpressFileName(moduleName, arm_or_mim) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var moduleXmlFile = "../data/modules/"+moduleName+"/module.xml";
    var fileName ="";
    if (!fso.FileExists(moduleXmlFile)) {
	ErrorMessage("The "+moduleXmlFile+" does not exist");
    } else {
	var moduleXml =  new ActiveXObject("Msxml2.DOMDocument.3.0");
	moduleXml.async = false;
	moduleXml.load(moduleXmlFile);
	if (checkXMLParse(moduleXml)) {
	    var expr = "/module";
	    var theModuleNodes = moduleXml.selectNodes(expr);
	    var moduleNode = theModuleNodes(0);
	    var partNo = moduleNode.attributes.getNamedItem("part").nodeValue;
	    var status = moduleNode.attributes.getNamedItem("status").nodeValue;
	    status = status.replace(/[^a-zA-Z]/g,"");
	    status = status.toLowerCase();
	    var wgGroup = moduleNode.attributes.getNamedItem("sc4.working_group");
	    if (wgGroup) {
		wgGroup = wgGroup.nodeValue;
	    } else {
		wgGroup = "12";
	    }
	    var fileStub="part"+partNo+status+"_wg"+wgGroup+"n";
	    if (arm_or_mim == "arm") {
		var wgNo = moduleNode.attributes.getNamedItem("wg.number.arm").nodeValue;
		fileName = fileStub+wgNo+"arm.exp";
	    } else if (arm_or_mim == "arm_lf") {
		var wgNo = moduleNode.attributes.getNamedItem("wg.number.arm_lf");
		if (wgNo) {
		    wgNo = wgNo.nodeValue;		
		    fileName = fileStub+wgNo+"arm_lf.exp";
		} else {
		    fileName = "";
		}
	    } else if (arm_or_mim == "mim") {
		var wgNo = moduleNode.attributes.getNamedItem("wg.number.mim").nodeValue;
		fileName = fileStub+wgNo+"mim.exp";
	    } else if (arm_or_mim == "mim_lf") {
		var wgNo = moduleNode.attributes.getNamedItem("wg.number.mim_lf");
		if (wgNo) {
		    wgNo = wgNo.nodeValue;
		    fileName = fileStub+wgNo+"mim_lf.exp";
		} else {
		    fileName = "";
		}
	    } else {
		ErrorMessage("Must specifiy arm, arm_lf, mim or mim_lf");
		fileName = "";
	    }
	} 
    }
    return(fileName);
}

// Copy across all the abstracts for a ballot
function GetBallotAbstracts(ballotName) {
    
}

// Copy all the express from the modules listed in a ballot, rename them and copy them to 
// stepmod/ballots/isohtml/<ballot>
function MainWindowBallotExpress(ballotName) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var ballotIndex = "../ballots/ballots/"+ballotName+"/ballot_index.xml";
    if (!fso.FileExists(ballotIndex)) {
	ErrorMessage("The "+ballotIndex+" does not exist");
	return(-1);
    }
    var ballotExpressFldr = "../ballots/isohtml/"+ballotName+"/express";
    if (fso.FolderExists(ballotExpressFldr)) {
	ErrorMessage("Directory exists:\n"+ballotExpressFldr);
	return(-1);
    }
    fso.CreateFolder(ballotExpressFldr);

    var ballotAbstractFldr =  "../ballots/isohtml/"+ballotName+"/abstracts";
    if (fso.FolderExists(ballotAbstractFldr)) {
	ErrorMessage("Directory exists:\n"+ballotAbstractFldr);
	return(-1);
    }
    fso.CreateFolder(ballotAbstractFldr);


    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(ballotIndex);
    if (checkXMLParse(xml)) {
	var expr = "//module";
	var moduleNodes = xml.selectNodes(expr);
	var members = moduleNodes.length;
	for (var i = 0; i < members; i++) {	
	    var node = moduleNodes(i);
	    var moduleName = node.attributes.getNamedItem("name").nodeValue;
	    var fileName, src, dst;
	    var armFile = "../data/modules/"+moduleName+"/arm.exp";
	    if (fso.FileExists(armFile)) {
		fileName = getExpressFileName(moduleName, "arm");
		if (fileName != "") {
		    dst = ballotExpressFldr+"/"+fileName;
		    src = fso.GetFile(armFile);
		    //UserMessage(src+" -> "+dst);
		    src.Copy(dst);
		}
	    } else {
		ErrorMessage("File does not exist: "+armFile);
	    }
	    armFile = "../data/modules/"+moduleName+"/arm_lf.exp";
	    if (fso.FileExists(armFile)) {
		fileName = getExpressFileName(moduleName, "arm_lf");
		if (fileName != "") {
		    dst = ballotExpressFldr+"/"+fileName;
		    src = fso.GetFile(armFile);
		    //UserMessage(src+" -> "+dst);
		    src.Copy(dst);
		}
	    }
	    
	    var mimFile = "../data/modules/"+moduleName+"/mim.exp";
	    if (fso.FileExists(mimFile)) {
		fileName = getExpressFileName(moduleName, "mim");
		if (fileName != "") {
		    dst = ballotExpressFldr+"/"+fileName;
		    src = fso.GetFile(mimFile);
		    //UserMessage(src+" -> "+dst);
		    src.Copy(dst);
		}
	    } else {
		ErrorMessage("File does not exist: "+mimFile);
	    }

	    mimFile = "../data/modules/"+moduleName+"/mim_lf.exp";
	    if (fso.FileExists(mimFile)) {
		fileName = getExpressFileName(moduleName, "mim_lf");
		if (fileName != "") {
		    dst = ballotExpressFldr+"/"+fileName;
		    src = fso.GetFile(mimFile);
		    //UserMessage(src+" -> "+dst);
		    src.Copy(dst);
		}
	    }

	    var abstractFile ="../ballots/isohtml/"+ballotName+"/data/modules/"+moduleName+"/sys/abstract.htm";
	    if (fso.FileExists(abstractFile)) {
		fileName = getAbstractFileName(moduleName, "abstract");
		if (fileName != "") {
		    dst = ballotAbstractFldr+"/"+fileName;
		    src = fso.GetFile(abstractFile);
		    //UserMessage(src+" -> "+dst);
		    src.Copy(dst);
		}
	    } else {
		ErrorMessage("File does not exist: "+abstractFile);
	    }
	}
	UserMessage("Copied EXPRESS to:\n  "+ballotExpressFldr);
    }
}


//MainWindow("..\\express", "..\\modlist.txt");
//MainWindow("..\\ballots\\ballots\\plcs_bp1\\express", "..\\ballots\\ballots\\plcs_bp1\\modlist.txt");
//MainWindowIrList("..\\ballots\\ballots\\plcs_bp2\\express",  "..\\ballots\\ballots\\plcs_bp2\\modlist.txt", "..\\ballots\\ballots\\plcs_bp2\\irlist.txt");
//MainWindow("..\\ballots\\ballots\\plcs_bp1\\express_nostate", "..\\ballots\\ballots\\plcs_bp1\\modlist_nostate.txt");

MainWindowBallotExpress("plcs_bp3");

//outputModuleList("plcs_bp2");
//outputModuleList("pdm_ballot_072002");


