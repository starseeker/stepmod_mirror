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
#   perl {-part_list=<part_list>} {-html-out=<html_out_file>} {-csv-out=<csv_out_file>} list_parts <source_root> 
#
# where:
#
#   <source_root> is the path of the directory containing the parts to be
#   listed.
#
# Options:
#
#   -html-out=<html_out_file>
#
#     Write HTML output to <out_file>. If not specified, output is written
#     to out.html.
#
#   -csv-out=<csv_out_file>
#
#     Write CSV output to <out_file>. If not specified, output is written
#     to out.csv.
#
#   -bad-out=<bad_out_file>
#
#     Write list of bad files to <out_file>. If not specified, output is
#     written to bad_files.txt.
#
#   -part_list=<part_list>
#
#     List parts in a given list. <part_list> is the path of a file containing
#     a list of relative directory paths of the parts to be listed. If not 
#     given, all parts under <source_root> listed.
#
# Example:
#
#   perl list_parts -part-list=CR1_parts.txt SMRL
#
################################################################################

#use strict;
#use re 'debug';
use Utils;
use File::Spec;
use Getopt::Long;
use Desig_info;


BEGIN {
    $| = 1
}

main();

sub main {
    my $part_list_path = "";
    my $html_out_file_path = "out.html";
    my $csv_out_file_path = "out.csv";
    my $bad_out_file_path = "bad_files.txt";
    my $result = GetOptions (
	"part-list=s" => \$part_list_path,
	"-html-out=s" => \$html_out_file_path,
	"-csv-out=s" => \$csv_out_file_path,
	"-bad-out=s" => \$bad_out_file_path
	);

    my $source_root = $ARGV[0];

    open ERRORFILE, ">$bad_out_file_path";
    open CSVFILE, ">$csv_out_file_path";
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
    print HTMLFILE "</body\n";
    print HTMLFILE "</html>\n";
    close HTMLFILE;
    close CSVFILE;
    close ERRORFILE;
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
	    if ($child ne "library") {
		process_node($source_root, $child_rel_path);
	    }
	}
    }
    if (-f $source_node_path && $source_node_path =~ m/cover.htm$/) {
	process_file($source_root, $node_rel_path);
    }
}

sub process_file {
    my ($source_root, $node_rel_path) = @_;
    my $source_file_path = "$source_root/$node_rel_path";
    my $error = 0;
    print "processing $source_file_path\n";

    open SOURCE_FILE, $source_file_path || die "Could not open input file $source_file_path";
    my $line;
    my $content = "";
    while ($line = <SOURCE_FILE>) {
	$content = $content . $line;
    }
    close SOURCE_FILE;

    $content =~ s/&nbsp;/ /g;
    $content =~ s/\s+/ /g;
    $content =~ s/ :/:/g;
    #$content =~ m|Part ([0-9]+):|;
    my $part_number;
    my $french_title;
    my $english_title;
    my $edition;
    my $date;
    my $top_desig;
    my $top_info;
    my $gateway_desig;
    my $gateway_info;

    if ($content =~ m@(?:TECHNICAL SPECIFICATION|INTERNATIONAL STANDARD) ([^<]+)<@) {
	$top_desig = $1;
	$top_desig = Utils::trim($top_desig);
    }
    else {
	print "Error: could not find top\n";
	$error = 1;
    }

    if ($content =~ m/Part ([0-9]*):/) {
	$part_number = $1;
    }
    else {
	print "Error: could not find part number.\n";
	$error = 1;
    }
    if ($content =~ m/(?:Integrated generic resource|Integrated application resource|Application module)[ ]?:[ ]?([^<"]+)</) {
	$english_title = $1;
    }
    else {
	print "Error: could not find English title.\n";
	$error = 1;
    }
    if ($content =~ m/(?:Ressources? g&eacute;n&eacute;riques? int&eacute;gr&eacute;es?|Ressources? d'application int&eacute;gr&eacute;es?|Module d'application):([^<]+)/) {
	$french_title = $1;
    }
    else {
	print "Error: could not find French title.\n";
	$error = 1;
    }
    if ($content =~ m|<a href="./contents.htm" target="_self">([^<]*)</a>|) {
	$gateway_desig = $1;
	$gateway_desig = Utils::trim($gateway_desig);
    }
    else {
	print "Error: could not find gateway.\n";
	$error = 1;
    }
    if ($content =~ m/(First|Second|Third|Fourth|Fifth|Sixth|Seventh|Eighth|Ninth|Tenth|Eleventh|Twelfth|Thirteenth|Fourteenth|Fifteenth|Sixteenth|Seventeenth|Eighteenth|Nineteenth|Twentieth) edition ([0-9]{4}-[0-9]{2}-[0-9]{2})/) {
	$edition = ord_to_card($1);
	$date = $2;
    }
    else {
	print "Error: could not find edition and date.\n";
	$error = 1;
    }

    $top_info = new Desig_info($top_desig);

    # check 1: top designation and gateway designation match
    if ($top_desig ne $gateway_desig) {
	print "Error: top designation and gateway designation do not match\n";
	print "top designation = $top_desig\n";
 	print "gateway designation = $gateway_desig\n";
	$error = 1;
    }

    # check 2: top part number and title part number
    my $top_part_number = $top_info->{_part_number};
    if ($part_number ne $top_part_number) {
	print "Error: part number mismatch\n";
	print "part_number = $part_number\n";
	print "top_part_number = $top_part_number\n";
	$error = 1;
    }

    # check 3: top date and publication date match
    my $date_info = new Date_info($date);
    my $top_date_info = $top_info->{_date_info};

    {
	my $year = $date_info->{_year};
	if ($year < 2010) {
	    if (!$date_info->matches_year($top_date_info)) {
		print "Error: top date does not match publication date.\n";
		print "date:\n";
		$date_info->print();
		print "top_date:\n";
		$top_date_info->print();
		$error = 1;
	    }
	}
	else {
	    if (!$date_info->matches_year_month($top_date_info)) {
		print "Error: top date does not match publication date.\n";
		print "date:\n";
		$date_info->print();
		print "top_date:\n";
		$top_date_info->print();
		$error = 1;
	    }
	}
	if ($error) {
	    print ERRORFILE "$source_file_path\n";
	}
    }

    print HTMLFILE "<tr>\n";
    print HTMLFILE "<td class=\"part_number\">$part_number</part_number>\n";
    print HTMLFILE "<td class=\"edition\">$edition</edition>\n";
    print HTMLFILE "<td class=\"date\">$date</date>\n";
    print HTMLFILE "<td class=\"english_title\">$english_title</english_title>\n";
    print HTMLFILE "<td class=\"french_title\">$french_title</french_title>\n";
    print HTMLFILE "</tr>\n";
    print CSVFILE "\"$source_file_path\",$part_number,$edition,$date,\"$top_desig\",\"$english_title\",\"$french_title\",$error\n";
}
