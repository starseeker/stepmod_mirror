//$Id: express2xml.js,v 1.2 2001/11/21 15:38:19 robbod Exp $
// JScript to convert an Express file to an XML file
// cscript express2xml.js <express.exp>
// cscript express2xml.js <module> arm
// cscript express2xml.js <module> mim
// cscript express2xml.js <module> mim_lf
// cscript express2xml.js <module> module
// cscript express2xml.js <resource> resource
// e.g
// cscript express2xml.js part_and_version_identification arm

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
String.prototype.trim = function()
{
    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    return this.replace(/(^\s*)|(\s*$)/g, "");
}



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


// Return a statement terminated by ;
function readStatement(line, ts) {
    var statement = "";
    var pos;

    // remove any trailing -- comments
    pos = line.search("--");
    if (pos != -1) {
	line = line.substr(0,pos);
    }
    if (ts.AtEndOfStream) 
	return(line);
    else {
	pos = line.search(";");
	if (pos == -1) {
	    statement = line + readStatement(ts.ReadLine(), ts);
	} else {
	    statement = line.substr(0,pos+1);
	}
	return(statement);
    }
}


// Separate all , and ( ) with whitespace, remove all tabs etc
function normaliseStatement(statement) {
    statement = statement.replace(/,/g," , ");
    statement = statement.replace(/;/g," ;");
    statement = statement.replace(/\[/g," [ ");
    statement = statement.replace(/\]/g," ] ");
    statement = statement.replace(/\(/g," ( ");
    statement = statement.replace(/\)/g," ) ");
    statement = statement.replace(/\t/g," ");
    statement = statement.replace(/^\s*/g,"");
    while (statement.search(/  /) != -1) {
	statement = statement.replace(/  /g," ");
    }
    
    return(statement);
}

function getWord(n, statement) {
    statement = normaliseStatement(statement);
    var arr = statement.split(" ");
    var word = arr[n-1];
    word = word.replace(/:/,"");
    return(word);
}

// Return the contents of everything enclosed in ()
function getList(statement) {
    var list = normaliseStatement(statement);
    var reg = /\(.*\)/;    
    list = list.match( reg );
    if (list) {
	list = list.toString();
	// remove the ()
	list = list.substr(2,list.length-4);
	// remove , 
	list = list.replace(/ , /g," ");
    }
    return (list);
}

//Given a statement, extract the (list) into an array
function list2array(statement) {
    var arr;
    var list = getList(statement);
    if (list) {	
	// remove all the whitespace
	//list = list.replace(/ /g,"");	
	arr = list.split(" ");
    }
    return(arr)
}

// Given a string, return and array. 
// Array[0] is the nth list in the string where n is the listNo
// Array[1] is the rest of the strig after the list
function splitList(str, listNo)
{
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
    } else {
	listArr[0] = "";
	listArr[1] = str;
    }
    return listArr;
}


//Rteurn true if statment contains OPTIONAL
function isOptional(statement) {
    var result = false;
    var reg = /\bOPTIONAL\b/;
    var token = statement.match(reg);
    if (token) result = true;
    return (result);
}


// Return everything after the : removing the ;
function getAfterColon(statement) {
    var reg = /:/;
    var pos = statement.search(reg);
    if (pos) {
	expr = statement.substr(pos+1);
	expr = expr.replace(/^\s/g,"");
	expr = expr.replace(/;/,"");
    }
    return(expr);
}


// Return everything after the := removing the ;
function getAfterEquals(statement) {
    var reg = /=/;
    var pos = statement.search(reg);
    if (pos) {
	expr = statement.substr(pos+2);
	expr = expr.replace(/^\s/g,"");
	expr = expr.replace(/;/,"");
    }
    return(expr);
}

// Return a statement terminated by ;
// calls recursive function to get the comment
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

// Recursive function called by readComment.
function readCommentRecurse(line, ts) {
    var comment = "";
    if (ts.AtEndOfStream) 
	return(line);
    else {
	var reg = /\*\)/;
	var pos = line.search(reg);
	if (pos == -1) {
	    comment = line + "\n" + readCommentRecurse(ts.ReadLine(), ts);
	} else {
	    //comment = line.substr(0,pos);
	    comment = line;
	}
	return(comment);
    }
}

