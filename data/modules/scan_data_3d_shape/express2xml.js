//  $Id: express2xml.js,v 1.38 2004/08/24 16:58:55 thendrix Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//
//  Other editors:
//	T. Hendrix (aka THX and TEH)(Boeing) 
//	P. Huau (GOSET) for subtype_constraint and algorithms of global rules
//      S. Frechette (NIST)
//
//  Open issues:
//	Script does not handle SELF\ construct correctly - deletes it in most cases
//
//  Recent changes: 2004 summer
// Added handling for type labels in function formal params
// Added handling of constants that are aggregates.
// Fixed abstract supertype in subtype constraints.
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
//    cscript express2xml.js <resource> resource <part number>
//    cscript express2xml.js <reference> reference <directory>
//
//    e.g.,
//    cscript express2xml.js part_and_version_identification arm
//    cscript express2xml.js action_schema resource "ISO 10303-41"
//    cscript express2xml.js pdm_schema_12 reference  "pdm_if"
//             file is  stepmod\pdm_if\pdm_schema_12.exp


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


// Add a functioncalled trim as a method of the prototype 
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
//TEH added     
    statement = statement.replace(/(\w)=/g,"$1 =");
    statement = statement.replace(/=(\w)/g,"= $1");
    statement = statement.replace(/=\'/g,"= \'");
    statement = statement.replace(/:(\?)/g,": $1");
    statement = statement.replace(/:(\w)/g,": $1");
    statement = statement.replace(/(\w):/g,"$1 :");
//end TEH added
    // replace double space with single space
    while (statement.search(/  /) != -1) {
        statement = statement.replace(/  /g," ");
    }
    
    // debug (statement);
    
    return(statement);
}


// ------------------------------------------------------------
// function getWord()
// 	Get the nth word of a string
// ------------------------------------------------------------
function getWord(n, statement) {
    statement = normaliseStatement(statement);
    var arr = statement.split(" ");
    
    //get the nth word
    var word = arr[n-1];
    
    //get rid of any :
    word = word.replace(/\:/,"");
    
    return(word);
}


