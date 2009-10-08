#!/usr/local/bin/perl

################################################################################
#
# Description:
#
#   Overlays the module and resource directories from a change request (CR)
#   over the corresponding directories of a working copy of the part1000
#   subversion repository.
#
# Usage:
#
#   perl overlay_CR <CR_dirname> <work_dirname>
#
# where:
#
#   <CR_dirname> is the path of the directory containing the change request.
#
#   <work_dirname> is the path of directory containing a working copy of the
#   part1000 subversion repository.
#
# Example:
#
#   perl c:\radack\stepmod\stepmod\utils\part1000\overlay_CR.pl ^
#   "C:\temp\CR1\part1000" "E:\radack\cm-work\part1000\part1000_c\part1000"
#
################################################################################

use strict;
use File::Path qw(rmtree);
use File::Copy::Recursive qw(dircopy);

BEGIN {
    $| = 1
}

main();

sub main {
    my $cr_path = $ARGV[0];
    my $work_path = $ARGV[1];

    process("$cr_path/data/modules", "$work_path/data/modules");
    process("$cr_path/data/resources", "$work_path/data/resources");
}

sub process {
    my ($source_group_path, $target_group_path) = @_;
    opendir my($dh), $source_group_path or die "cannot open dir $source_group_path: $!";
    my @modules = grep { /^[^\.]/ } readdir($dh);
    closedir $dh;

    foreach my $module_name (@modules) {
	process_module($module_name, $source_group_path, $target_group_path);
    }
}

sub process_module {
    my ($module_name, $source_group_path, $target_group_path) = @_;
    print "processing module: $module_name\n";
    my $source_group_path = "$source_group_path/$module_name";
    my $target_group_path = "$target_group_path/$module_name";
    if (-d $target_group_path) {
	clear_dir($target_group_path);
    }
    else {
	print "new module: $module_name\n";
    }
    dircopy($source_group_path, $target_group_path) or warn "cannot copy directory $source_group_path: $!";
}

# Remove all contents (files, directories, etc.) from a directory, except
# those starting with "." This will spare the .svn subdirectories.

sub clear_dir {
    my ($path) = @_;
    opendir my($dh), $path or die "cannot open dir $path: $!";
    my @files = grep { /^[^\.]/ } readdir($dh);
    closedir $dh;
    foreach my $file (@files) {
	my $pathc = "$path/$file";
	if (-f $pathc) {
	    rmtree($pathc) or warn "cannot delete file $pathc: $!"; 
	}
	if (-d $pathc) {
	    clear_dir($pathc);
	}
    }
}