// Return the first word in the line or (*
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
	// Not a word, so check for {} statement
	reg = /^\{/i;
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
	    } else {
		token = -1;	
	    }
	    break;
	case "REFERENCE" :
	    var reg = /^\s*REFERENCE FROM\b/i;
	    token = line.match(reg);
	    if (token) {
		token = token[0].replace(/\s/g,"");
		token = token.toString();
	    } else {
		token = -1;
	    }
	    break;
	default :
	    break;
	}
    } else {
	//debug("tt:"+token+":"+line);
	token = -1;
    }
    return(token);
}

function xmlXMLhdr(outTs) {
    outTs.Writeline("<?xml version=\"1.0\"?>");
    outTs.Writeline("<!-- $Id: express2xml.js,v 1.2 2001/11/21 15:38:19 robbod Exp $ -->");
    outTs.Writeline("<?xml-stylesheet type=\"text\/xsl\" href=\"..\/..\/..\/xsl\/express.xsl\"?>");
    outTs.Writeline("<!DOCTYPE express SYSTEM \"../../../dtd/express.dtd\">");

}

// Return the revision of this application
function getApplicationRevision() {
    // get CVS to set the revision in the variable, then extract the 
    // revision from the string.
    var appCVSRevision = "$Revision: 1.2 $";
    var appRevision = appCVSRevision.replace(/Revision:/,"");
    appRevision = appRevision.replace(/\$/g,"");
    appRevision = appRevision.trim();
    return(appRevision);
}

function xmlApplication(outTs) {
    var appRevision = getApplicationRevision();
    xmlOpenElement("<application",outTs);
    xmlAttr("name","express2xml.js",outTs);
    xmlAttr("owner","Eurostep Limited",outTs);
    xmlAttr("url","http://www.eurostep.com",outTs);
    xmlAttr("version",appRevision,outTs);
    xmlAttr("source",currentExpFile,outTs);
    xmlCloseAttr(outTs);
    outTs.WriteLine();
}


// Open the schema XML element
function xmlOpenSchema(statement, outTs) {
    var schema = getWord(2,statement);
    xmlOpenElement("<schema name=\""+schema,outTs);
    outTs.WriteLine("\">");
}

// Close the schema XML element
function xmlCloseSchema(outTs) {
    xmlCloseElement("</schema>",outTs);
    outTs.WriteLine("");
}

function getAbstractSuper(statement) {
    statement = normaliseStatement(statement);
    var reg = /.*ABSTRACT SUPERTYPE\b/i;
    var token = statement.match(reg);
    return(token);    
}

function xmlAbstract(outTs) {
    xmlAttr("abstract.supertype", "YES", outTs);
}

// Return the supertype expression.
// Format may be:
//  SUPERTYPE OF (ONEOF(next_assembly_usage_occurrence,
//              specified_higher_usage_occurrence,promissory_usage_occurrence))
//  SUBTYPE OF (product_definition_usage);
//
function xmlSuperExpression(statement, outTs) {
    var reg = /.*SUPERTYPE OF/i;
    var token = statement.match(reg);
    var superExpr = "";
    if (token) {
	// remove the SUPERTYPE OF words
	superExpr = statement.replace(reg,"");
	// get the list after the SUPERTYPE OF words
	var listArr = splitList(superExpr,1);
	superExpr = listArr[0];
	reg = /;/;
	superExpr = superExpr.replace(reg,"");
	xmlAttr("super.expression", superExpr, outTs);
    }
}


function xmlSupertypes(statement, outTs) {
    var reg = /.*SUBTYPE OF\b/i;
    var token = statement.match(reg);
    var token = statement.match(reg);
    var supertypes = "";
    if (token) {
	supertypes = statement.replace(reg,"");
	reg = /;/;
	supertypes = supertypes.replace(reg,"");
	supertypes = getList(supertypes);
	xmlAttr("supertypes", supertypes, outTs);
    }
}


