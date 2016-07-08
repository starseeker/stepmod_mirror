################################################################
# Launches the update from a folder in Kevin's computer
# /Users/klt/Projects/EclipseWS/stepmod/etc/ap242/
# For input excel sheet with a named columns table:
# A = 'WG12 nb', B,C,D empty, E = no name and contains 'ISO 10303-', F  ='Module part number', 
# G = no name and contains 'ed', H = 'Edition', I ='Module name', J = 'Element type'
# K = no name, contains the date, L='wg updated in stepmod?'





#!/usr/bin/perl -w
use strict;
use warnings;
use Spreadsheet::ParseXLSX;
use XML::Twig;
use File::Copy qw(move);

###############################################################
# main
###############################################################

###############################################################
# Open an excel file
###############################################################

my $parser= Spreadsheet::ParseXLSX->new();
# Check the true location in STEPmod
#my $workbook= $parser->parse("/Users/aminata/Documents/ISO/WG12/STEP-ISO10303/stepmod/AP242ed2_CR11_WG_Numbers.xlsx");
my $workbook= $parser->parse("/Users/klt/Projects/EclipseWS/stepmod/etc/ap242/AP242ed2_CR11_WG_Numbers.xlsx");

if (!defined $workbook) {
	die $parser->error(), ".\n";
}

###############################################################
# Collecting the different values in the excel file 
###############################################################
#Creation of a table composed of the necessary values for the update 
my @table;
my @doctable;
#Column number in the excel sheet:
my $WGnb_col;
my $ed_col;
my $type_col;
my $modified_col;
my $name_col;
# Line number of the module:
my $ligne;
my $count = 1;
for my $worksheet ($workbook->worksheets()) {
	my ($row_min, $row_max) = $worksheet->row_range();
	my ($col_min, $col_max) = $worksheet->col_range();

	#Search and save of the different columns
	my $rowi = 0;
	for my $col ($col_min .. $col_max) {
		my $cell = $worksheet->get_cell( $rowi, $col);
		next unless $cell;
		if ($cell->value() eq "WG12 nb"){
			$WGnb_col = $col;
		}
		elsif ($cell->value() eq "Edition"){
			$ed_col = $col;
		}
		elsif ($cell->value() eq "Element type"){
			$type_col = $col;
		}
		elsif ($cell->value() eq "wg updated in stepmod?"){
			$modified_col = $col;
			#print "$modified_col\n";
		}
		elsif ($cell->value() eq "Module name"){
			$name_col = $col;
		}
	}
#Saving of non modified modules 
	for my $row ($row_min .. $row_max) {
		my $cell = $worksheet->get_cell( $row, $modified_col);
		my $value = $cell->value();
		if ($row != 0 && $value ne 'y') {
			my $WGnb_cell = $worksheet->get_cell( $row, $WGnb_col);
			my $ednb_cell = $worksheet->get_cell( $row, $ed_col);
			my $name_cell = $worksheet->get_cell( $row, $name_col);
			my $WGnb = $WGnb_cell->value();
			my $ednb = $ednb_cell->value();
			my $name = $name_cell->value();
			my $type_cell = $worksheet->get_cell( $row, $type_col);
			if (defined $name && $name ne ""){
				$name = lc($name);
				chomp $name;
				$count = $count +1;
				if ($type_cell->value() eq 'ARM EXPRESS') {
					updatearm($WGnb, $name);
				}
				if ($type_cell->value() eq 'MIM EXPRESS') {
					updatemim($WGnb, $name);
				}
				if ($type_cell->value() eq 'Document') {
					my $WGnbarm;
					my $WGnbmim;
					for my $otherrow ($row_min .. $row_max) {
						my $same_name_cell = $worksheet->get_cell( $otherrow, $name_col);
						my $othertype = $worksheet->get_cell( $otherrow, $type_col);
						if  ($same_name_cell->value() eq $name && $othertype->value() eq 'ARM EXPRESS') {
							my $WGnbarm_cell =  $worksheet->get_cell( $otherrow, $WGnb_col);
							$WGnbarm = $WGnbarm_cell->value();
						}
						elsif ($same_name_cell->value() eq $name && $othertype->value() eq 'MIM EXPRESS') {
							my $WGnbmim_cell =  $worksheet->get_cell( $otherrow, $WGnb_col);
							$WGnbmim = $WGnbmim_cell->value();
						}
					}
					#print "$WGnbarm et $WGnbmim\n";
					updatemodule($WGnb, $name, $ednb, $WGnbarm, $WGnbmim);
				}
			}	
		}
	}
}
print "$count modules updated\n";

