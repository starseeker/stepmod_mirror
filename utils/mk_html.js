//$Id:  $
//  Author: P. Huau
//  Purpose:  JScript to generate the default XML for the module.
//     cscript mkmodule.js <module> 
//     e.g.
//     cscript mkmodule.js person
//     The script is called from mk_html.wsf


// ------------------------------------------------------------
// Global variables
// -----------------------------------------------------------

// Change this to wherever you have installed the module repository
// Note the use of UNIX path descriptions as opposed to DOS
var stepmodHome = "..";

var moduleClauses = new Array("main", "cover", "contents", 
			      "introduction", "foreword", 
			      "1_scope", "2_refs", "3_defs", "4_info_reqs", 
			      "5_main", "5_mim", "5_mapping", 
			      "a_short_names", "b_obj_reg", "c_arm_expg", 
			      "d_mim_expg", 
			      "e_exp", 
			      "e_exp_mim", "e_exp_mim_lf", 
			      "e_exp_arm", "e_exp_arm_lf", 
			      "f_guide", 
			      "biblio");

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

function CheckStepHome() {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (!fso.FolderExists(stepmodHome)) {
	ErrorMessage("The variable stepmodHome is incorrectly set in:\n"+
		     "stepmod/utils/mk_html.js to:\n\n"+stepmodHome+
		     "\n\nNote: it is a UNIX rather then WINDOWS path i.e. uses / not \\");
	return(false);
    } 
    return(true);
}


function CheckArgs() {
    var cArgs = WScript.Arguments;
    var msg = "Incorrect arguments\n"+
	"  cscript mkmodule.js <module> <part_number>";
    if ((cArgs.length == 1) || (cArgs.length == 2)) {
	return(true);
    } else {
	ErrorMessage(msg);
	return(false);
    } 
}

function CheckModule(module) {
    var modFldr = GetModuleDir(module);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    // check if the folder exists
    if (!fso.FolderExists(modFldr)) 
	throw("Directory does not already exist for module: "+ module);
    return(true);
}


function GetModuleDir(module) {
  return( stepmodHome+"/data/modules/"+module+"/");
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

function MainWindow(module, source) {
// source= "data/modules/" or "data/resources/" or ""
var MODULES_HOME="../";
var Saxon_exe="C:/saxon/saxon";
var mod_p=MODULES_HOME + source + module;
var target=MODULES_HOME + "html/" +source+ module;
var copyc="C:/windows/copy ";
var targetc="..\\html\\data\\modules\\" + module + "\\";
var mod_pc="..\\data\\modules\\" + module + "\\";
var comm;

    var objShell = WScript.CreateObject("WScript.Shell");
    var modName = NameModule(module);
    if (modName.length > 1) {
if (source=="")
{
comm= Saxon_exe +" -a -o " +target+".htm " +mod_p+".xml output_type=HTM";
	  objShell.run(comm,1,true);
}

if (source=="data/resources/")
{
comm= Saxon_exe +" -a -o " +target+"/"+module+".htm " +mod_p+"/"+module+".xml output_type=HTM";
	  objShell.run(comm,1,true);

}
if (source=="data/modules/")
{
var mod_sys=MODULES_HOME + source + module+ "/sys";
var fso = new ActiveXObject("Scripting.FileSystemObject");

comm= Saxon_exe +" -a -o " +target+"/armexpg1.htm " +mod_p+"/armexpg1.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);

       if (fso.FileExists(mod_pc+"armexpg1.gif")) fso.copyFile(mod_pc+"armexpg1.gif",targetc+"armexpg1.gif");

comm= Saxon_exe +" -a -o " +target+"/armexpg2.htm " +mod_p+"/armexpg2.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
       if (fso.FileExists(mod_pc+"armexpg2.gif"))        fso.copyFile(mod_pc+"armexpg2.gif",targetc+"armexpg2.gif");

comm= Saxon_exe +" -a -o " +target+"/armmexpg3.htm " +mod_p+"/armexpg3.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
       if (fso.FileExists(mod_pc+"armexpg3.gif"))        fso.copyFile(mod_pc+"armexpg3.gif",targetc+"armexpg3.gif");

comm= Saxon_exe +" -a -o " +target+"/mimexpg1.htm " +mod_p+"/mimexpg1.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
       if (fso.FileExists(mod_pc+"mimexpg1.gif"))        fso.copyFile(mod_pc+"mimexpg1.gif",targetc+"mimexpg1.gif");

comm= Saxon_exe +" -a -o " +target+"/mimexpg2.htm " +mod_p+"/mimexpg2.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
       if (fso.FileExists(mod_pc+"mimexpg2.gif"))               fso.copyFile(mod_pc+"mimexpg2.gif",targetc+"mimexpg2.gif");

comm= Saxon_exe +" -a -o " +target+"/arm.htm " +mod_p+"/arm.xml output_type=HTM output_rcs=NO";
       objShell.run(comm,1,true);
       if (fso.FileExists(mod_pc+"arm.exp"))               fso.copyFile(mod_pc+"arm.exp",targetc+"arm.exp");

comm= Saxon_exe +" -a -o " +target+"/mim.htm " +mod_p+"/mim.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
       if (fso.FileExists(mod_pc+"mim.exp"))               fso.copyFile(mod_pc+"mim.exp",targetc+"mim.exp");

comm= Saxon_exe +" -a -o " +target+"/sys/cover.htm " +mod_sys+"/cover.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/contents.htm " +mod_sys+"/contents.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/introduction.htm " +mod_sys+"/introduction.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/foreword.htm " +mod_sys+"/foreword.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/1_scope.htm " +mod_sys+"/1_scope.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/2_refs.htm " +mod_sys+"/2_refs.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/3_defs.htm " +mod_sys+"/3_defs.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/4_info_reqs.htm " +mod_sys+"/4_info_reqs.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/5_mim.htm " +mod_sys+"/5_mim.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/5_mapping.htm " +mod_sys+"/5_mapping.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/a_short_names.htm " +mod_sys+"/a_short_names.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/b_obj_reg.htm " +mod_sys+"/b_obj_reg.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/c_arm_expg.htm " +mod_sys+"/c_arm_expg.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/d_mim_expg.htm " +mod_sys+"/d_mim_expg.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/e_exp.htm " +mod_sys+"/e_exp.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/e_exp_arm.htm " +mod_sys+"/e_exp_arm.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/e_exp_mim.htm " +mod_sys+"/e_exp_mim.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/f_guide.htm " +mod_sys+"/f_guide.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
comm= Saxon_exe +" -a -o " +target+"/sys/biblio.htm " +mod_sys+"/biblio.xml output_type=HTM output_rcs=NO";
	  objShell.run(comm,1,true);
}
//	objShell.Popup("Generation done");
}
else {
	objShell.Popup("You must enter a module name");
    }
}


//Main();
