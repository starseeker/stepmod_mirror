//  $Id: express2xml2.js,v 1.5 2003/07/18 20:39:17 thendrix Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//
//  Other editors:
//	T. Hendrix (Boeing) 
//	P. Huau (GOSET) for subtype_constraint and algorithms of global rules
//      S. Frechette (NIST)
//
//  Open issues:
//	Script does not handle SELF\ construct correctly - deletes it in most cases
//
//	function xmlEnumeration:
//		Still to do ????
//			width CDATA #IMPLIED
//			fix (YES | NO) "NO"
//			precision CDATA #IMPLIED
//			typelabel NMTOKEN #IMPLIED

//  Purpose:
//    JScript to convert an Express file to an XML file
//    cscript express2xml.js <express>
//    cscript express2xml.js <module> arm
//    cscript express2xml.js <module> mim
//    cscript express2xml.js <module> mim_lf
//    cscript express2xml.js <module> module
//    cscript express2xml.js <resource> resource partnumber
//
//    e.g.,
//    cscript express2xml.js part_and_version_identification arm
//    cscript express2xml.js action_schema resource "ISO 10303-41"


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------
var ForReading = 1, ForWriting = 2, ForAppending = 8;

var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;

// The line number of the file being read.
// Only used in Warnings to user
var lNumber = 0;

// The express file being currently parsed
// Only used in Warnings to user
var currentExpFile = 0;

// The string added to the begining of the xml ouput to indent the output
var indent = "";


// Add a function called trim as a method of the prototype 
// object of the String constructor.
//String.prototype.trim = function() {
//    // Use a regular expression to replace leading and trailing 
//    // spaces with the empty string
//    return this.replace(/(^\s*)|(\s*$)/g, "");
//}


// ------------------------------------------------------------
// function debug()
//	Print debug text to screen
// ------------------------------------------------------------
function debug(txt){
    WScript.Echo("Dbx: "+txt);
}


// ------------------------------------------------------------
// function userMessage()
//	Print to command screen
// ------------------------------------------------------------
function userMessage(msg){
    WScript.Echo(msg);
}


// ------------------------------------------------------------
// function errorMessage()
// 	Print error message to command screen
// ------------------------------------------------------------
function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    objShell.Popup(msg);
}


// ------------------------------------------------------------
// function readStatement()
// 	Return a statement terminated by ";"
// ------------------------------------------------------------
function readStatement(line, ts) {
    var pos;
    
    if (ts.AtEndOfStream) {
        return(line);
    }//end if
    
    else {
	pos = line.search(";")
	if (pos == -1){
	    var nextLine = readNextLine(ts);
	
	    var reg = /^[A-Za-z]/;
	    var ch  = nextLine.match(reg);
	    if (ch) {
		// add a white space at the beginning of line
		line = line + " " + readStatement(nextLine, ts);
	    }//end if
	    else {
		line = line + readStatement(nextLine, ts);
	    }//end else
	}  
	else {
	    return(line);
	}
	return(line);
    }//end else
}//end function


