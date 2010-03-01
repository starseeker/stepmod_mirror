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
#   perl list_changed_files <alert_file>
#
# where:
#
#   <alert_file> is the path of a text file containing all the alerts
#
# Example:
#
#   perl c:\radack\stepmod\stepmod\utils\part1000\list_changed_files.pl ^
#   "C:\temp\alerts.txt"
#
################################################################################

use strict;

my $prefix = "http://sp.tc184-sc4.org/ISO-Editor-Review/Editor%20Review%20Library/SMRL%20Snapshot";

BEGIN {
    $| = 1
}

main();

sub main {
    my $alert_path = $ARGV[0];

    process($alert_path);
}

sub process {
    my ($alert_path) = @_;
    my $line;

    my $result = open(ALERT_FILE,$alert_path) || die "Cannot open $alert_path: $1\n";
    while ($line = <ALERT_FILE>) {
	if ($line =~ /([^ ]+) has been changed/) {
	    if (!($line = <ALERT_FILE>)) {
		die "Premature EOF encountered.";
	    }
	    my $changed_file = $1;
	    if ($line =~ m|View $changed_file <$prefix/(data/.*/$changed_file)>|) {
		my $changed_file_path = $1;
		print "$changed_file_path\n";
	    }
	    else {
		die "Expected pattern not found";
	    }
	}
    }
}