// Close the entity XML element
function xmlOpenEntity(statement,outTs,expTs) {
    xmlOpenElement("<entity",outTs);
    var entity = getWord(2,statement);
    xmlAttr("name",entity,outTs);
    if (getAbstractSuper(statement)) xmlAbstract(outTs);
    xmlSuperExpression(statement,outTs);
    xmlSupertypes(statement,outTs);
    outTs.WriteLine(">");
    xmlEntityStructure(outTs, expTs, "explicit");
}


// Close the entity XML element
function xmlCloseEntity(outTs) {
    xmlCloseElement("</entity>",outTs);
    outTs.WriteLine("");	
}


function xmlEntityStructure(outTs,expTs,mode) {
    var l = expTs.ReadLine();
    lNumber = expTs.Line;
    var token = readToken(l);
    switch( token ) {
    case "DERIVE" :	
	xmlEntityStructure(outTs,expTs,"derive");
	break;
    case "INVERSE" :
	xmlEntityStructure(outTs,expTs,"inverse");
	break;
    case "WHERE" :
	xmlEntityStructure(outTs,expTs,"where");
	break;
    case "UNIQUE" :
	xmlEntityStructure(outTs,expTs,"unique");
	break;
    case "END_ENTITY" :
	xmlCloseEntity(outTs);	
	break;
    default :
	// output the attribute, rule etc
	var statement = readStatement(l,expTs);
	var name = getWord(1,statement);
	var rest = getAfterColon(statement);
	var reg = /^\s*/;
	rest = rest.replace(reg,"");
	switch( mode ) {
	case "explicit" :	
	    xmlOpenElement("<explicit",outTs);
	    xmlAttr("name",name,outTs);
	    if (isOptional(statement)) {
		reg = /\bOPTIONAL\b/;
		rest = rest.replace(reg,"");
		reg = /^\s*/;
		rest = rest.replace(reg,"");
		xmlAttr("optional","YES",outTs);
	    }
	    outTs.WriteLine(">");
	    xmlUnderlyingType(rest,outTs);
	    xmlCloseElement("</explicit>",outTs);
	    // process the next attribute
	    xmlEntityStructure(outTs,expTs,mode);
	    break;

	case "derive" :
	    xmlOpenElement("<derived",outTs);
	    var expression = getAfterEquals(rest);
	    var reg = /^\s*/;
	    expression = expression.replace(reg,"");
	    expression = tidyExpression(expression);
	    typedef = rest.replace(/:=.*/,"");
	    xmlAttr("name",name,outTs);
	    xmlAttr("expression",expression,outTs);
	    outTs.WriteLine(">");
	    xmlUnderlyingType(typedef,outTs);
	    xmlCloseElement("</derived>",outTs);
	    // process the next attribute
	    xmlEntityStructure(outTs,expTs,mode);
	    break;
	case "inverse" : 	    
	    var entity = getInverseEntity(statement);
	    var attribute = getInverseAttr(statement);
	    xmlOpenElement("<inverse",outTs);	
	    xmlAttr("name",name,outTs);
	    xmlAttr("entity",entity,outTs);
	    xmlAttr("attribute",attribute,outTs);
	    outTs.WriteLine(">");
	    xmlAggregate(statement, outTs);
	    // redeclaration
	    xmlCloseElement("</inverse>",outTs);
	    // process the next attribute
	    xmlEntityStructure(outTs,expTs,mode);
	    break;
	case "where" : 
	    //var expr = getAfterColon(rest);
	    var expr = rest;
	    var reg = /^\s*/;
	    expr = expr.replace(reg,"");
	    expr = tidyExpression(expr);
	    xmlOpenElement("<where",outTs);	
	    xmlAttr("label",name,outTs);
	    xmlAttr("expression",expr,outTs);
	    outTs.WriteLine(">");
	    xmlCloseElement("</where>",outTs);
	    // process the next attribute
	    xmlEntityStructure(outTs,expTs,mode);
	    break;
	case "unique" :	
	    xmlUnique(statement, outTs);
	    // process the next attribute
	    xmlEntityStructure(outTs,expTs,mode);
	    break;
	}
    }
    
}