// ------------------------------------------------------------
// function getList() 
//	Return the contents of everything enclosed in ()
// ------------------------------------------------------------
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
//thx added 20040813	    		
	    case "ABSTRACT" :
	    	var reg = /^\s*ABSTRACT SUPERTYPE\b/i;
	    	token = line.match(reg);
	    	if (token) {
		    token = token[0].replace(/\s*/g,"");
		    token = token.toString();
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
// function xmlFileHeader()
// 	Write the xml file header
// ------------------------------------------------------------
function xmlFileHeader(outTs) {
    outTs.Writeline("<?xml version='1.0' encoding='UTF-8'?>");
    outTs.Writeline("<!-- $Id: express2xml.js,v 1.38 2004/08/24 16:58:55 thendrix Exp $ -->");
    outTs.Writeline("<?xml-stylesheet type=\"text\/xsl\" href=\"..\/..\/..\/xsl\/express.xsl\"?>");
    outTs.Writeline("<!DOCTYPE express SYSTEM \"../../../dtd/express.dtd\">");

}


// ------------------------------------------------------------
// function getApplicationRevision()
//	Return the revision of this application
// ------------------------------------------------------------
function getApplicationRevision() {
    // get CVS to set the revision in the variable, then extract the 
    // revision from the string.
    // SPF: not interacting with CVS
    var appCVSRevision = "$Revision: 1.38 $";
    var appRevision = appCVSRevision.replace(/Revision:/,"");
    appRevision = appRevision.replace(/\$/g,"");
    appRevision = trim(appRevision);
    //appRevision.trim(); // SPF: trim is now a function not a method
    return(appRevision);
}


// ------------------------------------------------------------
// function trim()
//	Trim white space from both ends of a string
// ------------------------------------------------------------
function trim(s) { 
    return s.replace(/(^\s+)|(\s+$)/g, "")
}


// ------------------------------------------------------------
// function xmlApplication() 
// ------------------------------------------------------------
function xmlApplication(outTs) {
    var appRevision = getApplicationRevision();
    xmlOpenElement("<application",outTs);
    xmlAttr("name","express2xml2.js",outTs);
    xmlAttr("owner","Eurostep Limited",outTs);
    xmlAttr("url","http://www.eurostep.com",outTs);
    xmlAttr("version",appRevision,outTs);
    xmlAttr("source",currentExpFile,outTs);
    xmlCloseAttr(outTs);
    outTs.WriteLine();
}


// ------------------------------------------------------------
// function xmlOpenSchema()
//	Open the schema XML element
// ------------------------------------------------------------
function xmlOpenSchema(statement, outTs) {
    var schema = getWord(2,statement);
    xmlOpenElement("<schema name=\""+schema,outTs);
    outTs.WriteLine("\">");
    outTs.WriteLine("");
}


// ------------------------------------------------------------
// function xmlCloseSchema()
//	Close the schema XML element
// ------------------------------------------------------------
function xmlCloseSchema(outTs) {
    xmlCloseElement("</schema>",outTs);
}


// ------------------------------------------------------------
// function xmlConstant()
// ------------------------------------------------------------
function xmlConstant(statement,expTs,outTs) {
    var name;
    var expr;
    var type;
    var arr;
    var line;
    var reg;
    var reg2;
    var reg3;
    var token;
    
    // First time function called line will start with CONSTANT, so remove
    line  = trim(statement);
    
    // remove CONSTANT word
    reg   = /^CONSTANT/i;
    token = line.match(reg);
    if (token) {
	line = line.replace(reg,"");
    }
    
    // split the statement into name, type, expression
    arr   = line.split(":");
    reg2  = /\;|\=/g;
    
    // get name
    name  = arr[0];
    name  = trim(name.replace(reg2,""));
    
    // get type
    type  = arr[1];
    type  = trim(type.replace(reg2,""));
    //get expression
    expr  = arr[2];
    expr  = trim(expr.replace(reg2,""));
    expr = tidyExpression(expr);
    
    xmlOpenElement("<constant name=\""+name+"\"", outTs);
    xmlAttr("expression", expr, outTs);
    outTs.WriteLine(">");
    
    xmlInstanciableType(type,outTs);    

    xmlCloseElement("</constant>",outTs);
    
    //get the next line
    line      = readNextLine(expTs);
    
    var token = readToken(line);
    
    statement = readStatement(line,expTs);

    switch( token ) {
        case "END_CONSTANT" :
	    break;	
        default :			
	// multiple constants may be defined in one CONSTANT statement
	    xmlConstant(statement,expTs,outTs); // recursive call
	    break;
    }
}



function xmlInstanciableType(type,outTs) {
    var typeType = getType(type);
    //debug("St:"+statement);
    //debug("tn:"+typeName);
    //debug("tt:"+typeType);
    
    switch( typeType) {
    case "BINARY" :
	xmlBuiltInType(typeType,type,outTs);
	break;
    case "BOOLEAN" :
	xmlBuiltInType(typeType,type,outTs);
	break;
    case "INTEGER" :
	xmlBuiltInType(typeType,type,outTs);
	break;
    case "LOGICAL" :
	xmlBuiltInType(typeType,type,outTs);
	break;
    case "NUMBER" :
	xmlBuiltInType(typeType,type,outTs);
	break;
    case "REAL" :
	xmlBuiltInType(typeType,type,outTs);
	break;
    case "STRING" :
	xmlBuiltInType(typeType,type,outTs);
	break;	
    case "LIST" :
	xmlUnderlyingType(type,outTs);
	break;
    case "SET" :
	xmlUnderlyingType(type,outTs);
	break;
    case "BAG" :
	xmlUnderlyingType(type,outTs);
	break;
    case "ARRAY" :
	xmlUnderlyingType(type,outTs);
	break;

    default :	
	xmlOpenElement("<typename",outTs);
	xmlAttr("name",type,outTs);
//	xmlAttr("name",typeType,outTs);
	xmlCloseAttr(outTs);
	break;
    }    
    //outTs.WriteLine("");
//    xmlInstanciableType(type,outTs);
}



// ------------------------------------------------------------
// function getAbstractSuper()
// ------------------------------------------------------------
function getAbstractSuper(statement) {
    statement = normaliseStatement(statement);
    var reg = /.*ABSTRACT SUPERTYPE\b/i;
    var token = statement.match(reg);
    return(token);    
}


// ------------------------------------------------------------
// function xmlAbstract()
// ------------------------------------------------------------
function xmlAbstract(outTs) {
    xmlAttr("abstract.supertype", "YES", outTs);
}


// ------------------------------------------------------------
// function xmlSuperExpression()
// 	Return the supertype expression.
// 	  Format may be:
//  	    SUPERTYPE OF (ONEOF(next_assembly_usage_occurrence, specified_higher_usage_occurrence,promissory_usage_occurrence))
//  	    SUBTYPE OF (product_definition_usage);
// ------------------------------------------------------------
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


// ------------------------------------------------------------
// function xmlSupertypes()
// ------------------------------------------------------------
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


// ------------------------------------------------------------
// function xmlOpenEntity()
//	Open the entity XML element
// ------------------------------------------------------------
function xmlOpenEntity(statement,outTs,expTs) {
    xmlOpenElement("<entity",outTs);
    var entity = getWord(2,statement);
//    entity = entity.toLowerCase();
    xmlAttr("name",entity,outTs);
    if (getAbstractSuper(statement)) xmlAbstract(outTs);
    xmlSuperExpression(statement,outTs);
    xmlSupertypes(statement,outTs);
    outTs.WriteLine(">");
    xmlEntityStructure(outTs, expTs, "explicit");
}


// ------------------------------------------------------------
// function xmlCloseEntity
//	Close the entity XML entity
// ------------------------------------------------------------
function xmlCloseEntity(outTs) {
    xmlCloseElement("</entity>",outTs);	
}


// ------------------------------------------------------------
// function xmlEntityStructure()
// ------------------------------------------------------------
function xmlEntityStructure(outTs,expTs,mode) {
    var l = readNextLine(expTs);
    
    //if(mode == "unique") debug("unique: "+l);
    var token = readToken(l)+"";
    
    switch( token ) {
    case "-1" :
	// must have read an empty line
	xmlEntityStructure(outTs,expTs,mode);
	break;
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
	    if (isRedeclared(statement)) {
		name = getRedeclaredAttribute(statement, outTs);
	    }
	    xmlOpenElement("<explicit",outTs);
	    xmlAttr("name",name,outTs);
	    
	    if (isOptional(statement)) {
		reg = /\bOPTIONAL\b/i;
		rest = rest.replace(reg,"");
		reg = /^\s*/;
		rest = rest.replace(reg,"");
		xmlAttr("optional","YES",outTs);
	    }
	    outTs.WriteLine(">");
	    
	    xmlUnderlyingType(rest,outTs);
	    
	    if (isRedeclared(statement)) {
		xmlRedeclaredAttribute(statement, outTs);
	    }

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
	    var typedef = rest.replace(/:=.*/,"");
	    xmlAttr("name",name.replace(/^.*\./,""),outTs);
	    xmlAttr("expression",expression,outTs);
	    outTs.WriteLine(">");
	    xmlUnderlyingType(typedef,outTs);
//TEH added 
	    if (isRedeclared(name)) {
		xmlRedeclaredAttribute(name.replace(/^.*\\/,"").replace(/\.$/,""), outTs);
	    }
//end TEH added
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


// ------------------------------------------------------------
// function: getRedeclaredAttribute()
// 	SELF\Representation.context_of_items : Geometric_coordinate_space;
// 	Return the name of a redeclared attribute 
// ------------------------------------------------------------
function getRedeclaredAttribute(statement, outTs) {
    statement = trim(statement);
    statement = statement.replace(/^.*\./g,"");
    var attr = statement.replace(/\:.*/g,"");
    attr = trim(attr);
    return(attr);
}


// ------------------------------------------------------------
// function: xmlRedeclaredAttribute()
// 	SELF\Representation.context_of_items : Geometric_coordinate_space;
// 	Output a redeclared attribute by matching on SELF\
// ------------------------------------------------------------
function xmlRedeclaredAttribute(statement, outTs) {
    statement = statement.replace(/^\s*SELF\\/,"");
    var entity_ref = statement.replace(/\..*/g,"");
    xmlOpenElement("<redeclaration",outTs);	
    xmlAttr("entity-ref",entity_ref,outTs);
    outTs.WriteLine("/>");    
}


// ------------------------------------------------------------
// function xmlUnique() 
// ------------------------------------------------------------
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
    	
    	//is this the correct way to handle SELF\? SPF
//TEH modified  - need to add entity-ref attr if SELF
	if (isRedeclared(arr[i])){


		var tmp = arr[i].replace(/^.*\./,"");
    		var entity_ref = arr[i].replace(/\..*/g,"").replace(/^SELF\\/,"");

	}
//end TEH modified 
        tmp = arr[i].replace(/^SELF\\/,"");
        
	xmlOpenElement("<unique.attribute",outTs);
	if (isRedeclared(arr[i])){
    		xmlAttr("entity-ref",entity_ref,outTs);
	}
	xmlAttr("attribute",arr[i].replace(/^.*\./,""),outTs);
	xmlCloseAttr(outTs);
    }
    xmlCloseElement("</unique>",outTs);    

}


// ------------------------------------------------------------
// function getInverseEntity()
// ------------------------------------------------------------
function getInverseEntity(statement) {
    statement=normaliseStatement(statement);
    var entity;
    var pos = statement.search(/\bOF\b/i);
    if (pos > 0) {
	entity = statement.substr(pos+3);
	entity = getWord(1,entity);
    } else {
	pos = statement.search(/\:/);
	entity = statement.substr(pos+1);
	entity = getWord(1,entity);
    }
    return(entity);
}


// ------------------------------------------------------------
// function getInverseAttr()
// ------------------------------------------------------------
function getInverseAttr(statement) {
    statement=normaliseStatement(statement);
    var pos = statement.search(/\bFOR\b/i);
    var attr = statement.substr(pos+4);
    attr = getWord(1,attr);
    return(attr);
}


// ------------------------------------------------------------
// function xmlAggregate()
// 	Output elements for aggregate
// ------------------------------------------------------------
function xmlAggregate(statement, outTs) {
    var reg = /\bSET\b|\bBAG\b|\bLIST\b|\bARRAY\b/i;
    var agg = statement.match(reg);
    if (agg) {
    	agg = agg.toString();
    	agg = agg.toUpperCase();
	var opos = statement.search(/\[/);
	var cpos = statement.search(/\]/);
	var bounds = statement.substr(opos+1, cpos-opos-1);
	bounds = bounds.replace(/\s/g,"");
	var lower = bounds.match(/.*\:/);


//debug TEH
//    debug("opos " + opos);
//    debug("cpos " + cpos);
//    debug("bounds " + bounds);
//    debug("bounds.length " + bounds.length);
//    debug("lower " + lower);


// "if" added by TEH to enable else, which deals with implied bounds.
// After experimenting with GE, I decide to coerce explicit bounds in all cases
// rather than fix the display in the case where no bounds are in the express
	if (bounds.length > 0) {
		lower = lower[0].replace(/\:/,"");
		var upper = bounds.match(/\:.*/);
		upper = upper[0].replace(/\:/,"");
		xmlOpenElement("<inverse.aggregate",outTs);
		xmlAttr("type",agg,outTs);
		xmlAttr("lower",lower,outTs);
		xmlAttr("upper",upper,outTs);
		xmlCloseAttr(outTs);
	}
	else{
		xmlOpenElement("<inverse.aggregate",outTs);
		xmlAttr("type",agg,outTs);
		xmlAttr("lower",'0',outTs);
		xmlAttr("upper",'?',outTs);
		xmlCloseAttr(outTs);
	}
    }
}


// ------------------------------------------------------------
// function xmlSuperExpression_cst()
// ------------------------------------------------------------
function xmlSuperExpression_cst(statement, outTs) {
    var superExpr = statement;
    var reg = /\;/;
    superExpr = superExpr.replace(reg,"");
    xmlAttr("super.expression", superExpr, outTs);
}


// ------------------------------------------------------------
// function xmlSubtypeConstraint()
// ------------------------------------------------------------
function xmlSubtypeConstraint(statement,outTs,expTs) {
    var constName = getWord(2,statement);
    var entity_ref = getWord(4,statement);
    xmlOpenElement("<subtype.constraint name=\""+constName+"\"",outTs);
    xmlAttr("entity",entity_ref,outTs);
    xmlConstraintStructure(outTs, expTs, "supertype_expression");
}


// ------------------------------------------------------------
// function xmlConstraintStructure()
// ------------------------------------------------------------
function xmlConstraintStructure(outTs,expTs,mode) {
    var l = readNextLine(expTs);
    
    //debug(l);
    var token = readToken(l)+"";
    //debug(token);
    
    switch(token) {
    case "-1" :
	// must have read an empty line
	// process next statement
	xmlConstraintStructure(outTs,expTs,mode);
	break;

    case "ABSTRACTSUPERTYPE" :	
	xmlAbstract(outTs);
	
	// process next statement
	xmlConstraintStructure(outTs,expTs,mode);
	break;

    case "TOTAL_OVER":
	var statement = readStatement(l,expTs);
	var to_list=getList(statement);
	xmlAttr("totalover",to_list,outTs);
	
	// process next statement							
	xmlConstraintStructure(outTs,expTs,mode);
        break;

    case "END_SUBTYPE_CONSTRAINT" :
	outTs.WriteLine(">");
    	xmlCloseElement("</subtype.constraint>",outTs);
    	break;

    default:
	var statement = readStatement(l,expTs);
	xmlSuperExpression_cst(statement,outTs);
        
        // process next statement
	xmlConstraintStructure(outTs,expTs,mode);
 	break;	
    }
}


// ------------------------------------------------------------
// function xmlInterface()
// ------------------------------------------------------------
function xmlInterface(statement, outTs) {
    statement = normaliseStatement(statement);
    xmlOpenElement("<interface",outTs);
    var kind = getWord(1,statement).toLowerCase();
    xmlAttr("kind",kind,outTs);
    var schema = getWord(3,statement);
    xmlAttr("schema",schema,outTs);
    outTs.WriteLine(">");
    var lArr = list2array(statement);
    if (lArr != -1) {
	for (var i=0; i<lArr.length; i++) {
	    xmlOpenElement("<interfaced.item",outTs);
	    var line =  trim(lArr[i]);
	    var reg = /\bAS\b/i;
	    var as = line.match(reg);
	    var entity, alias;
	    if (as) {
		var ifLine = line.split(" "); 
		entity = ifLine[0];
		alias = ifLine[2];
		//debug('{'+entity+' = '+alias+'}');	  
		xmlAttr("name",entity,outTs);	    
		xmlAttr("alias",alias,outTs);
	    }
	    else {
		entity = line;
		xmlAttr("name",entity,outTs);	    
	    }
	    xmlCloseAttr(outTs);
	}
    }
    xmlCloseElement("</interface>",outTs);
}


// ------------------------------------------------------------
// function xmlUnderlyingType()
// 	tage the underlying type
// ------------------------------------------------------------
function xmlUnderlyingType(statement,outTs) {
    statement = normaliseStatement(statement);

// PH: Add aggregate for function parameters
    var reg = /\bSET\b|\bBAG\b|\bLIST\b|\bARRAY\b|\bAGGREGATE\b/i;
    var agg = statement.match(reg);
    
    if (agg) {
    	agg = agg.toString();
        agg = agg.toUpperCase();
	var opos   = statement.search(/\[/);
	var cpos   = statement.search(/\]/);
	var bounds = null;
	var lower  = "";
	var upper  = "";
	if (opos != -1) {
	    bounds = statement.substr(opos+1, cpos-opos-1);
	    bounds = bounds.replace(/\s/g,"");
	    lower = bounds.match(/.*\:/);
	    lower = lower[0].replace(/\:/,"");
	    upper = bounds.match(/\:.*/);
	    upper = upper[0].replace(/\:/,"");
	}
	
	var pos = statement.search(/\bOF\b/i);
	var rest = statement.substr(pos+3);
	var unique = null;
	var optional = null;
	reg = /\bOPTIONAL\b/i;
	
	if (rest.match(reg)) {
	    optional="YES";
	    rest = rest.replace(reg,"");
	}
	
	reg = /\bUNIQUE\b/i;
	
	if (rest.match(reg)) {
	    unique="YES";
	    rest = rest.replace(reg,"");
	}
	
	var typename = getWord(1,rest);
//thx added
	reg = /\:/i;

	if(rest.match(reg)){
		var typelabel = getAfterColon(rest);
	}
	xmlOpenElement("<aggregate",outTs);
	xmlAttr("type",agg,outTs);
	
	if (bounds) {
	    xmlAttr("lower",lower,outTs);
	    xmlAttr("upper",upper,outTs);
	}

	if (optional) xmlAttr("optional",optional,outTs);
	
	if (unique) xmlAttr("unique",unique,outTs);

	xmlCloseAttr(outTs); 

        // PH: GENERIC_ENTITY
	reg = /\bBINARY\b|\bBOOLEAN\b|\bGENERIC_ENTITY\b|\bGENERIC\b|\bINTEGER\b|\bLOGICAL\b|\bNUMBER\b|\bREAL\b|\bSTRING\b/i;
	var aggtype = statement.match(reg);
	
	if (aggtype) {
	    aggtype = aggtype.toString();
	    aggtype = aggtype.toUpperCase();
	    xmlOpenElement("<builtintype",outTs);
	    xmlAttr("type",aggtype,outTs);
	    if (typelabel){
	   	xmlAttr("typelabel",typelabel,outTs);
	    }
	    xmlCloseAttr(outTs);
	}
	else {
	    xmlOpenElement("<typename",outTs);
	    xmlAttr("name",typename,outTs);
	    xmlCloseAttr(outTs);
	}
	return;
    }

    reg = /\bBINARY\b|\bBOOLEAN\b|\bGENERIC_ENTITY\b|GENERIC\b|\bINTEGER\b|\bLOGICAL\b|\bNUMBER\b|\bREAL\b|\bSTRING\b/i;
    var type = statement.match(reg);

    if (type) {
    	type = type.toString();
    	type = type.toUpperCase();
	xmlOpenElement("<builtintype",outTs);
	xmlAttr("type",type,outTs);
	    if (typelabel){
	   	xmlAttr("typelabel",typelabel,outTs);
	    }
	xmlCloseAttr(outTs);
	return;
    }
    
    xmlOpenElement("<typename",outTs);
    statement = trim(statement);
    xmlAttr("name",statement,outTs);
    xmlCloseAttr(outTs);
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
// function getExtensibleBasedOn()
//	Return the BASED_ON type
// ------------------------------------------------------------
function getExtensibleBasedOn(extensibleStatement) {
    extensibleStatement = normaliseStatement(extensibleStatement);
    var type = -1;
    var reg  = /\bBASED_ON\b/i;
    var pos = extensibleStatement.search(reg);
    if (pos != -1) {
	// get the word after BASED_ON
	extensibleStatement = extensibleStatement.substr(pos+9);
	pos = extensibleStatement.search(" ");
	type = extensibleStatement.substr(0,pos);
    }
    return(type);
}


// ------------------------------------------------------------
// function xmlSelect()
// 	genericentity (YES | NO) "NO"
// ------------------------------------------------------------
function xmlSelect(statement,outTs) {    
    xmlOpenElement("<select",outTs);
    var reg = /\bEXTENSIBLE\b/i;

    if (statement.match(reg)) {
	xmlAttr("extensible","YES",outTs);
    }

    var reg = /\bGENERIC_ENTITY\b/i;

    if (statement.match(reg)) {
	xmlAttr("genericentity","YES",outTs);
    }

    var based_on = getExtensibleBasedOn(statement);

    if (based_on != -1) {
	xmlAttr("basedon",based_on,outTs);
    }
    
    var selectItems = getList(statement);

    if (selectItems) {
//    	selectItems = selectItems.toLowerCase();
	xmlAttr("selectitems",selectItems,outTs);
    }

    outTs.WriteLine(">");
    xmlCloseElement("</select>",outTs);
}


// ------------------------------------------------------------
// function xmlSelect()
//	genericentity (YES | NO) "YES"
// ------------------------------------------------------------
function xmlEnumeration(statement,outTs) {
    xmlOpenElement("<enumeration",outTs);
    var reg = /\bEXTENSIBLE\b/i;
    
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
    }

// TEH: Still to do?
//	  width CDATA #IMPLIED
//	  fix (YES | NO) "NO"
//	  precision CDATA #IMPLIED
//	  typelabel NMTOKEN #IMPLIED


// ------------------------------------------------------------
// function xmlBuiltInType()
// 	tag builtin type
// ------------------------------------------------------------
function xmlBuiltInType(typeType,statement,outTs) {
    xmlOpenElement("<builtintype",outTs);
    xmlAttr("type",typeType,outTs);
    outTs.WriteLine(">");
    xmlCloseElement("</builtintype>",outTs);
    }


// ------------------------------------------------------------
// function getType()
//	Get the type and return
// ------------------------------------------------------------
function getType(statement) {
    var reg = /\bSET\b|\bBAG\b|\bLIST\b|\bARRAY\b|\bAGGREGATE\b|\bSELECT\b|\bENUMERATION\b|\bBINARY\b|\bBOOLEAN\b|\bINTEGER\b|\bLOGICAL\b|\bNUMBER\b|\bREAL\b|\bSTRING\b/i;
    var type = statement.match(reg);
    //debug("getType1:"+type);
    
    if (type) { 
	type = type.toString();
	type = type.toUpperCase();
	//debug("getType2:"+type);
    }
    else {
    	//debug("no Type found");
	type = getAfterEquals(statement);
	var reg = /^\s*/;
	type = type.replace(reg,"");
	reg = /\;/;
	type = type.replace(reg,"");
	//debug("getType3:"+type);
    }
    return(type);
}


// ------------------------------------------------------------
// function xmlType()
// 	identify the express type and process
// ------------------------------------------------------------
function xmlType(statement,outTs,expTs) {
    var typeName = getWord(2,statement);
//    typeName = typeName.toLowerCase();
    xmlOpenElement("<type name=\""+typeName,outTs);
    outTs.WriteLine("\">");
    var typeType = getType(statement);
    //debug("St:"+statement);
    //debug("tn:"+typeName);
    //debug("tt:"+typeType);
    
    switch( typeType) {
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
    case "LIST" :
	xmlUnderlyingType(statement,outTs);
	break;
    case "SET" :
	xmlUnderlyingType(statement,outTs);
	break;
    case "BAG" :
	xmlUnderlyingType(statement,outTs);
	break;
    case "ARRAY" :
	xmlUnderlyingType(statement,outTs);
	break;

    default :	
	xmlOpenElement("<typename",outTs);
	xmlAttr("name",typeType,outTs);
	xmlCloseAttr(outTs);
	break;
    }
    
    //outTs.WriteLine("");
    xmlTypeStructure(outTs,expTs);
}


// ------------------------------------------------------------
// dep function
// ------------------------------------------------------------
//function xmlTypeStructureOld(xmlTs,expTs) {
//    var l = expTs.ReadLine();
//    //debug("L:"+l);
//    lNumber = expTs.Line;
//    var token = readToken(l);
//    switch( token ) {
//    case "END_TYPE" :	
//	xmlCloseElement("</type>",xmlTs);
//		break;
//    case "WHERE" :
//	// assumes WHERE is on new line
//	xmlTypeStructure(xmlTs,expTs);
//	break;
//
//    default :
//	// only called when in a where definition
//	var statement = readStatement(l,expTs);
//
//	//debug("ss:"+statement);
//	var name = getWord(1,statement);
//	
//	var expr = getAfterColon(statement);
//	var reg = /^\s*/;
//	expr = expr.replace(reg,"");
//	expr = tidyExpression(expr);
//	xmlOpenElement("<where",xmlTs);	
//	xmlAttr("label",name,xmlTs);
//	xmlAttr("expression",expr,xmlTs);
//	xmlTs.WriteLine(">");
//	xmlCloseElement("</where>",xmlTs);
//	xmlTypeStructure(xmlTs,expTs);
//	break;
//
//    }
//}


// ------------------------------------------------------------
// function xmlTypeStructure()	
// ------------------------------------------------------------
function xmlTypeStructure(xmlTs,expTs) {
    var l = readNextLine(expTs);
    //debug("L:"+l);

    var token = readToken(l);
    switch( token ) {
    case "END_TYPE" :	
	xmlCloseElement("</type>",xmlTs);
		break;

	//case "WHERE" :	
	// assumes WHERE is on new line
	//xmlTypeStructure(xmlTs,expTs);
	//break;
    default :
	// only called when in a where definition
	var statement = readStatement(l,expTs);
	//debug("ss:"+statement);
	
	var name = getWord(2,statement);
	//debug("wr:"+name);
	var expr = getAfterColon(statement);
	var reg = /^\s*/;
	expr = expr.replace(reg,"");
	expr = tidyExpression(expr);
	xmlOpenElement("<where",xmlTs);	
	xmlAttr("label",name,xmlTs);
	xmlAttr("expression",expr,xmlTs);
	xmlTs.WriteLine(">");
	xmlCloseElement("</where>",xmlTs);
	xmlTypeStructure(xmlTs,expTs);
	break;
    }
}


// ------------------------------------------------------------
// Object declaration FunctionObj()
// ------------------------------------------------------------
function FunctionObj(name) {
    this.name = name;
    this.paramStr ="";
    this.retStr = "";
    this.algorithm = "";
}


// ------------------------------------------------------------
// FunctionObj method loadParamList()
// ------------------------------------------------------------
FunctionObj.prototype.loadParamList = function(paramList,expTs,outTs) {
    var closeParen = paramList.search(/\)/);

    if (closeParen != -1) {
	// found the end of the parameter list
	var retStr = paramList.replace(/.*\)/,"");
	this.loadRtnStr(retStr,expTs,outTs);
	paramList = paramList.replace(/\).*/,"");
	paramList = paramList.replace(/.*\(/,"");
	this.paramStr = paramList;
	this.loadAlgorithm("",expTs,outTs);
    }
    else {
	var line = readNextLine(expTs);
	
	paramList = paramList+line;
	this.loadParamList(paramList,expTs,outTs);
    }    
}