###############################################################
# ARM's modification
###############################################################
sub updatearm {
	my ($WGnb, $name) = @_;
	my $Nnb;
	my $filename = "/Users/klt/Projects/EclipseWS/stepmod/data/modules/$name/arm.exp";
	my $newfile= "/Users/klt/Projects/EclipseWS/stepmod/data/modules/$name/temp.txt";
#	my $filename = "/Users/aminata/Documents/ISO/WG12/STEP-ISO10303/stepmod/assembly_component/arm.exp";
	my ($fh,$fh2);
	open ($fh,'<', $filename) or die "Impossible d'ouvrir le fichier $filename en lecture\n";
	open ($fh2, '>>', $newfile) or die "Impossible d'ouvrir le fichier $newfile en écriture \n";
	my $line;
	while (defined ($line = <$fh>)){
		my $char = 'ISO TC184/SC4/WG12 ';
		my $result = index($line,$char);
		my $char1 = 'Supersedes ISO TC184/SC4/WG12 ';
		my $result1 = index($line, $char1);
		if ($result != -1 && $line=~ m/-/) { #groups the 2 conditions in one 
			$result = $result +19;
			$Nnb= substr ($line, $result, 5);
			#print $str."\n";
			$line=~ s/$Nnb/$WGnb/g;
#			print "$line\n";
		}
		elsif ($result1 != -1) {
			$result1 = $result1 + 30;
			my $str1 = substr ($line, $result1, 5);
			$line =~ s/$str1/$Nnb/g;
#			print "$line\n";
		}
		print $fh2 $line; #deletes then re-write the all document
	}
	close $fh;
	close $fh2;
	unlink $filename;
	#File::Copy module for the naming of files
	move $newfile, $filename;	

}

