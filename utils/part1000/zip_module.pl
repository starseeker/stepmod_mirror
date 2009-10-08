#!/usr/local/bin/perl

use strict;

use File::Spec qw(rel2abs);

my $work_path = $ENV{"PART1000_WORK"};
my $temp_dir = $ENV{"TEMP"};
my $zip_path;

BEGIN {
    $| = 1;
}

    my $module_list_path = $ARGV[0];
    $zip_path = File::Spec->rel2abs($ARGV[1]);

    my @list = read_file_into_list($module_list_path);

    process(@list);


sub read_file_into_list {
    my ($list_path) = @_;

    my @ret;

    open INPUT, "<$list_path";
    while ( my $line = <INPUT> ) {
	chomp $line;
	push @ret, $line;
    }
    close INPUT;
    @ret;
}

sub process {
    my (@list) = @_;
    chdir $work_path;

    foreach my $module_name (@list) {
	print "processing module: $module_name\n";
	my $link_path = write_link_file($module_name);
	my $readme_path = write_readme_file($module_name);
	print "link_path = $link_path\n";
	my $archive_path = "$zip_path/$module_name.zip";
	print "archive_path = $archive_path\n";
	# Delete previous version of the archive, if it exists.
	if (-f $archive_path) {
	    unlink($archive_path);
	}
	my $cmd = "7z a -tzip $archive_path data/modules/$module_name data/resources images -xr!.*";
	system($cmd) == 0 or die("system failed: $cmd");
	my $cmd = "7z a -tzip $archive_path $link_path $readme_path";
	system($cmd) == 0 or die("system failed: $cmd");
    }
}

sub get_link_fn {
    my ($module_path) = @_;
    my $link_fn;

    open INPUT, "<$module_path/sys/cover.htm";
    while ( <INPUT> ) {
	if (/<TITLE>(.+)<\/TITLE>/) {
	    $link_fn = $1;
	    $link_fn =~ tr/ \//__/;
	    $link_fn =~ s/:[0-9]{4}//;
	    $link_fn =~ s/ISO_TS_//;
	    $link_fn .= ".htm";
	}
    }
    close INPUT;
    if (length($link_fn) == 0) {
	die("error getting link filename for $module_path");
    }
    $link_fn;
}

sub get_readme_fn {
    my ($module_path) = @_;
    my $readme_fn;

    open INPUT, "<$module_path/sys/cover.htm";
    while ( <INPUT> ) {
	if (/<TITLE>ISO\/TS ([0-9]+-[0-9]+).*<\/TITLE>/) {
	    $readme_fn = $1;
	    $readme_fn .= "_readme.txt";
	}
    }
    close INPUT;
    if (length($readme_fn) == 0) {
	die("error getting readme filename for $module_path");
    }
    $readme_fn;
}

sub get_desig {
    my ($module_path) = @_;
    my $desig;

    open INPUT, "<$module_path/sys/cover.htm";
    while ( <INPUT> ) {
	if (/<TITLE>(ISO\/TS 10303-[0-9]+:[0-9]+).*<\/TITLE>/) {
	    $desig = $1;
	}
    }
    close INPUT;
    if (length($desig) == 0) {
	die("error getting title for $module_path");
    }
    $desig;
}

sub write_link_file {
    my ($module_name) = @_;
    my $module_path = "data/modules/$module_name";
    my $link_fn = get_link_fn($module_path);
    my $link_path = "$temp_dir/$link_fn";
    my $url = "./data/modules/$module_name/sys/cover.htm";
    
    print "write_link_file : $link_path\n";

    open OUTPUT, ">", $link_path;

    print OUTPUT "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>\n";
    print OUTPUT "<html>\n";
    print OUTPUT "   <head>\n";
    print OUTPUT "      <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";
    print OUTPUT "   \n";
    print OUTPUT "      <meta http-equiv='Refresh' content='5; URL=$url'>\n";
    print OUTPUT "      <title>Module index redirection</title>\n";
    print OUTPUT "   </head>\n";
    print OUTPUT "   <body>You will be redirected to $url in 5 seconds<br>\n";
    print OUTPUT "      If not select \n";
    print OUTPUT "      <a href='$url'>$url</a></body>\n";
    print OUTPUT "</html>\n";
    close OUTPUT;

    $link_path;
}

sub write_readme_file {
    my ($module_name) = @_;
    my $link_fn = get_link_fn("data/modules/$module_name");
    my $readme_fn = get_readme_fn("data/modules/$module_name");
    my $readme_path = "$temp_dir/$readme_fn";
    my $module_path = "data/modules/$module_name";
    my $desig = get_desig($module_path);
    my $url = "./$module_path/sys/cover.htm";
    
    print "write_readme_file : $readme_path\n";
    print "desig = $desig\n";

    open OUTPUT, ">", $readme_path;

    print OUTPUT "$desig\n";
    print OUTPUT "TC 184/SC 4\n";
    print OUTPUT "\n";
    print OUTPUT "To expand the document, unzip the file into an empty directory.\n";
    print OUTPUT "\n";
    print OUTPUT "If asked when unzipping the file, you should overwrite any\n";
    print OUTPUT "file in the images directory.\n";
    print OUTPUT "\n";
    print OUTPUT "NOTE If you already purchased other application modules, then unzip the\n";
    print OUTPUT "file into the same directory as the other modules.\n";
    print OUTPUT "\n";
    print OUTPUT "To access the document open the file \"$link_fn\".\n";
    print OUTPUT "\n";
    print OUTPUT "The folders:\n";
    print OUTPUT "  \"data\"\n";
    print OUTPUT "  \"images\"\n";
    print OUTPUT "contain the various components of the main document.\n";
    print OUTPUT "\n";
    print OUTPUT "NOTE The HTML will have a number of broken links as this part is\n";
    print OUTPUT "dependent on a number of other ISO 10303 parts which are listed\n";
    print OUTPUT "in the normative references in Clause 2.\n";

    close OUTPUT;

    $readme_path;
}