// ------------------------------------------------------------
// FunctionObj method xmlParamList()
//	get the parameter list
// ------------------------------------------------------------
FunctionObj.prototype.xmlParamList = function (outTs) {
    this.paramStr = trim(this.paramStr);
    var paramArr1 = this.paramStr.split(";");

    for (var i=0; i<paramArr1.length; i++) {
  // there may be more than one parameter with the same type definition
  // e.g., FUNCTION first_proj_axis(z_axis,arg : direction) : direction;
  // SPF: fine, but this only works for one more parameter
  
// get the params 
	var params = paramArr1[i].replace(/:.*/,"");
	var rest = getAfterColon(paramArr1[i]);
	var paramArr2 = params.split(",");	
	var typedef = paramArr1[i].substring(params.length);
	typedef = trim(rest);

	for (var j=0; j<paramArr2.length; j++) {
	    var param = trim(paramArr2[j]);
	    xmlOpenElement("<parameter",outTs);		
	    xmlAttr("name",param,outTs);
	    outTs.WriteLine(">");
	    xmlUnderlyingType(typedef,outTs);
	    xmlCloseElement("</parameter>",outTs);
	}
    }
}


// ------------------------------------------------------------
// FunctionObj method loadRtnStr()
//	return string
// ------------------------------------------------------------
FunctionObj.prototype.loadRtnStr = function (retStr,expTs,outTs) {
    this.rtnStr = readStatement(retStr,expTs);
    this.rtnStr = normaliseStatement(this.rtnStr);
    this.rtnStr = trim(this.rtnStr);
    this.rtnStr = this.rtnStr.replace(/;/g,"");
    this.rtnStr = this.rtnStr.replace(/^\:/g,"");
    this.rtnStr = trim(this.rtnStr);
}