function xmlUnique(statement, outTs) {
    var name = getWord(1,statement);
    xmlOpenElement("<unique",outTs);	
    xmlAttr("label",name,outTs);
    outTs.WriteLine(">");

    var uniqueAttrs = getAfterColon(statement);
    var reg = /^\s*|;|/;
    uniqueAttrs = uniqueAttrs.replace(reg,"");
    // remove all the whitespace
    uniqueAttrs = uniqueAttrs.replace(/ /g,"");	
    var arr = uniqueAttrs.split(",");
    for (var i=0; i<arr.length; i++) {
	xmlOpenElement("<unique.attribute",outTs);
	xmlAttr("attribute",arr[i],outTs);
	xmlCloseAttr(outTs);
    }
    xmlCloseElement("</unique>",outTs);    

}


function getInverseEntity(statement) {
    statement=normaliseStatement(statement);
    var pos = statement.search(/\bOF\b/);
    var entity = statement.substr(pos+3);
    entity = getWord(1,entity);
    return(entity);
}

function getInverseAttr(statement) {
    statement=normaliseStatement(statement);
    var pos = statement.search(/\bFOR\b/);
    var attr = statement.substr(pos+4);
    attr = getWord(1,attr);
    return(attr);
}



// Output elements for aggregate
function xmlAggregate(statement, outTs) {
    var reg = /\bSET|BAG|LIST|ARRAY\b/;
    var agg = statement.match(reg);
    if (agg) {
	var opos = statement.search(/\[/);
	var cpos = statement.search(/\]/);
	var bounds = statement.substr(opos+1, cpos-opos-1);
	bounds = bounds.replace(/\s/g,"");
	var lower = bounds.match(/.*:/);
	lower = lower[0].replace(/:/,"");
	var upper = bounds.match(/:.*/);
	upper = upper[0].replace(/:/,"");
	xmlOpenElement("<inverse.aggregate",outTs);
	xmlAttr("type",agg,outTs);
	xmlAttr("lower",lower,outTs);
	xmlAttr("upper",upper,outTs);
	xmlCloseAttr(outTs);
    }
}

function xmlInterface(statement, outTs) {
    statement = normaliseStatement(statement);
    xmlOpenElement("<interface",outTs);
    var kind = getWord(1,statement).toLowerCase();
    xmlAttr("kind",kind,outTs);
    var schema = getWord(3,statement);
    xmlAttr("schema",schema,outTs);
    outTs.WriteLine(">");
    var lArr = list2array(statement);
    if (lArr) {
	for (var i=0; i<lArr.length; i++) {
	    xmlOpenElement("<interfaced.item",outTs);		
	    xmlAttr("name",lArr[i],outTs);
	    xmlCloseAttr(outTs);
	}
    }
    xmlCloseElement("</interface>",outTs);
    outTs.WriteLine("");
}

function xmlUnderlyingType(statement,outTs) {
    statement = normaliseStatement(statement);
    var reg = /\bSET|BAG|LIST|ARRAY\b/;
    var agg = statement.match(reg);
    if (agg) {
	var opos = statement.search(/\[/);
	var cpos = statement.search(/\]/);
	var bounds = null;
	if (opos != -1) {
	    bounds = statement.substr(opos+1, cpos-opos-1);
	    bounds = bounds.replace(/\s/g,"");
	    var lower = bounds.match(/.*:/);
	    lower = lower[0].replace(/:/,"");
	    var upper = bounds.match(/:.*/);
	    upper = upper[0].replace(/:/,"");
	}
	var pos = statement.search(/\bOF\b/i);
	var typename = statement.substr(pos+3);
	typename = getWord(1,typename);

	// need to do OPTIONAL and UNIQUE ??
	xmlOpenElement("<aggregate",outTs);
	xmlAttr("type",agg,outTs);
	if (bounds) {
	    xmlAttr("lower",lower,outTs);
	    xmlAttr("upper",upper,outTs);
	}
	xmlCloseAttr(outTs); 
	xmlOpenElement("<typename",outTs);
	xmlAttr("name",typename,outTs);
	xmlCloseAttr(outTs);
	return;
    }
    
    reg = /\bBINARY|BOOLEAN|GENERIC|GENERICENTITY|INTEGER|LOGICAL|NUMBER|REAL|STRING\b/;
    var type = statement.match(reg);
    if (type) {
	xmlOpenElement("<builtintype",outTs);
	xmlAttr("type",type,outTs);
	xmlCloseAttr(outTs);
	return;
    }
    xmlOpenElement("<typename",outTs);
    xmlAttr("name",statement,outTs);
    xmlCloseAttr(outTs);
}

