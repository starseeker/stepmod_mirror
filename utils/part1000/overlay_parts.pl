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
#   target-dir=<AP_dir> path of the directory containing the AP
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

my $dir_mode = 0;

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
    my $target_dir_path = "";
    my $verbose;

    my $result = GetOptions ("module-list=s" => \$module_list_path,    # string
			     "resource-list=s" => \$resource_list_path,# string
			     "target-dir=s"   => \$target_dir_path,    # string
			     "verbose"  => \$verbose);  # flag  
    if ($#ARGV == 1) {
	$dir_mode = 1;
	$target_dir_path =  $ARGV[0];
	process_by_subdirs("$part1000_home/data/modules", "$target_dir_path/data/modules");
	process_by_subdirs("$part1000_home/data/resources", "$target_dir_path/data/resources");
    }
    else {
	my @module_list = read_part_list($module_list_path);
	my @resource_list = read_part_list($resource_list_path);
	process_by_list("$part1000_home/data/modules", "$target_dir_path/data/modules", @module_list);
	process_by_list("$part1000_home/data/resources", "$target_dir_path/data/resources", @resource_list);
    }
}

sub read_part_list {
    my ($filename) = @_;
    my @part_list;
    open LISTFILE, $filename or die "Cannot read part list $filename: $!";
    while (<LISTFILE>) {
	my $part = $_;
	$part =~ s/^\s+//;
	$part =~ s/--.*$//;
	$part =~ s/_arm;//;
	$part =~ s/\s+$//;
	$part =~ tr/[A-Z]/[a-z]/;
	push(@part_list, $part);
    }
    close LISTFILE;
    return @part_list;
}

sub process_by_subdirs {
    my ($source_group_path, $target_group_path) = @_;
    opendir my($dh), $target_group_path or die "Cannot open directory ($source_group_path): $!";
    my @parts = grep { /^[a-zA-Z]/ } readdir($dh);
    closedir $dh;

    foreach my $part_name (@parts) {
	print "processing part: $part_name\n";
	process_part("$source_group_path/$part_name", "$target_group_path/$part_name");
    }
}

sub delete_children {
    my ($dir_path) = @_;
    opendir my($dh), $dir_path or die "Cannot open directory ($dir_path): $!";
    my @children = grep { /^[^.]/ } readdir($dh);
    closedir $dh;

    print "deleting children of $dir_path\n";
    foreach my $child (@children) {
	rmtree("$dir_path/$child") or die "Cannot delete tree ($dir_path/$child): $!";
    }
}

sub process_by_list {
    my ($source_group_path, $target_group_path, @parts) = @_;

    delete_children($target_group_path);

    foreach my $part_name (@parts) {
	print "processing part: $part_name\n";
	process_part("$source_group_path/$part_name", "$target_group_path/$part_name");
    }
}

sub process_part {
    my ($source_part_path, $target_part_path) = @_;
    copy_dir($source_part_path, $target_part_path);
}

sub copy_dir {
    my ($source_path, $target_path) = @_;

    opendir my($dh), $source_path or die "Cannot open directory ($source_path): $!";
    my @children = grep { /^[^.]/ } readdir($dh);
    closedir $dh;

    $target_path =~ s^/^\\^g;
    mkdir($target_path) or die "Cannot make directory ($target_path): $!\n";

    foreach my $child (@children) {
	my $source_child = "$source_path/$child";
	my $target_child = "$target_path/$child";
	if (-d $source_child) {
	    copy_dir("$source_child", "$target_child");
	}
	elsif (-f $source_child) {
	    copy($source_child, $target_child);
	}
    }
}