// ------------------------------------------------------------
// FunctionObj method xmlRtnStr()
//	xml return string
// ------------------------------------------------------------
FunctionObj.prototype.xmlRtnStr = function (outTs) {
    xmlUnderlyingType(this.rtnStr,outTs);	    
}


// ------------------------------------------------------------
// FunctionObj method loadAlgorithm()
// 	read in the algorithm and write in to the xml file
// ------------------------------------------------------------
FunctionObj.prototype.loadAlgorithm = function(algoStr,expTs,outTs) {
    var line = readNextLine(expTs);
    
    // end of algorithm?
//TEH modified for case when these are on same line as last part of alogorithm
//    var reg = /\bEND_FUNCTION|END_PROCEDURE|WHERE/i;
//    if (line.match(reg)) {
//
    var pos = line.search(/\bEND_FUNCTION|END_PROCEDURE|WHERE/i);
    if (pos != -1) {
        line=line.substr(0,pos)
	this.algorithm = algoStr+"\n" +line;
    }
    //     
    else {
    	line = trim(line);
	algoStr = algoStr+"\n"+line;
	this.loadAlgorithm(algoStr,expTs,outTs);
    }
    // return -1 if there is no algorithm
    if (algoStr == "") {
    	return -1;
    }	
}


// ------------------------------------------------------------
// FunctionObj method xmlAlgorithm()
// ------------------------------------------------------------
FunctionObj.prototype.xmlAlgorithm = function(outTs){
    xmlOpenElement("<algorithm",outTs);
    outTs.WriteLine(">");
    outTs.WriteLine(tidyExpression(this.algorithm));
    xmlCloseElement("</algorithm>",outTs);
    }


