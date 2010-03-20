#!/usr/local/bin/perl

################################################################################
#
# Description:
#
#   Create an HTML table of the parts in a SMRL directory structure.
#   The table will include the following columns:
#     - Part #
#     - Edition
#     - English Title
#     - French Title
#
# Usage:
#
#   perl {-part_list=<part_list>} {-html-out=<out_file>} list_parts <source_root> 
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
#   perl list_parts.pl -part-list=CR1_parts.txt SMRL
#
################################################################################

use strict;
use File::Spec;
use Getopt::Long;


BEGIN {
    $| = 1
}

main();

sub main {
    my $part_list_path = "";
    my $html_out_file_path = "out.html";
    my $result = GetOptions ("part-list=s" => \$part_list_path,
	"-html-out=s" => \$html_out_file_path);

    my $source_root = $ARGV[0];

    open HTMLFILE, ">$html_out_file_path";
    print HTMLFILE "<?html version=\"1.0\"?>\n";
    print HTMLFILE "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n";
    print HTMLFILE "<html>\n";
    print HTMLFILE "<head>\n";
    print HTMLFILE "<style type=\"text/css\">\n";
    print HTMLFILE "th {vertical-align:top;}\n";
    print HTMLFILE "td {vertical-align:top;}\n";
    print HTMLFILE "</style>\n";
    print HTMLFILE "</head>\n";
    print HTMLFILE "<body>\n";
    print HTMLFILE "<table border=\"1\">\n";
    print HTMLFILE "<tr>\n";
    print HTMLFILE "<th>Part #</th>\n";
    print HTMLFILE "<th>Ed</th>\n";
    print HTMLFILE "<th>Date</th>\n";
    print HTMLFILE "<th>English Title</th>\n";
    print HTMLFILE "<th>French Title</th>\n";
    if ($part_list_path eq "") {
	process_node($source_root, "");
    }
    else {
	process_part_list($source_root, $part_list_path);
    }
    print HTMLFILE "</table>\n";
    print HTMLFILE "</body>";
    print HTMLFILE "</html>";
    close HTMLFILE;
}

my $arg_count = 0;

sub ord_to_card {
    my ($card) = @_;
    $card =~ s/First/1/;
    $card =~ s/Second/2/;
    $card =~ s/Third/3/;
    $card =~ s/Fourth/4/;
    $card =~ s/Fifth/5/;
    $card =~ s/Sixth/6/;
    $card =~ s/Seventh/7/;
    $card =~ s/Eighth/8/;
    $card =~ s/Ninth/9/;
    $card =~ s/Tenth/10/;
    return $card;
}

sub replace_entities {
    my ($str) = @_;
    #$str =~ s/&eacute;/&#201;/g;
    #$str =~ s/&egrave;/&#200;/g;
    #$str =~ s/&acirc;/&#194;/g;
    return $str;
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
	    process_node($source_root, "$node_rel_path/$child");
	}
    }
    if (-f $source_node_path && $source_node_path =~ m/cover.htm$/) {
	process_file($source_root, $node_rel_path);
    }
}

sub process_file {
    my ($source_root, $node_rel_path) = @_;
    my $source_file_path = "$source_root/$node_rel_path";
    print "processing $source_file_path\n";

    open SOURCE_FILE, $source_file_path || die "Could not open input file $source_file_path";
    my $line;
    my $content = "";
    while ($line = <SOURCE_FILE>) {
	$content = $content . $line;
    }
    close SOURCE_FILE;

    $content =~ m|Part ([0-9]+):|;
    my $part_number;
    my $french_title;
    my $english_title;
    my $edition;
    my $date;

    if ($content =~ m/Part [0-9]*:\s*<br><b>\s*Application module:\s*([^<]+)</) {
	$english_title = $1;
    }
    else {
	print "Error: counld not find English title.\n";
    }
    if ($content =~ m/Partie ([0-9]+):\s*Module d'application:\s*([^<]+)</) {
	$part_number = $1;
	$french_title = replace_entities($2);
    }
    else {
	print "Error: counld not find part number and French title.\n";
    }
    if ($content =~ m/([A-Za-z]+)&nbsp;edition&nbsp;&nbsp;([0-9]{4}-[0-9]{2}-[0-9]{2})/) {
	$edition = ord_to_card($1);
	$date = $2;
    }
    else {
	print "Error: counld not find edition and date.\n";
    }
    print HTMLFILE "<tr>\n";
    print HTMLFILE "<td class=\"part_number\">$part_number</part_number>\n";
    print HTMLFILE "<td class=\"edition\">$edition</edition>\n";
    print HTMLFILE "<td class=\"date\">$date</date>\n";
    print HTMLFILE "<td class=\"english_title\">$english_title</english_title>\n";
    print HTMLFILE "<td class=\"french_title\">$french_title</french_title>\n";
    print HTMLFILE "</tr>\n";
}
