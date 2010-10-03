#!/usr/local/bin/perl

################################################################################
#
# Description:
#
#   Check parts for certain common errors.
#
# Usage:
#
#   perl check_parts {-part_list=<part_list>} {-html-out=<out_file>} <source_root> 
#
# where:
#
#   <source_root> is the path of the directory containing the parts to be
#   listed.
#
#   <part_list> is the path of a file containing a list of relative directory
#   paths of the parts to be listed. If not given, all parts under source_root
#   will be listed.
#
#   <out_file> is the path of the output HTML file. If not specified, out.html
#   will be used.
#
# Example:
#
#   perl check_parts.pl -part-list=CR1_parts.txt SMRL
#
################################################################################

use strict;
use File::Spec;
use Getopt::Long;


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

sub print_error {
    my ($message, $source_file_path, $designator) = @_;

    print "In $source_file_path:\n";
    print "$message\n";
}

sub check_content {
    my ($content, $source_file_path, $designator) = @_;

    if ($content =~ m^((?:ISO|IEC|ISO/IEC)\s+[0-9]+(?:[-][0-9]+)?[:][0-9]+_)^) {
	print_error("dated reference", $source_file_path, $designator);
    }
    if ($content =~ m^(Jim Long)^) {
	print_error("Jim Long", $source_file_path, $designator);
    }
}

sub process_part_list {
    my ($source_root, $part_list_path) = @_;
    my @part_list = read_part_list($part_list_path);

    foreach my $part_rel_path (@part_list) {
	process_part($source_root, $part_rel_path);
    }
}

sub read_part_list {
    my ($part_list_path) = @_;
    my @part_list;
    my $line;
    open PART_LIST_FILE, $part_list_path || die "Could not open $part_list_path\n";
    while ($line = <PART_LIST_FILE>) {
	my $part_elt = $line;
	$part_elt =~ s/^\s*//;
	$part_elt =~ s/\s*$//;
	push(@part_list,$part_elt);
    }
    return @part_list;
}

sub process_part {
    my ($source_root, $part_rel_path) = @_;
    process_node($source_root, $part_rel_path);
}

sub process_node {
    my ($source_root, $node_rel_path) = @_;
    my $source_node_path = "$source_root/$node_rel_path";
    if (-d $source_node_path) {
	opendir my($dh), $source_node_path or die "cannot open dir $source_node_path: $!";
	my @children = grep { /^[^\.]/ } readdir($dh);
	closedir $dh;

	my $child;
	foreach $child (@children) {
	    my $child_rel_path;
	    if ($node_rel_path eq "") {
		$child_rel_path = $child;
	    }
	    else {
		$child_rel_path = "$node_rel_path/$child";
	    }
	    process_node($source_root, $child_rel_path);
	}
    }
    if (-f $source_node_path) {
	process_file($source_root, $node_rel_path);
    }
}

sub process_file {
    my ($source_root, $node_rel_path) = @_;
    my $source_file_path = "$source_root/$node_rel_path";

    if (is_html($source_file_path)) {
	my $content;
	{
	    local($/, *SOURCE_FILE);
	    open SOURCE_FILE, $source_file_path || die "Could not open input file $source_file_path";
	    $content = <SOURCE_FILE>;
	    close SOURCE_FILE;
	}
	if ($content =~ m%<(?:TITLE|title)>(ISO(?:/TS)?\s+[0-9]+(:?-[0-9]+)?:[0-9]{4}(:?-[0-9]{2})?)\s*([^<]+)</(TITLE|title)>%) {
	    my $designator = $1;
	    my $title = $2;
	    check_content($content, $source_file_path, $designator);
	}
    }
}

sub main {
    my $part_list_path = "";
    my $html_out_file_path = "out.html";
    my $result = GetOptions ("part-list=s" => \$part_list_path,
	"-html-out=s" => \$html_out_file_path);

    my $source_root = $ARGV[0];

    if ($part_list_path eq "") {
	process_node($source_root, "");
    }
    else {
	process_part_list($source_root, $part_list_path);
    }
}

main();