// ------------------------------------------------------------
// function xmlFunction
// ------------------------------------------------------------
function xmlFunction(line,expTs,outTs) {
    var name = getWord(2,line);
    var fnObj = new FunctionObj(name);

    fnObj.loadParamList(line,expTs,outTs);
    xmlOpenElement("<function",outTs);
    xmlAttr("name",fnObj.name,outTs);
    outTs.WriteLine(">");

    fnObj.xmlParamList(outTs);
    fnObj.xmlRtnStr(outTs);

// TEH  - algorithm is loaded in xmlParamList
    fnObj.xmlAlgorithm(outTs);
    xmlCloseElement("</function>",outTs);
    }


// ------------------------------------------------------------
// function xmlProcedure()
// ------------------------------------------------------------
function xmlProcedure(line,expTs,outTs) {
    var name = getWord(2,line);
    var fnObj = new FunctionObj(name);

    fnObj.loadParamList(line,expTs,outTs);
    xmlOpenElement("<procedure",outTs);
    xmlAttr("name",fnObj.name,outTs);
    outTs.WriteLine(">");
    fnObj.xmlRtnStr(outTs);
    fnObj.xmlParamList(outTs);
//TEH algorithm is loaded in xmlParamList
    fnObj.xmlAlgorithm(outTs);
    xmlCloseElement("</procedure>",outTs);
    }


