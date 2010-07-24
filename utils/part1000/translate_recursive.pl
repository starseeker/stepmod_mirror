#!/usr/local/bin/perl

################################################################################
#
# Description:
#
#   Recursively translates files in a directory tree.
#
# Usage:
#
#   perl translate_recursive (options...) <source_root> <dest_root>
#
# where:
#
#   <source_root> is the path of the directory containing the files to be
#   translated.
#
#   <dest_root> is the path of the directory to which the translated files
#   will be written.
#
# At present, the translation pattern is hardcoded:
#
#   "../../../../iso10303_1101/data" is translated to "../../../data".
#
################################################################################

use strict;
use File::Basename;
use File::Copy;
use File::Spec;
use Getopt::Long;
use URI;
use URI::file;

my $verbose = 0;
# my $source_pattern = "";
# my $target_pattern = "";

BEGIN {
    $| = 1
}

my $arg_count = 0;

sub is_html {
    my ($file_path) = @_;
    if ($file_path =~ m/\.htm$/) {
	return 1;
    }
    return 0;
}

sub process_part {
    my ($source_root, $dest_root, $part_rel_path, $pub_date) = @_;
    my $part_name = basename($part_rel_path);
    if ($verbose) {
	print "processing part: $part_name\n";
    }
    # dircopy($source_group_path, $target_group_path) or warn "cannot copy directory $source_group_path: $!";
    process_node($source_root, $dest_root, $part_rel_path, $pub_date);
}

sub process_node {
    my ($source_root, $dest_root, $node_rel_path, $pub_date) = @_;
    my $source_node_path = "$source_root/$node_rel_path";
    my $dest_node_path = "$dest_root/$node_rel_path";
    if (-d $source_node_path) {
	mkdir($dest_node_path, "777");
	opendir my($dh), $source_node_path or die "cannot open dir $source_node_path: $!";
	my @children = grep { /^[^\.]/ } readdir($dh);
	closedir $dh;

	my $child;
	my $basename = basename($node_rel_path);
	if ($basename eq "modules" || $basename eq "resource_parts") {
	    foreach $child (@children) {
		process_part($source_root, $dest_root, "$node_rel_path/$child", $pub_date);
	    }
	}
	else {
	    foreach $child (@children) {
		process_node($source_root, $dest_root, "$node_rel_path/$child", $pub_date);
	    }
	}
    }
    if (-f $source_node_path) {
	process_file($source_root, $dest_root, $node_rel_path, $pub_date);
    }
}

sub process_file {
    my ($source_root, $dest_root, $node_rel_path, $pub_date) = @_;
    my $source_file_path = "$source_root/$node_rel_path";
    my $source_dir_path = $source_file_path;
    $source_dir_path =~ s%/[^/]*$%%;
    my $source_dir_abs_path = File::Spec->rel2abs($source_dir_path);
    my $source_dir_uri = URI::file->new($source_dir_abs_path);
    my $dest_file_path = "$dest_root/$node_rel_path";
    if (is_html($source_file_path)) {
	my $content;
	{
	    local($/, *SOURCE_FILE);
	    open SOURCE_FILE, $source_file_path || die "Could not open input file $source_file_path";
	    $content = <SOURCE_FILE>;
	    close SOURCE_FILE;
	}
	# do translation
	# $content =~ s|$source_pattern|$target_pattern|g;
	$content =~ s|[.][.]/[.][.]/[.][.]/[.][.]/iso10303_1101/data|../../../data|g;
	open DEST_FILE, ">$dest_file_path" || die "Could not open output file $dest_file_path";
	print DEST_FILE $content;
	close DEST_FILE;
    }
    else {
	copy($source_file_path,$dest_file_path) or die "Copy failed: $!";	
    }
}

sub main {
    my $part_list_path = "";
    my $pub_date = "";
    my $data_out_path = "";
    my $result = GetOptions (# "source-pattern=s"  => \$source_pattern,
			     # "target-pattern=s"  => \$target_pattern,
			     "verbose"           => \$verbose);
    my $source_root = $ARGV[0];
    my $dest_root = $ARGV[1];
    # print "source_pattern = $source_pattern\n";
    # print "target_pattern = $target_pattern\n";
    process_node($source_root, $dest_root, "", $pub_date);
}

main();
