#!/usr/bin/perl
#
# Consolidates a set of modules, each in its own directory structure,
# into a single directory structure.
#
# Usage:
#   consolidate_module_dirs <source_dir> <target_dir>
#
# Where:
#   <source_dir> is the directory that contains a separate structure
#   for each module
#
#   <target_dir> is the directory in which the consolidated structure
#   is to be put
#
# Method:
#   Recusrively traverses <source_dir> looking for directories named
#   "modules". The subdirectories of each "modules" directory are copied.
#   All other directories are ignored.
#
# Author: Gerry Radack

use File::Copy::Recursive;

$dirtoget=$ARGV[0];
$dirtoput=$ARGV[1];
process1($dirtoget);

sub process1 {
    my($dirtoget) = @_;
    if (-d $dirtoget) {
	opendir(IMD, $dirtoget) || die("Cannot open directory");
	my(@thefiles) = readdir(IMD);
	closedir(IMD);

	foreach $f (@thefiles) {
	    unless ( ($f eq ".") || ($f eq "..") ) { 
		if ($f eq "modules") {
		    process2($dirtoget . "/" . $f);
		}
		else {
		    process1($dirtoget . "/" . $f);
		}
	    }
	}
    }
}

sub process2 {
    my($dirtoget) = @_;
    opendir(IMD, $dirtoget) || die("Cannot open directory");
    my(@thefiles) = readdir(IMD);
    closedir(IMD);

    foreach $f (@thefiles) {
	unless ( ($f eq ".") || ($f eq "..") ) { 
	    my($filetocopy) = $dirtoget . "/" . $f;
	    print "copying $filetocopy to $dirtoput\n";
	    &File::Copy::Recursive::dircopy($filetocopy, $dirtoput . "/" . $f) or die "File cannot be copied.";
	}
    }
}
