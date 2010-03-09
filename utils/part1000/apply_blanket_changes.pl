#!/usr/local/bin/perl

################################################################################
#
# Description:
#
#   Applies blanket changes to a set of SMRL parts.
#
# Usage:
#
#   perl apply_blanket_changes <source_root> <dest_root> <change_list> <pub_year_mo>
#
# where:
#
#   <source_root> is the path of the directory containing the parts to be
#   changed.
#
#   <dest_root> is the path of the directory to which the changed parts
#   will be written.
#
#   <change_list> is the path of a file containing a list of the directory
#   paths of the parts to which blanket changes are to be applied. These
#   paths are relative to <source_root>.
#
#   <pub_date> is the date of publication, in YYYY-MM-DD format
#
# Example:
#
#   perl c:\radack\stepmod\stepmod\utils\part1000\apply_blanket_changes.pl ^
#   "C:\temp\CR1\part1000" "E:\radack\cm-work\part1000\part1000_c\part1000"
#
################################################################################

use strict;

BEGIN {
    $| = 1
}

main();

sub main {
    my $source_root = $ARGV[0];
    my $dest_root = $ARGV[1];
    my $change_list_path = $ARGV[2];
    my $pub_date = $ARGV[3];

    process($source_root, $dest_root, $change_list_path, $pub_date);
}

sub process {
    my ($source_root, $dest_root, $change_list_path, $pub_date) = @_;
    my @change_list = read_change_list($change_list_path);

    foreach my $part_rel_path (@change_list) {
	process_part($source_root, $dest_root, $part_rel_path, $pub_date);
    }
}

sub read_change_list {
    my ($change_list_path) = @_;
    my @change_list;
    my $line;
    open CHANGE_LIST_FILE, $change_list_path || die "Could not open $change_list_path\n";
    while ($line = <CHANGE_LIST_FILE>) {
	my $change_elt = $line;
	$change_elt =~ s/^\s*//;
	$change_elt =~ s/\s*$//;
	push(@change_list,$change_elt);
    }
    return @change_list;
}

sub process_part {
    my ($source_root, $dest_root, $part_rel_path, $pub_date) = @_;
    print "processing part: $part_rel_path\n";
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
	foreach $child (@children) {
	    process_node($source_root, $dest_root, "$node_rel_path/$child", $pub_date);
	}
    }
    if (-f $source_node_path) {
	if ($node_rel_path =~ /\.htm$/) {
	    process_file($source_root, $dest_root, $node_rel_path, $pub_date);
	}
    }
}

sub process_file {
    my ($source_root, $dest_root, $node_rel_path, $pub_date) = @_;
    my $source_file_path = "$source_root/$node_rel_path";
    my $dest_file_path = "$dest_root/$node_rel_path";
    my $pub_year_mo = $pub_date;
    $pub_year_mo =~ s/-[0-9]+$//;
    my $pub_year = $pub_year_mo;
    $pub_year =~ s/-[0-9]+$//;
    my $line;
    my $content = "";
    open SOURCE_FILE, $source_file_path || die "Could not open input file $source_file_path";
    while ($line = <SOURCE_FILE>) {
	$content = $content . $line;
    }
    # Check whether this file has information that needs to be changed.
    # This can be determined from the presences of a <TITLE> element.
    if ($content =~ m%<(TITLE|title)>ISO/TS 10303-([0-9]+):[0-9]{4} ([^<]+)</(TITLE|title)>%) {
	my $part_number = $2;
	my $part_title = $3;
	while ($content =~ s%\(ISO/TS 10303-$part_number:([0-9]+)\)%xxxx$1xxxx%) {
	}
	# change 1: replace "ISO/CD-TS" with "ISO/TS"
	$content =~ s|ISO/CD-TS|ISO/TS|g;
	# change 2: replace date in part number with <pub_year_mo>
	$content =~ s|10303-$part_number:[0-9]{4}|10303-$part_number:$pub_year_mo|g;
	# change 3: remove superscript reference to "To be published" footnote
	$content =~ s|<sup><a href="#tobepub">1</a>\)</sup>||g;
	# change 4: remove "To be published" footnote
	$content =~ s|<a name="tobepub"><sup>1\)</sup> To be published\.[^<]*</a>||g;
	# change 5: replace date in footer with <pub_year>
	$content =~ s%&copy;(:&nbsp;| )+ISO(:&nbsp;| )+[0-9]{4}%&copy; ISO $pub_year%g;
	$content =~ s%\xc2\xa9(:&nbsp;| )+ISO(:&nbsp;| )+[0-9]{4}%&copy; ISO $pub_year%g;
	# change 6: replace publication date on cover page with <pub_date>
	$content =~ s^<b>([a-zA-Z]+)&nbsp;edition&nbsp;&nbsp;([0-9]{4}-[0-9]{2}-[0-9]{2}|\@to_be_published\@)</b>^<div align="center" style="margin-top:50pt"><span style="font-size:12; font-family:sans-serif;"><b>$1&nbsp;edition&nbsp;&nbsp;$pub_date</b>^;
	# change 7: remove "Price based on <nn> pages"
	$content =~ s|<td width="220" align="right" valign="top"><span style="font-size:14; font-family:sans-serif;"><b>Price based on [0-9]+ +pages</b></span></td>||g;
	$content =~ s|xxxx([0-9]+)xxxx|(ISO/TS 10303-$part_number:$1)|;
	open DEST_FILE, ">$dest_file_path" || die "Could not open output file $dest_file_path";
	print DEST_FILE $content;
	close DEST_FILE;
    }
    close SOURCE_FILE;
}