// ------------------------------------------------------------
// function normaliseStatement()
// 	Separate all , and ( ) with whitespace, remove all tabs etc
// ------------------------------------------------------------
function normaliseStatement(statement) {
   
    //if (statement == null) {
    //    debug("normalizeStatement: statement variable null");
    //}
    
    statement = statement.replace(/\,/g," , ");
    statement = statement.replace(/\;/g," ;");
    statement = statement.replace(/\[/g," [ ");
    statement = statement.replace(/\]/g," ] ");
    statement = statement.replace(/\(/g," ( ");
    statement = statement.replace(/\)/g," ) ");
    statement = statement.replace(/\t/g," ");
    statement = statement.replace(/^\s*/g,"");
    statement = statement.replace(/(\w)=/g,"$1 =");
    statement = statement.replace(/=(\w)/g,"= $1");
    statement = statement.replace(/=\'/g,"= \'");
    statement = statement.replace(/:(\?)/g,": $1");
    statement = statement.replace(/:(\w)/g,": $1");
    statement = statement.replace(/(\w):/g,"$1 :");

    // replace double space with single space
    while (statement.search(/  /) != -1) {
        statement = statement.replace(/  /g," ");
    }
    
    // debug (statement);
    
    return(statement);
}



// ------------------------------------------------------------
// function readNextLine()
// 	read a line, bypass any comments or blank lines
// ------------------------------------------------------------
function readNextLine(ts) {
    var line = ts.ReadLine();
    lNumber  = ts.Line;	
    line     = trim(line);
    //debug ("1 "+line);

    var blankLine = /^\s*$/;
    var comment1  = /^\s*\(\*/;
    var comment2  = /^--/;
    
    while (line.match(blankLine) || line.match(comment1) || line.match(comment2)){
    	
    	if (line.match(comment1)){
    	    var com = readComment(line,ts);
    	}
    	
        if(!(ts.AtEndOfStream)){
		line    = ts.ReadLine();
	        lNumber = ts.Line;	
        	line    = trim(line);
	}
	else return(line);
    }
    
    // remove any trailing -- comments
    var pos = line.search(/--/);
    if (pos != -1) {	
        line = line.substr(0,pos);
        line = trim(line);
    }
    
    //debug ("2 "+line);
    return (line);	
}	
	
	
// ------------------------------------------------------------
// function list2array()
// 	Given a statement, extract the (list) into an array
// ------------------------------------------------------------
function list2array(statement) {
    var arr  = -1;
    
    //var list = getList(statement);

    var reg  = /\(.*\)/;    
    var list = statement.match( reg );
    if (list) {
	list = list.toString();
	// remove the ()
	list = list.substr(2,list.length-4);
	list = normaliseStatement(list);
	arr  = list.split(",");
    }
    return(arr)
}

// ------------------------------------------------------------
// deprecated function: list2arrayOld (replaced by list2array())
// 	Given a statement, extract the (list) into an array
// ------------------------------------------------------------
//function list2arrayOld(statement) {
//    var arr;
//    var list = getList(statement);
//    if (list) {	
//	// remove all the whitespace
//	//list = list.replace(/ /g,"");	
//	arr = list.split(" ");
//    }
//    return(arr)
//}


// ------------------------------------------------------------
// function splitList()
// 	Given a string, return and array. 
// 	Array[0] is the nth list in the string where n is the listNo
// 	Array[1] is the rest of the strig after the list
// ------------------------------------------------------------
function splitList(str, listNo) {
    var reg = /\(.*\)/;    
    var list = str.match( reg );
    var listArr = new Array(); 
    var parenCnt = 0;
    var listCnt = 0;
    var listStr = "";
    
    if (list) {
	list = str.replace(reg);
	for (var i=0; i<str.length; i++) {
	    var chr = str.charAt(i);
	    switch(chr) {
	      case "(" :
		listStr = listStr + "(";
		parenCnt++;
		if (parenCnt == 1) {
		    listCnt++;
		    if (listCnt == listNo) {
			// found the list
			listStr = "(";
		    }
		}
		break;
	
	      case ")" :
		parenCnt = parenCnt-1;
		listStr = listStr + ")";
		if ((parenCnt == 0) && (listCnt == listNo)) {
		    // found the end of the list
		    listArr[0] = listStr;
		    listArr[1] = str.substr(i+1);
		    // terminate the loop
		    i = str.length;
		}
		break;
	      default :
		if (parenCnt > 0) listStr = listStr+chr;
	    }	
	}
    }
    else {
	listArr[0] = "";
	listArr[1] = str;
    }
    return listArr;
}


// ------------------------------------------------------------
// function isOptional()
// 	Return true if an attribute statment is OPTIONAL
//      It will be the first word after the colon.
// ------------------------------------------------------------
function isOptional(statement) {
    statement = getAfterColon(statement);
    var word = getWord(1,statement);
    var result = false;
    if (word=="OPTIONAL") result = true;
    return (result);
}


// ------------------------------------------------------------
// function isRedeclared()
//	Return true if statement contains "SELF"
// ------------------------------------------------------------
function isRedeclared(statement) {
    var result = false;
    var reg = /\bSELF\b/i;
    var token = statement.match(reg);
    if (token) result = true;
    return (result);
}


// ------------------------------------------------------------
// function getAfterColon()
//	Return everything after the : removing the ;
// ------------------------------------------------------------
function getAfterColon(statement) {
    var expr = "";
    var reg  = /\:/;
    var pos  = statement.search(reg);
    if (pos) {
	expr = statement.substr(pos+1);
	expr = expr.replace(/^\s/g,"");
	expr = expr.replace(/\;/,"");
    }
    return(expr);
}


// ------------------------------------------------------------
// function getAfterEquals()
// 	Return everything after the := removing the ;
// ------------------------------------------------------------
function getAfterEquals(statement) {
    var expr = "";
    var pos  = -1;
    var reg  = /\=/;
    var pos  = statement.search(reg);
    if (pos != -1) {
	expr = statement.substr(pos+1);
	expr = expr.replace(/^\s/g,"");
	expr = expr.replace(/\;/,"");
    }
    return(expr);
}


// ------------------------------------------------------------
// function readComment()
// 	Return a statement terminated by ;
//      calls recursive function readCommentRecurse() to get the comment
// ------------------------------------------------------------
function readComment(line, ts) {
    var reg = /^\s*\(\*/;
    var pos = line.search(reg);
    var comment = -1;
    
    if (pos != -1) {
	//line = line.replace(/\(\*/,"");
	comment = readCommentRecurse(line, ts);
    }
    return(comment);
}


// ------------------------------------------------------------
// function readCommentRecurse()
// 	Recursive function called by readComment()
// ------------------------------------------------------------
function readCommentRecurse(line, ts) {
    var comment = "";
    if (ts.AtEndOfStream) {
	return(line);
    }	
    else {
	var reg = /\*\)/;
	var pos = line.search(reg);
	if (pos == -1) {
	    comment = line + "\n" + readCommentRecurse(ts.ReadLine(), ts);
	}
	else {
	    //comment = line.substr(0,pos);
	    comment = line;
	}
	return(comment);
    }
}


// ------------------------------------------------------------
// function readToken()
// 	Return the first word in the line or (*
// ------------------------------------------------------------
function readToken(line) {
    // get the first word
    var reg = /^\s*\b\w*\b/i;
    var token = line.match(reg);

    if (!token) {
	// Not a word, so check for comment
		 reg = /^\s*\(\*/;
		 token = line.match(reg);
    }
    if (!token) {
	// Not a word, so check for comment
		 reg = /^\s*[--]/;
		 token = line.match(reg);
    }
    if (!token) {
	// Not a word, so check for {} statement
	reg = /^\{/;
	token = line.match(reg);	
    }
    if (token) {
	token = token[0].replace(/\s/g,"");
	token = token.toString();
	
	switch (token) {
	    case "USE" :
	     	var reg = /^\s*USE FROM\b/i;
	    	token = line.match(reg);
	    		
	    	if (token) {
			token = token[0].replace(/\s/g,"");
			token = token.toString();
	    	}
	    	else {
			token = -1;	
	    	}
	    	break;
		
	    case "REFERENCE" :
	    	var reg = /^\s*REFERENCE FROM\b/i;
	    	token = line.match(reg);
	    	if (token) {
		    token = token[0].replace(/\s/g,"");
		    token = token.toString();
	    	}
	    	else {
		    token = -1;
	    	}
	    	break;
	    		
	    default :
	    	break;
	}
	
    }
    else {
	//debug("tt:"+token+":"+line);
	token = -1;
    }
    return(token);
}


// ------------------------------------------------------------
// function trim()
//	Trim white space from both ends of a string
// ------------------------------------------------------------
function trim(s) { 
    return s.replace(/(^\s+)|(\s+$)/g, "")
}



// ------------------------------------------------------------
// function cleanexpFileHeader()
// 	Write the cleanexp file header
// ------------------------------------------------------------
function cleanexpFileHeader(outTs) {
    outTs.Writeline("(* cleaned up *)");
}

// ----------------------------------------------------------
// function tidyExpression()
// 	Replace all <> in the expression
// ------------------------------------------------------------
function tidyExpression(expr) {
    expr = trim(expr);
    expr = expr.replace(/>/g,"&gt;");
    expr = expr.replace(/</g,"&lt;");
    expr = expr.replace(/\"/g,"&quot;");
    
    // SPF: hack - not correct way to handle SELF\
//    expr = expr.replace(/^SELF\\/,"");
    
     // replace double space with single space
    while (expr.search(/  /) != -1) {
        expr = expr.replace(/  /g," ");
    }
    
    // remove spaces around parens
    expr = expr.replace(/\( /g,"(");
    expr = expr.replace(/ \)/g,")");
    
    return(expr);
}


// ------------------------------------------------------------
// function Output2cleanexp()
//	this is the main routine
//	read express file line, process, write to xml file
// ------------------------------------------------------------
function Output2cleanexp(expFile, cleanexpFile, partnumber) {
    userMessage("Reading EXPRESS from file: " + expFile);
    userMessage("");
    userMessage("      Writing XML to file: " + cleanexpFile);
    
    var fso   = new ActiveXObject("Scripting.FileSystemObject");
    var expF  = fso.GetFile(expFile);
    var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);

    var cleanexpF  = fso.CreateTextFile(cleanexpFile,true);
    cleanexpF.Close();
    cleanexpF      = fso.GetFile(cleanexpFile);
    var cleanexpTs = cleanexpF.OpenAsTextStream(ForWriting, TristateUseDefault);

    cleanexpFileHeader(cleanexpTs);

   
    while (!expTs.AtEndOfStream) {

	var l = readNextLine(expTs);
	var statement = readStatement(l,expTs);
	cleanexpTs.WriteLine(normaliseStatement(statement));
    }//end while

    expTs.Close();    
    cleanexpTs.Close();
}//end function


// --------------------------------------------------------------------
// Main program for generating the XML for the ARM express of module
// --------------------------------------------------------------------
function MainArm() {	
    var cArgs = System.Environment.GetCommandLineArgs();
    
    if (cArgs.length != 1) {
	ErrorMessage("Incorrect arguments\ncscript express2xml.js <module>" );	
	return(false);
    }
    
    var module = cArgs(0);
    currentExpFile = '../data/modules/'+module+'/arm.exp';
    var xmlFile = '../data/modules/'+module+'/arm.xml';
    var partNo = "";
    Output2cleanexp(currentExpFile, xmlFile, partNo);
}


// ------------------------------------------------------------
// Main program for generating the XML for the MIM express of module
// -----------------------------------------------------------
function MainMim() {
    var cArgs = System.Environment.GetCommandLineArgs();
    
    if (cArgs.length != 1) {
	ErrorMessage("Incorrect arguments\ncscript express2cleanexp.js <module>" );	
	return(false);
    }

    var module = cArgs(0);
    currentExpFile = '../data/modules/'+module+'/mim.exp';
    var xmlFile = '../data/modules/'+module+'/mim.xml';
    var partNo = "";
    Output2cleanexp(currentExpFile, xmlFile, partNo);
}


// ------------------------------------------------------------
// Main program
// -----------------------------------------------------------
function Main() {
    //get the command line arguments
    var cArgs = WScript.Arguments;
    
    // debug(cArgs.length);
    
    // for (var i=0; i<cArgs.length; i++){
    //    WScript.Echo (cArgs(i));
    //}

    if ( !((cArgs.length == 1) || (cArgs.length == 2) || (cArgs.length == 3)) )  {
	var msg="Incorrect arguments\n"+
	    "  express_clean.js <express>\nOr\n"+
	    "  express_clean.js <module> arm\nOr\n"+
	    "  express_clean.js <module> arm_lf\nOr\n"+
	    "  express_clean.js <module> mim\nOr\n"+
	    "  express_clean.js <module> mim_lf\nOr\n"+
	    "  express_clean.js <module> module\nOr\n"+
	    "  express_clean.js <resource> resource\n";
	ErrorMessage(msg);
	return(false);
    }
    userMessage("Warning: \n This script does not do any EXPRESS parsing, so if there are\n errors in the EXPRESS, then unexpected output may be produced.\n Furthermore, as the program is a string parser, assumptions have\n been made about the layout of the EXPRESS.\n It is advisable to display the resulting XML and compare with\n the orginal EXPRESS.\n\n");
    var module, expFile, type;
    if (cArgs.length > 1) {
	switch(cArgs(1)) {
	case "arm" :
	    var module = cArgs(0);
	    expFile = '../data/modules/'+module+'/arm.exp';
	    currentExpFile=expFile;
	    var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile);
	    break;

	case "mim" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/mim.exp';
	    currentExpFile=expFile;
	    var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);
	    break;

	case "mim_lf" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/mim_lf.exp';
	    currentExpFile=expFile;
	    var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);
	    break;

	case "arm_lf" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/arm_lf.exp';
	    currentExpFile=expFile;
	    var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);
	    break;


	case "arm_lf_orig" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/arm_lf_orig.exp';
	    currentExpFile=expFile;
	    var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);
	    break;

	case "resource" :
	    var resource = cArgs(0);	    
	    expFile = '../data/resources/'+resource+'/'+resource+'.exp';
	    currentExpFile=expFile;
	    var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    
	    if (cArgs.length>2) {
		var partNo = cArgs(2);
		Output2cleanexp(expFile, cleanexpFile, partNo);
	    } 
	    else {
		var partNo = "";
	        Output2cleanexp(expFile, cleanexpFile, partNo);
	    }
	    break;

	case "module" :
	    var module = cArgs(0);   
	    var cleanexpFile;
	    
	    // arm
	    expFile = '../data/modules/'+module+'/arm.exp';
	    currentExpFile=expFile;
	    cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);

	    // mim
	    expFile = '../data/modules/'+module+'/mim.exp';
	    currentExpFile=expFile;
	    cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);

	    // mim long form
	    expFile = '../data/modules/'+module+'/mim_lf.exp';
	    currentExpFile=expFile;
	    cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	    var partNo = "";
	    Output2cleanexp(expFile, cleanexpFile, partNo);
	    break;
	}//end switch
    } 
    else {
	expFile = cArgs(0)+".exp";
	currentExpFile=expFile;
	var cleanexpFile = expFile.replace("\.exp","_clean\.exp");
	var partNo = "";
	Output2cleanexp(expFile, outexpFile);
    }
}//end function


// ---------------------------------------------------------------
// Call Main program
// ---------------------------------------------------------------
Main();