// ------------------------------------------------------------
// function loadDomainRule()
//	found a WHERE 
// ------------------------------------------------------------
function loadDomainRule(expTs,outTs) {
    var line = readNextLine(expTs);
     	
    var reg1 = /\bEND_RULE/i;
    if (!line.match(reg1)) {
	var statement = readStatement(line,expTs);
	var name = getWord(1,statement);
	var expr = getAfterColon(statement);
	var reg = /^\s*/;
	expr = expr.replace(reg,"");
	expr = tidyExpression(expr);
	xmlOpenElement("<where",outTs);	
	xmlAttr("label",name,outTs);
	xmlAttr("expression",expr,outTs);
	outTs.WriteLine(">");
	xmlCloseElement("</where>",outTs);
	loadDomainRule(expTs,outTs);
    }
}



// ------------------------------------------------------------
// function xmlRule()
// ------------------------------------------------------------
function xmlRule(line,expTs,outTs) {
    var statement = readStatement(line,expTs);
    var name = getWord(2,line);
    var appliesTo = getList(statement);
    var fnObj = new FunctionObj(name);
    
    xmlOpenElement("<rule",outTs);
    xmlAttr("name",name,outTs);
    xmlAttr("appliesto",appliesTo,outTs);
    outTs.WriteLine(">");
    if (fnObj.loadAlgorithm("",expTs,outTs) != -1) {
    	fnObj.xmlAlgorithm(outTs);
    }
    
    loadDomainRule(expTs,outTs);

    xmlCloseElement("</rule>",outTs);
    }