//Replace all <> in the expression
function tidyExpression(expr) {
    expr = expr.replace(/>/g,"&gt;");
    expr = expr.replace(/</g,"&lt;");
    expr = expr.replace(/\"/g,"&quot;");
    return(expr);
}

// Return the BASED_ON type
function getExtensibleBasedOn(extensibleStatement) {
    extensibleStatement = normaliseStatement(extensibleStatement);
    var type = -1;
    var pos = extensibleStatement.search("BASED_ON");
    if (pos != -1) {
	// get the word after BASED_ON
	extensibleStatement = extensibleStatement.substr(pos+9);
	pos = extensibleStatement.search(" ");
	type = extensibleStatement.substr(0,pos);
    }
    return(type);
}

//	genericentity (YES | NO) "NO"
function xmlSelect(statement,outTs) {    
    xmlOpenElement("<select",outTs);

    var reg = /\bEXTENSIBLE\b/;
    if (statement.match(reg)) {
	xmlAttr("extensible","YES",outTs);
    }
    var based_on = getExtensibleBasedOn(statement);
    if (based_on != -1) {
	xmlAttr("basedon",based_on,outTs);
    }
    
    var selectItems = getList(statement);
    xmlAttr("selectitems",selectItems,outTs);

    outTs.WriteLine(">");
    xmlCloseElement("</select>",outTs);
}

function xmlEnumeration(statement,outTs) {
    xmlOpenElement("<enumeration",outTs);

    var reg = /\bEXTENSIBLE\b/;
    if (statement.match(reg)) {
	xmlAttr("extensible","YES",outTs);
    }
    var based_on = getExtensibleBasedOn(statement);
    if (based_on != -1) {
	xmlAttr("basedon",based_on,outTs);
    }

    var enumItems = getList(statement);
    xmlAttr("items",enumItems,outTs);

    outTs.WriteLine(">");
    xmlCloseElement("</enumeration>",outTs);
    outTs.WriteLine("");
}

// Still to do ????
//	width CDATA #IMPLIED
//	fixed (YES | NO) "NO"
//	precision CDATA #IMPLIED
//	typelabel NMTOKEN #IMPLIED
function xmlBuiltInType(typeType,statement,outTs) {
    xmlOpenElement("<builtintype",outTs);
    xmlAttr("type",typeType,outTs);
    outTs.WriteLine(">");
    xmlCloseElement("</builtintype>",outTs);
    outTs.WriteLine("");
}

function getType(statement) {
    var reg = /\bSELECT|ENUMERATION|BINARY|BOOLEAN|INTEGER|LOGICAL|NUMBER|REAL|STRING\b/;
    var type = statement.match(reg);
    if (type) 
	type = type.toString();
    else 
	{
	    type = getAfterEquals(statement);
	    var reg = /^\s*/;
	    type = type.replace(reg,"");
	    reg = /;/;
	    type = type.replace(reg,"");
	}
    return(type);
}


function xmlType(statement,outTs) {
    var typeName = getWord(2,statement);
    xmlOpenElement("<type name=\""+typeName,outTs);
    outTs.WriteLine("\">");
    var typeType = getType(statement);
    switch( typeType ) {
    case "SELECT" :
	xmlSelect(statement,outTs);
	break;
    case "ENUMERATION" :
	xmlEnumeration(statement,outTs);
	break;
    case "BINARY" :
	xmlBuiltInType(typeType,statement,outTs);
	break;
    case "BOOLEAN" :
	xmlBuiltInType(typeType,statement,outTs);
	break;
    case "INTEGER" :
	xmlBuiltInType(typeType,statement,outTs);
	break;
    case "LOGICAL" :
	xmlBuiltInType(typeType,statement,outTs);
	break;
    case "NUMBER" :
	xmlBuiltInType(typeType,statement,outTs);
	break;
    case "REAL" :
	xmlBuiltInType(typeType,statement,outTs);
	break;
    case "STRING" :
	xmlBuiltInType(typeType,statement,outTs);
	break;	
    default :	
	xmlOpenElement("<typename",outTs);
	xmlAttr("name",typeType,outTs);
	xmlCloseAttr(outTs);
	break;
    }
    outTs.WriteLine("");
}

//a function Object
function FunctionObj(name) {
    this.name = name;
    this.paramStr ="";
    this.retStr = "";
    this.algorithm = "";
}

FunctionObj.prototype.loadParamList = function (paramList,expTs,outTs) 
{
    var closeParen = paramList.search(/\)/);
    if (closeParen != -1) {
	// found the end of the parameter list
	retStr = paramList.replace(/.*\)/,"");
	this.loadRtnStr(retStr,expTs,outTs);
	paramList = paramList.replace(/\).*/,"");
	paramList = paramList.replace(/.*\(/,"");
	this.paramStr = paramList;
	this.loadAlgorithm("",expTs,outTs);
    } else {
	var line = expTs.ReadLine();
	lNumber = expTs.Line;
	paramList = paramList+line;
	this.loadParamList(paramList,expTs,outTs);
    }    
}

