//$Id: getExpressMain.js,v 1.1 2002/03/11 10:15:40 robbod Exp $
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

// Copy across the Integrated Resource express
function GetIrExpress(expDir) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var irFldr = fso.GetFolder(expDir+"/resources");
    var index = "../repository_index.xml";
    var xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xml.async = false;
    xml.load(index);
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
	    src = fso.GetFile(resourceFileName);
	    dst = newResourceFileName;
	    src.Copy(dst);
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

// Append all the express files
function AppendMimArm(armOrMim, expDir, modList) {
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
    armStr.Close();
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

//Run from getEpxress.wsf
function MainWindow(expDir, modList) {
    if (TestParams(expDir, modList) == 1) {
	MakeDirs(expDir);
	GetArmMimExpress(expDir, modList);
	GetIrExpress(expDir);
	AppendMimArm("arm",expDir,modList);
	AppendMimArm("mim",expDir,modList);
	UserMessage("Created directory:\n  "+expDir);
    }
}


//MainWindow("..\\express", "..\\modlist");