// ------------------------------------------------------------
// function xmlOpenElement()
// ------------------------------------------------------------
function xmlOpenElement(xmlElement, outTs) {
    var txt = indent+xmlElement;
    outTs.Write(txt);
    indent = indent+"  ";
}


// ------------------------------------------------------------
// function xmlCloseElement()
//	close xml element tag
// ------------------------------------------------------------
function xmlCloseElement(xmlElement, outTs) {
    if (indent.length >= 2) {
	indent = indent.substr(2);
    }
    else {
	indent = indent+"-------";
    }
    
    var txt = indent+xmlElement;
    outTs.WriteLine(txt);
    if(xmlElement == "</entity>") {outTs.WriteLine("");}
    if(xmlElement == "</type>") {outTs.WriteLine("");}
    if(xmlElement == "</constant>") {outTs.WriteLine("");}
    if(xmlElement == "</function>") {outTs.WriteLine("");}
    if(xmlElement == "</rule>") {outTs.WriteLine("");}
}


// ------------------------------------------------------------
// function xmlAttr()
// 	Output an indented attribute
// ------------------------------------------------------------
function xmlAttr(name, value, outTs) {
    // SPF: delete "SELF\" ISSUE: this is not the correct way to process SELF\
    // xml will not validate with "SELF\" 
   // value = value.replace(/SELF\\/,"");
    
    var txt = indent+name+'=\"'+value+'\"';
    outTs.WriteLine();
    outTs.Write(txt);
}


// ------------------------------------------------------------
// function xmlCloseAttr()
//	close attribute tag
// ------------------------------------------------------------
function xmlCloseAttr(outTs) {
    outTs.WriteLine("/>");    
    
    if (indent.length >= 2) {
	indent = indent.substr(2);
    }
    else {
	indent = indent+"-------";
    }
}