FunctionObj.prototype.xmlParamList = function (outTs) 
{
    this.paramStr = this.paramStr.trim();
    var paramArr1 = this.paramStr.split(";");
    for (var i=0; i<paramArr1.length; i++) {
	// there may be more than one parameter with the same type definition
	// FUNCTION first_proj_axis(z_axis,arg : direction) : direction;
	var params = paramArr1[i].replace(/:.*/,"");
	var paramArr2 = params.split(",");	
	//var 
	var typedef = paramArr1[i].substring(params.length);
	typedef = typedef.trim();
	// remove the :
	typedef = typedef.substring(1).trim();
	for (var j=0; j<paramArr2.length; j++) {
	    var param = paramArr2[j].trim();
	    xmlOpenElement("<parameter",outTs);		
	    xmlAttr("name",param,outTs);
	    outTs.WriteLine(">");
	    xmlUnderlyingType(typedef,outTs);
	    xmlCloseElement("</parameter>",outTs);
	}
    }
}


FunctionObj.prototype.loadRtnStr = function (retStr,expTs,outTs) 
{
    this.rtnStr = readStatement(retStr,expTs);
    this.rtnStr = normaliseStatement(this.rtnStr);
    this.rtnStr = this.rtnStr.trim();
    this.rtnStr = this.rtnStr.replace(/;/g,"");
    this.rtnStr = this.rtnStr.replace(/^:/g,"");
    this.rtnStr = this.rtnStr.trim();
}


FunctionObj.prototype.xmlRtnStr = function (outTs)
{
    xmlUnderlyingType(this.rtnStr,outTs);	    
}


FunctionObj.prototype.loadAlgorithm = function(algoStr,expTs,outTs)
{
    var l = expTs.ReadLine();
    lNumber = expTs.Line;
    var reg = /\bEND_FUNCTION/;
    if (l.match(reg)) {
	this.algorithm = algoStr+"\n";
    } else {
	algoStr = algoStr+"\n"+l;
	this.loadAlgorithm(algoStr,expTs,outTs);
    }
}

FunctionObj.prototype.xmlAlgorithm = function(outTs)
{
    xmlOpenElement("<algorithm>",outTs);
    outTs.Write(tidyExpression(this.algorithm));
    xmlCloseElement("</algorithm>",outTs);
    outTs.WriteLine("");
}

function xmlFunction(line,expTs,outTs) {
    var name = getWord(2,line);
    var fnObj = new FunctionObj(name);
    fnObj.loadParamList(line,expTs,outTs);
    xmlOpenElement("<function",outTs);
    xmlAttr("name",fnObj.name,outTs);
    outTs.WriteLine(">");
    fnObj.xmlRtnStr(outTs);
    fnObj.xmlParamList(outTs);
    fnObj.xmlAlgorithm(outTs);
    xmlCloseElement("</function>",outTs);
    outTs.WriteLine("");
}