###############################################################
# MIM's modification
###############################################################
sub updatemim {
	my ($WGnb, $name) = @_;
	my $Nnb;
	my $filename = "/Users/klt/Projects/EclipseWS/stepmod/data/modules/$name/mim.exp";
	my $newfile= "/Users/klt/Projects/EclipseWS/stepmod/data/modules/$name/temp.txt";
#	my $filename = "/Users/aminata/Documents/ISO/WG12/STEP-ISO10303/stepmod/assembly_component/mim.exp";
	my ($fh,$fh2);
	open ($fh,'<', $filename) or die "Impossible d'ouvrir le fichier $filename en lecture\n";
	open ($fh2, '>>', $newfile) or die "Impossible d'ouvrir le fichier $newfile en écriture \n";
	my $line;
	while (defined ($line = <$fh>)){
		my $char = 'ISO TC184/SC4/WG12 ';
		my $result = index($line,$char);
		my $char1 = 'Supersedes ISO TC184/SC4/WG12 ';
		my $result1 = index($line, $char1);
		if ($result != -1 && $line=~ m/-/) { 
			$result = $result +19;
			$Nnb= substr ($line, $result, 5);
			#print $str."\n";
			$line=~ s/$Nnb/$WGnb/g;
#			print "$line\n";
		}
		elsif ($result1 != -1 && $line=~ m/Supersedes/) {
			$result1 = $result1 + 30;
			my $str1 = substr ($line, $result1, 5);
			$line =~ s/$str1/$Nnb/g;
#			print "$line\n";
		}
		print $fh2 $line; #deletes then re-write the all document
	}
	close $fh;
	close $fh2;
	unlink $filename;
	#File::Copy module for the naming of files
	move $newfile, $filename;
}
###############################################################
# module.xml modification
###############################################################
sub updatemodule {
	#print "into the function\n";
	my ($WGnb, $name, $ednb, $WGnbarm, $WGnbmim) = @_;
	my $filename = "/Users/klt/Projects/EclipseWS/stepmod/data/modules/$name/module.xml";
	my $newfile= "/Users/klt/Projects/EclipseWS/stepmod/data/modules/$name/temp.txt";
#	my $filename = "/Users/aminata/Documents/ISO/WG12/STEP-ISO10303/stepmod/assembly_component/module.xml";
#	my $filename = "/Users/aminata/Documents/ISO/WG12/STEP-ISO10303/stepmod/functional_specification/module.xml";
	my ($fh,$fh2);
	open ($fh,'<', $filename) or die "Impossible d'ouvrir le fichier $filename en lecture\n";
	open ($fh2, '>>', $newfile) or die "Impossible d'ouvrir le fichier $newfile en écriture \n";
	my $line;
	my $wgnumber;
	my $wgnumberarm;
	my $wgnumbermim;
	my $pubyear;
	while (defined ($line = <$fh>)){
		my $char = 'version="';
		my $char1 = 'wg.number="';
		my $char2 = 'wg.number.arm="';
		my $char3 = 'wg.number.mim="';
		my $char4 = 'wg.number.supersedes="';
		my $char5 = 'wg.number.arm.supersedes="';
		my $char6 = 'wg.number.mim.supersedes="';
		my $char7 = 'publication.year="';
		my $char8 = 'publication.date="';
		my $char9 = 'previous.revision.year="';
		my $result = index($line, $char);
		my $result1 = index($line, $char1);
		my $result2 = index($line, $char2);
		my $result3 = index($line, $char3);
		my $result4 = index($line, $char4);
		my $result5 = index($line, $char5);
		my $result6 = index($line, $char6);
		my $result7 = index($line, $char7);
		my $result8 = index($line, $char8);
		my $result9 = index($line, $char9);
		if ($result != -1 && $line=~ m/version="/) {
			unless ($line=~m/change version/ || $line=~m/xml version/){
				my $offset = $result + 10;
				my $limit = index($line, '"', $offset);
				my $length = $limit - $result;
				my $str = substr($line, $result, $length);
#				print "$str\n";
				$line =~ s/$str/version="$ednb/g;
#				print $line; 
			}
		}
		if ($result1 != -1 && $line=~ m/wg.number="/) {
			my $offset = $result1 + 12;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result1;
			$wgnumber = substr($line, $result1, $length);
#			print "$wgnumber\n";
			my $Nindex= index($WGnb, 'N') +1;
			my $WGnb1= substr($WGnb, $Nindex, 4);
			$line =~ s/$wgnumber/wg.number="$WGnb1/g;
#			print $line;
		}
		if ($result2 != -1 && $line=~ m/wg.number.arm="/) {
			my $offset = $result2 + 16;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result2;
			if (defined $WGnbarm){
				$wgnumberarm = substr($line, $result2, $length);
				my $Nindex= index($WGnbarm, 'N') +1;
				my $WGnbarm1= substr($WGnbarm, $Nindex, 4);
				$line =~ s/$wgnumberarm/wg.number.arm="$WGnbarm1/g;
			}
#			print $line;
		}
		if ($result3 != -1 && $line=~ m/wg.number.mim="/) {
			my $offset = $result3 + 16;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result3;
			if (defined $WGnbmim){
				$wgnumbermim = substr($line, $result3, $length);
				my $Nindex= index($WGnbmim, 'N') +1;
				my $WGnbmim1= substr($WGnbmim, $Nindex, 4);
				$line =~ s/$wgnumbermim/wg.number.mim="$WGnbmim1/g;
			}
#			print $line;
		}
		if ($result4 != -1 && $line=~ m/wg.number.supersedes="/) {
			my $offset = $result4 + 23;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result4;
			my $str = substr($line, $result4, $length);
#			print "$wgnumber\n";
			if (defined $wgnumber){
				my $tronc = substr($wgnumber, 11, 4);
#				print "$tronc\n";
				$line =~ s/$str/wg.number.supersedes="$tronc/g;
			}
#			print $line;
		}
		if ($result5 != -1 && $line=~ m/wg.number.arm.supersedes="/) {
			my $offset = $result5 + 27;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result5;
			my $str = substr($line, $result5, $length);
			if (defined $wgnumberarm){
				my $tronc = substr($wgnumberarm, 15, 4);
#				print "$tronc\n";
				$line =~ s/$str/wg.number.arm.supersedes="$tronc/g;
			}
#			print $line;
		}
		if ($result6 != -1 && $line=~ m/wg.number.mim.supersedes="/) {
			my $offset = $result6 + 27;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result6;
			my $str = substr($line, $result6, $length);
			if (defined $wgnumbermim){
				my $tronc = substr($wgnumbermim, 15, 4);
#				print "$tronc\n";
				$line =~ s/$str/wg.number.mim.supersedes="$tronc/g;
			}
#			print $line;
		}
		if ($result7 != -1 && $line=~ m/publication.year="/) {
			my $offset = $result7 +19;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result7;
			$pubyear = substr($line, $result7, $length);
			$line =~ s/$pubyear/publication.year="2015-12/g;
#			print $line;
		}
#		print "$pubyear\n";
		if ($result8 != -1 && $line=~ m/publication.date="/) {
			my $offset = $result8 + 19;
			my $limit = index($line, '"', $offset);
			my $length = $limit - $result8;
			my $str = substr($line, $result8, $length);
			$line =~ s/$str/publication.date="2015-12-15/g;
#			print $line;
		}
		if ($result9 != -1 && $line=~ m/previous.revision.year="/) {
			my $offset = $result9 + 24;
			my $limit = index($line, '"', $offset); 
			my $length = $limit - $result9;
			my $str = substr($line, $result9, $length);
			if (defined $pubyear){
				my $tronc = substr($pubyear, 18, 7);
#				print "$tronc\n";
				$line =~ s/$str/previous.revision.year="$tronc/g;
			}
#			print $line;
		}
		print $fh2 $line;
	}
	close $fh;
	close $fh2;
	unlink $filename;
	# File::Copy module for the naming of files
	move $newfile, $filename;
}