// ------------------------------------------------------------
// function Output2xml()
//	this is the main routine
//	read express file line, process, write to xml file
// ------------------------------------------------------------
function Output2xml(expFile, xmlFile, partnumber) {
    userMessage("Reading EXPRESS from file: " + expFile);
    userMessage("");
    userMessage("      Writing XML to file: " + xmlFile);
    
    var fso   = new ActiveXObject("Scripting.FileSystemObject");
    var expF  = fso.GetFile(expFile);
    var expTs = expF.OpenAsTextStream(ForReading, TristateUseDefault);

    var xmlF  = fso.CreateTextFile(xmlFile,true);
    xmlF.Close();
    xmlF      = fso.GetFile(xmlFile);
    var xmlTs = xmlF.OpenAsTextStream(ForWriting, TristateUseDefault);

    xmlFileHeader(xmlTs);
    xmlOpenElement("<express",xmlTs);
    xmlAttr("language_version","2",xmlTs);

    if (expFile.match(/_schema.exp$/) ) {
	// An integrated resource
	if (partnumber) {
	    xmlAttr("reference",partnumber,xmlTs);
	}
    }	
    
    // hacked by TEH: did not know how to indicate start of string in a regular expression
    // SPF: start of word is \b
    else if (expFile.match(/\baic_/i)) {
	// an aic
	// debug("found aic :" + partnumber);
	if (partnumber) {
	    // debug("found partno: " +  partnumber);
	    xmlAttr("reference",partnumber,xmlTs);
	}	
    }
    // End hack by TEH - plus or minus a curly bracket.
    // SPF: Curly brackets OK
    
    else if (expFile.match(/arm.exp$/)) {
	xmlAttr("description.file","arm_descriptions.xml",xmlTs);
    }
    
    else if (expFile.match(/mim.exp$/)) {
	xmlAttr("description.file","mim_descriptions.xml",xmlTs);	
    }

    var rcsdate = "$"+"Date: $";
    xmlAttr("rcs.date",rcsdate,xmlTs);
    var rcsrevision = "$"+"Revision: $";
    xmlAttr("rcs.revision",rcsrevision,xmlTs);
    xmlTs.WriteLine(">");
    xmlTs.WriteLine("");
    xmlApplication(xmlTs);
    
    while (!expTs.AtEndOfStream) {

	var l = readNextLine(expTs);

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
	case "CONSTANT" :	
	    var statement = readStatement(l,expTs);
	    xmlConstant(statement,expTs,xmlTs);
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
		xmlType(statement,xmlTs,expTs);
		break;
	case "FUNCTION" :	
		var statement = readStatement(l,expTs);
		xmlFunction(statement,expTs,xmlTs);
		break;
	case "PROCEDURE" :	
		var statement = readStatement(l,expTs);
		xmlProcedure(statement,expTs,xmlTs);
		break;
	case "RULE" :	
		var statement = readStatement(l,expTs);
		xmlRule(statement,expTs,xmlTs);
		break;
        // PH
	case "SUBTYPE_CONSTRAINT":
		var statement = readStatement(l,expTs);
                xmlSubtypeConstraint(statement,xmlTs,expTs);
		break;
	//case "(*" :
		//var comment = readComment(l, expTs);
		//userMessage(comment);
		//break;
	//case "--" :
		//var comment = readDashComment(l, expTs);
		//userMessage(comment);
		//break;
	default :	
	    //debug("default: "+token+"]");
	    //debug(l);
	    break;
	}//end switch
    }//end while

    xmlCloseElement("</express>",xmlTs);
    
    //close the files
    expTs.Close();    
    xmlTs.Close();
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
    Output2xml(currentExpFile, xmlFile, partNo);
}


// ------------------------------------------------------------
// Main program for generating the XML for the MIM express of module
// -----------------------------------------------------------
function MainMim() {
    var cArgs = System.Environment.GetCommandLineArgs();
    
    if (cArgs.length != 1) {
	ErrorMessage("Incorrect arguments\ncscript express2xml.js <module>" );	
	return(false);
    }

    var module = cArgs(0);
    currentExpFile = '../data/modules/'+module+'/mim.exp';
    var xmlFile = '../data/modules/'+module+'/mim.xml';
    var partNo = "";
    Output2xml(currentExpFile, xmlFile, partNo);
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
	    "  express2xml.js <express>\nOr\n"+
	    "  express2xml.js <module> arm\nOr\n"+
	    "  express2xml.js <module> arm_lf\nOr\n"+
	    "  express2xml.js <module> mim\nOr\n"+
	    "  express2xml.js <module> mim_lf\nOr\n"+
	    "  express2xml.js <module> module\nOr\n"+
	    "  express2xml.js <resource> resource <part number>\n"+
	    "  express2xml.js <reference> reference  <directory>\n";
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
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);
	    break;

	case "mim" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/mim.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);
	    break;

	case "mim_lf" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/mim_lf.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);
	    break;

	case "arm_lf" :
	    var module = cArgs(0);    
	    expFile = '../data/modules/'+module+'/arm_lf.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);
	    break;

	case "resource" :
	    var resource = cArgs(0);	    
	    expFile = '../data/resources/'+resource+'/'+resource+'.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
	    
	    if (cArgs.length>2) {
		var partNo = cArgs(2);
		Output2xml(expFile, xmlFile, partNo);
	    } 
	    else {
		var partNo = "";
	        Output2xml(expFile, xmlFile, partNo);
	    }
	    break;

	case "reference" :
	    var reference = cArgs(0);	    
	    if (cArgs.length>2) {
		var origin = cArgs(2);
	    } 
	    else {
		var origin = "";
	    }
	    expFile = '../data/reference/'+origin+'/'+reference+'.exp';
	    currentExpFile=expFile;
	    var xmlFile = expFile.replace("\.exp","\.xml");
		Output2xml(expFile, xmlFile, origin);	    
	    break;

	case "module" :
	    var module = cArgs(0);   
	    var xmlFile;
	    
	    // arm
	    expFile = '../data/modules/'+module+'/arm.exp';
	    currentExpFile=expFile;
	    xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);

	    // mim
	    expFile = '../data/modules/'+module+'/mim.exp';
	    currentExpFile=expFile;
	    xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);

	    // mim long form
	    expFile = '../data/modules/'+module+'/mim_lf.exp';
	    currentExpFile=expFile;
	    xmlFile = expFile.replace("\.exp","\.xml");
	    var partNo = "";
	    Output2xml(expFile, xmlFile, partNo);
	    break;
	}//end switch
    } 
    else {
	expFile = cArgs(0)+".exp";
	currentExpFile=expFile;
	var xmlFile = expFile.replace("\.exp","\.xml");
	var partNo = "";
	Output2xml(expFile, xmlFile, partNo);
    }
}//end function


// ---------------------------------------------------------------
// Call Main program
// ---------------------------------------------------------------
Main();
