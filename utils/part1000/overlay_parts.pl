#!/usr/local/bin/perl

################################################################################
#
# Description:
#
#   Overlays the module and resource directories specified in a list from
#   from a checked-out copy of the part1000 Subversion repository onto a
#   working copy of an AP.
#
# Usage:
#
#   perl overlay_parts {options}
#
#   perl overlay_parts <AP_dir>
#
# where:
#
#   <AP_dir>    path of the directory containing the AP
#
# Options are:
#
#   module-list=<module_list> path of the file containing the list of modules
#   resource-list=<resource_list> path of the file containing the list of resource parts
#   input-dir  = <AP_dir> path of the directory containing the AP
#   output-dir = <AP_dir> path of the directory to which the AP with overlaid
#                parts is to be written
#
# Environment variables:
#
#   PART1000_HOME   path of the checked-out copy of the part1000 Subversion
#                   repository
#
# Example:
#
#   perl overlay_parts.pl resources.txt modules.txt AP210_IS
#
#   perl overlay_parts.pl AP210_IS
#
################################################################################

use strict;
use File::Copy;
use File::Path qw(rmtree);
use Getopt::Long;

BEGIN {
    $| = 1
}

main();

my $part1000_home;

sub main {
    $part1000_home = $ENV{PART1000_HOME};
    if (length($part1000_home) == 0) {
	die "Environment variable PART1000_HOME not set.";
    }

    my $module_list_path = "";
    my $resource_list_path = "";
    my $input_dir_path = "";
    my $output_dir_path = "";
    my $verbose;
    my $by_subdirs;

    print "hello\n";
    my $result = GetOptions ("module-list=s" => \$module_list_path,    # string
			     "resource-list=s" => \$resource_list_path,# string
			     "input-dir=s" => \$input_dir_path,        # string
			     "output-dir=s" => \$output_dir_path,      # string
			     "by-subdirs" => \$by_subdirs,             # flag
			     "verbose" => \$verbose);                  # flag
    process_node($input_dir_path, $output_dir_path, "");
}

sub process_node {
    my ($source_root, $dest_root, $node_rel_path) = @_;
    print "node_rel_path=$node_rel_path\n";
    my $source_node_path = "$source_root/$node_rel_path";
    print "source_node_path=$source_node_path\n";
    my $dest_node_path = "$dest_root/$node_rel_path";
    print "dest_node_path=$dest_node_path\n";
    my $part1000_node_path = "$part1000_home/$node_rel_path";
    if (-d $source_node_path) {
	unless (-d $dest_node_path) {
	    mkdir($dest_node_path, "777") or die "Could not create directory";
	}
	opendir my($dh), $source_node_path or die "cannot open dir $source_node_path: $!";
	my @children = grep { /^[^\.]/ } readdir($dh);
	closedir $dh;

	my $child;
	my $basename = basename($node_rel_path);
	print "basename=$basename\n";
	if ($basename eq "modules" || $basename eq "resource_parts" || $basename eq "resources") {
	    print "case 1\n";
	    foreach $child (@children) {
		dircopy($part1000_node_path, $dest_node_path) or warn "cannot copy directory $part1000_node_path: $!";
	    }
	}
	else {
	    print "case 2\n";
	    foreach $child (@children) {
		process_node($source_root, $dest_root, "$node_rel_path/$child");
	    }
	}
    }
    if (-f $source_node_path) {
	File::Copy($source_node_path, $dest_node_path);
    }
}