function loadRuleBody(body,expTs)
{
    var l = expTs.ReadLine();
    lNumber = expTs.Line;
    var reg = /\bEND_RULE/;
    if (l.match(reg)) {
	body = body+"\n";
    } else {
	body = loadRuleBody(body+"\n"+l, expTs);
    }
    return(body);
}

function xmlRule(line,expTs,outTs) {
    var statement = readStatement(line,expTs);
    var name = getWord(2,line);
    var appliesTo = getList(statement);
    var algorithm = loadRuleBody("",expTs);
    
    xmlOpenElement("<rule",outTs);
    xmlAttr("name",name,outTs);
    xmlAttr("appliesto",appliesTo,outTs);
    outTs.WriteLine(">");
    xmlOpenElement("<algorithm>",outTs);
    outTs.Write(tidyExpression(algorithm));
    xmlCloseElement("</algorithm>",outTs);
    outTs.WriteLine("");
    xmlCloseElement("</rule>",outTs);
    outTs.WriteLine("");
}

function xmlOpenElement(xmlElement, outTs) {
    var txt = indent+xmlElement;
    outTs.Write(txt);
    indent = indent+"  ";
}

function xmlCloseElement(xmlElement, outTs) {
    if (indent.length >= 2) {
	indent = indent.substr(2);
    } else {
	indent = indent+"-------";
    }
    var txt = indent+xmlElement;
    outTs.WriteLine(txt);
}

// Output an indented attribute.
function xmlAttr(name, value, outTs) {
    var txt = indent+name+"=\""+value+"\"";
    outTs.WriteLine();
    outTs.Write(txt);
}

function xmlCloseAttr(outTs) {
    outTs.WriteLine("/>");    
    if (indent.length >= 2) {
	indent = indent.substr(2);
    } else {
	indent = indent+"-------";
    }
}

function Output2xml(expFile, xmlFile) {
    userMessage("Reading EXPRESS: " + expFile);
    userMessage("Writing XML: " + xmlFile);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var expF = fso.GetFile(expFile);
    var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);

    fso.CreateTextFile(xmlFile,true);
    var xmlF = fso.GetFile(xmlFile);
    var xmlTs = xmlF.OpenAsTextStream(ForWriting, TristateUseDefault);

    xmlXMLhdr(xmlTs);
    xmlOpenElement("<express",xmlTs);
    xmlAttr("language_version","2",xmlTs);
    var rcsdate = "$"+"Date: $";
    xmlAttr("rcs.date",rcsdate,xmlTs);
    var rcsrevision = "$"+"Revision: $";
    xmlAttr("rcs.revision",rcsrevision,xmlTs);
    xmlTs.WriteLine(">");
    xmlTs.WriteLine("");
    xmlApplication(xmlTs);
    while (!expTs.AtEndOfStream)
	{
	    var l = expTs.ReadLine();
	    lNumber = expTs.Line;
	    var token = readToken(l);
	    switch( token ) {
	    case "{" :
		// found: { iso standard 10303 part (11) version (4) }
		// ignore as this is express edition 2 construct
		break;
	    case "SCHEMA" :
		var statement = readStatement(l,expTs);
		xmlOpenSchema(statement,xmlTs);
		break;
	    case "END_SCHEMA" :
		var statement = readStatement(l,expTs);
		xmlCloseSchema(xmlTs);
		break;
	    case "ENTITY" :
		var statement = readStatement(l,expTs);
		xmlOpenEntity(statement,xmlTs,expTs);
		break;
	    case "USEFROM" :
		var statement = readStatement(l,expTs);
		xmlInterface(statement,xmlTs);
		break;
	    case "REFERENCEFROM" :
		var statement = readStatement(l,expTs);
		xmlInterface(statement,xmlTs);
		break;
	    case "TYPE" :	
		var statement = readStatement(l,expTs);
		xmlType(statement,xmlTs);
		break;
	    case "WHERE" :  // only called when in a type definition
		var statement = readStatement(l,expTs);
		var name = getWord(1,statement);
		var expr = getAfterColon(statement);
		var reg = /^\s*/;
		expr = expr.replace(reg,"");
		expr = tidyExpression(expr);
		xmlOpenElement("<where",xmlTs);	
		xmlAttr("label",name,xmlTs);
		xmlAttr("expression",expr,xmlTs);
		xmlTs.WriteLine(">");
		xmlCloseElement("</where>",xmlTs);
		break;
	    case "END_TYPE" :	
		xmlCloseElement("</type>",xmlTs);
		break;
	    case "FUNCTION" :	
		xmlFunction(l,expTs,xmlTs);
		break;
	    case "RULE" :	
		xmlRule(l,expTs,xmlTs);
		break;
	    case "(*" :
		var comment = readComment(l, expTs);
		//userMessage(comment);
		break;
	    default :	
		//debug("default: "+token+"]");
		//userMessage(l);
		break;
	    }

	}
    xmlCloseElement("</express>",xmlTs);
    expTs.Close();    
    xmlTs.Close();
    
}



