//$Id: mkballot_main.js,v 1.1 2002/07/18 10:50:20 robbod Exp $
//  Author: Rob Bodington, Eurostep Limited
//  Owner:  Developed by Eurostep and supplied to NIST under contract.
//  Purpose:  JScript to generate a ballot package
//            NOTE THIS IS UNDER DEVELOPMENT


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

var stepmodHome = '..';

// If 1 then output user messages
var outputUsermessage = 1;



//------------------------------------------------------------
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

function mkBallotPackage(ballot) {
    
}


function checkBallotPackageExists(ballot) {
    
}

function ouputAntProperty(moduleNodes, property, xml, buildts) {
    var members = moduleNodes.length;
    buildts.WriteLine("")
    buildts.WriteLine("    <property name=\""+property+"\" value=\"");
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	if (i == (members - 1)) {
	    buildts.WriteLine("data/modules/"+moduleName+"/"+xml+"\"/>");
	} else {
	    buildts.WriteLine("data/modules/"+moduleName+"/"+xml+",");
	}
    }
}

function outputAntBuild(ballot, buildfile) {
    var ballotIndexXml = stepmodHome + "/ballots/ballots/"
	+ballot+"/ballot_index.xml";
    userMessage("Loading: "+ballotIndexXml);
    
    userMessage("Writing: "+buildfile);
    var ForReading = 1, ForWriting = 2, ForAppending = 8;
    var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    fso.CreateTextFile(buildfile, true );
    var f = fso.GetFile(buildfile);
    var buildts = f.OpenAsTextStream(ForWriting, TristateUseDefault);

    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = true;
    objXML.load(ballotIndexXml);
    var expr = "/ballot_index/ballot_package/module";
    var moduleNodes = objXML.selectNodes(expr);
    buildts.WriteLine("    <!-- ***************************************************** -->");
    ouputAntProperty(moduleNodes, "EXPRESS", "*.exp", buildts);
    ouputAntProperty(moduleNodes, "GIFS", "*.gif", buildts);
    ouputAntProperty(moduleNodes, "CONTENTSXML", "sys/contents.xml", buildts);
    ouputAntProperty(moduleNodes, "SCOPEXML", "sys/1_scope.xml", buildts);
    ouputAntProperty(moduleNodes, "REFSXML", "sys/2_refs.xml", buildts);
    ouputAntProperty(moduleNodes, "DEFSXML", "sys/3_defs.xml", buildts);
    ouputAntProperty(moduleNodes, "INFOREQSXML", "sys/4_info_reqs.xml", buildts);
    ouputAntProperty(moduleNodes, "MAINXML", "sys/5_main.xml", buildts);
    ouputAntProperty(moduleNodes, "MAPPINGXML", "sys/5_mapping.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMXML", "sys/5_mim.xml", buildts);
    ouputAntProperty(moduleNodes, "ASHORTNAMESXML", "sys/a_short_names.xml", buildts);
    ouputAntProperty(moduleNodes, "BOBJREGXML", "sys/b_obj_reg.xml", buildts);
    ouputAntProperty(moduleNodes, "BIBLIOXML", "sys/biblio.xml", buildts);
    ouputAntProperty(moduleNodes, "CARMEXPGXML", "sys/c_arm_expg.xml", buildts);
    ouputAntProperty(moduleNodes, "COVERXML", "sys/cover.xml", buildts);
    ouputAntProperty(moduleNodes, "DMIMEXPGXML", "sys/d_mim_expg.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPXML", "sys/e_exp.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPARMXML", "sys/e_exp_arm.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPMIMXML", "sys/e_exp_mim.xml", buildts);
    ouputAntProperty(moduleNodes, "EEXPMIMLFXML", "sys/e_exp_mim_lf.xml", buildts);
    ouputAntProperty(moduleNodes, "FGUIDEXML", "sys/f_guide.xml", buildts);
    ouputAntProperty(moduleNodes, "FOREWORDXML", "sys/foreword.xml", buildts);
    ouputAntProperty(moduleNodes, "INTRODUCTIONXML", "sys/introduction.xml", buildts);
    ouputAntProperty(moduleNodes, "ARMDESCRIPTIONSXML", "arm_descriptions.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMDESCRIPTIONSXML", "mim_descriptions.xml", buildts);
    ouputAntProperty(moduleNodes, "ARMEXPGXML", "armexpg*.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMEXPGXML", "mimexpg*.xml", buildts);

    ouputAntProperty(moduleNodes, "ARMEXPXML", "arm.xml", buildts);
    ouputAntProperty(moduleNodes, "MIMEXPXML", "mim.xml", buildts);
    buildts.WriteLine("    <!-- ***************************************************** -->");
    buildts.Close();
    userMessage("Written: "+buildfile);
}


function outputModuleList(ballot) {
    var ballotIndexXml = stepmodHome + "/ballots/ballots/"
	+ballot+"/ballot_index.xml";
    userMessage("Loading: "+ballotIndexXml);
    // create a new document instance
    var objXML = new ActiveXObject('MSXML2.DOMDocument.3.0');
    objXML.async = true;
    objXML.load(ballotIndexXml);
    var expr = "/ballot_index/ballot_package/module";
    var moduleNodes = objXML.selectNodes(expr);
    var members = moduleNodes.length;
    userMessage("Making:"+members);
    for (var i = 0; i < members; i++) {	
	var node = moduleNodes(i);
	var moduleName = node.attributes.getNamedItem("name").nodeValue;
	userMessage(moduleName);
    }

}


outputAntBuild("pdm_ballot_072002", "ballot_build.xml");
//outputModuleList("pdm_ballot_072002");