// ------------------------------------------------------------
// Main program for generating the XML for the ARM express of module
// -----------------------------------------------------------
function MainArm() {
    var cArgs = WScript.Arguments;
    if (cArgs.length != 1) {
	ErrorMessage("Incorrect arguments\ncscript express2xml.js <module>" );	
	return(false);
    }
    var module = cArgs(0);
    currentExpFile = '../data/modules/'+module+'/arm.exp';
    var xmlFile = '../data/modules/'+module+'/arm.xml';
    Output2xml(currentExpFile, xmlFile);
}

// ------------------------------------------------------------
// Main program for generating the XML for the MIM express of module
// -----------------------------------------------------------
function MainMim() {
    var cArgs = WScript.Arguments;
    if (cArgs.length != 1) {
	ErrorMessage("Incorrect arguments\ncscript express2xml.js <module>" );	
	return(false);
    }
    var module = cArgs(0);
    currentExpFile = '../data/modules/'+module+'/mim.exp';
    var xmlFile = '../data/modules/'+module+'/mim.xml';
    Output2xml(currentExpFile, xmlFile);
}


// ------------------------------------------------------------
// Main program
// -----------------------------------------------------------
function Main() {
    var cArgs = WScript.Arguments;
    if ( !((cArgs.length == 1) || (cArgs.length == 2)) )  {
	var msg="Incorrect arguments\n"+
	    "  cscript express2xml.js <express.exp>\nOr\n"+
	    "  cscript express2xml.js <module> arm\nOr\n"+
	    "  cscript express2xml.js <module> mim\nOr\n"+
	    "  cscript express2xml.js <module> mim_lf\nOr\n"+
	    "  cscript express2xml.js <module> module\nOr\n"+
	    "  cscript express2xml.js <resource> resource\n";
	ErrorMessage(msg);
	return(false);
    }
    var module, expFile, type;
    if (cArgs.length == 2) {
	switch(cArgs(1)) {
	case "arm" :
	    var module = cArgs(0);
	    expFile = '../data/modules/'+module+'/arm.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);
	    break;
	case "mim" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/mim.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);
	    break;
	case "mim_lf" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/mim_lf.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);
	    break;
	case "resource" :
	    var resource = cArgs(0);    
	    expFile = '../data/resources/'+resource+'/'+resource+'.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);
	    break;
	case "module" :
	    var module = cArgs(0);   
	    var xmlFile;
	    // arm
	    expFile = '../data/modules/'+module+'/arm.exp';
	    currentExpFile=expFile;
	    xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);

	    // mim
	    expFile = '../data/modules/'+module+'/mim.exp';
	    currentExpFile=expFile;
	    xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);

	    // mim long form
	    expFile = '../data/modules/'+module+'/mim_lf.exp';
	    currentExpFile=expFile;
	    xmlFile = expFile.replace("\.exp","\.xml");
	    Output2xml(expFile, xmlFile);

	    break;
	}
    } else {
	expFile = cArgs(0)+".exp";
	currentExpFile=expFile;
	var xmlFile = expFile.replace("\.exp","\.xml");
	Output2xml(expFile, xmlFile);
    }
}


// ------------------------------------------------------------
// Call Main program
// -----------------------------------------------------------
Main();



