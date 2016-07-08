#!/usr/bin/perl -w

##### The file needs to be put in /stepmod/utils/
##### To launch the script:
#####	0) For input: A = N number, B = name, C and D = nothing, E = name of the document, F = date
#####	1) make sure that perl is installed on your computer
#####	2) make sure that perl modules (Spreadsheet::ParseXLSX, XML::Twig, and File::Copy are installed)
#####	3) using your command line tool, set your working directory to stepmod/utils
#####	4) launch the script 'perl update_module.pl'

use strict;
use warnings;
use Spreadsheet::ParseXLSX;
use XML::Twig;
use File::Copy qw(move);


###############################################################
#Open the excel file
###############################################################

my $parser= Spreadsheet::ParseXLSX->new();
#my $workbook= $parser->parse("/Users/aminatambengue/Documents/ISO/WG12/STEP-ISO10303/stepmod/CR_Geometry_WG_Numbers_table_example.xlsx");
my $workbook= $parser->parse("../publication/part1000/CR_Geometry/CR_Geometry_WG_Numbers_table.xlsx");

if (!defined $workbook) {
	die $parser->error(), ".\n";
}

###############################################################
# Collecting the different values in the excel file 
###############################################################
# Columns number in the excel sheet
my $WGnb_col = 0;
my $info_col = 4;
# initialization of the variables
my @type;
my @table;
# Read the excel sheet and save the variables 
for my $worksheet ($workbook->worksheets()) {
    my ($row_min, $row_max) = $worksheet->row_range();
    for my $row ($row_min .. $row_max) {
        my $info_cell = $worksheet->get_cell( $row, $info_col);
        my $info = $info_cell->value();
####### Get the name of the document to modify
        my $ed = index($info,'ed');
####### to only get modules (4 numbers after ISO 10303-xxxx)
        if ($ed == 15){ 
        	my $wgnb_cell = $worksheet->get_cell( $row, $WGnb_col);
        	$table[0] = $wgnb_cell->value();
        	my $nb1 = $ed +4; #ed + the number + the spaces
########### Action for each type of document
        	$type[0] = 'Document';
        	$type[1] = 'ARM EXPRESS';
        	$type[2] = 'MIM EXPRESS';
        	for my $elt (@type){
        		if ($info =~ m/$elt/){
        			my $nb2 = index($info, $elt) -1;
        			my $length = $nb2-$nb1;	
        			$table[1] = substr($info,$nb1,$length);
        			chomp $table[1];
        			$table[2] = $elt;
        		}
        	}
        	if ($table[2] ne 'Document') {
				update($table[0], $table[1], $table[2]);
		 	}	
		 	if ($table[2] eq 'Document') {
					my $WGnbarm;
					my $WGnbmim;
					for my $otherrow ($row_min .. $row_max) {
						my $cell = $worksheet->get_cell( $otherrow, $info_col);
						my $info1 = $cell->value();
						my $ed1 = index($info1,'ed');
						if ($ed1 == 15){ 
							my $nb3 = $ed1 +4;
							if ($info1 =~ m/$type[1]/){
								my $nb4 = index($info1, $type[1]) -1;
								my $length1 = $nb4-$nb3;
								my $name = substr($info1,$nb3,$length1);
								chomp $name;
								if ($name eq $table[1]){
									my $arm = $worksheet->get_cell( $otherrow, $WGnb_col);
									$WGnbarm = $arm->value();
								}	
							}
							if ($info1 =~ m/$type[2]/){
								my $nb4 = index($info1, $type[2]) -1;
								my $length1 = $nb4-$nb3;
								my $name = substr($info1,$nb3,$length1);
								chomp $name;
								if ($name eq $table[1]){
									my $mim = $worksheet->get_cell( $otherrow, $WGnb_col);
									$WGnbmim = $mim->value();
								}
							} 	
						}
					}
					updatemodule($table[0], $table[1], $WGnbarm, $WGnbmim);
		  	}
         }
     }
}

###############################################################
# ARM or MIM modification
###############################################################
###### for tests ######
# gray up filenames, newfiles, open fh2 , print fh2, close fh2, unlink filename, move
sub update {
	my ($WGnb, $name, $type) = @_;
	my $filename;
	if ($type eq 'ARM EXPRESS'){
		 $filename = "../data/modules/$name/arm.exp"; 
		#$filename = "/Users/aminatambengue/Documents/ISO/WG12/STEP-ISO10303/stepmod/assembly_component/arm.exp";
	}
	if ($type eq 'MIM EXPRESS'){
		 $filename = "../data/modules/$name/mim.exp";		
		#$filename = "/Users/aminatambengue/Documents/ISO/WG12/STEP-ISO10303/stepmod/assembly_component/mim.exp";
	}	
	my $newfile= "../data/modules/$name/temp.txt";
	my ($fh,$fh2);
	open ($fh,'<', $filename) or die "Impossible d'ouvrir le fichier $filename en lecture\n";
	open ($fh2, '>>', $newfile) or die "Impossible d'ouvrir le fichier $newfile en écriture \n";
	my $line;
	while (defined ($line = <$fh>)){
		my $char = 'N';
		my $result = index($line,$char);
		my $title = 'ISO TC184/SC4/WG12';
		if ($line =~ m/$title/ && $line=~ m/-/) { 
			my $Nnb= substr ($line, $result, 5);
			$line=~ s/$Nnb/$WGnb/g;
			print "$line\n";
		}
####### effacer puis réécrire tout le document		
		print $fh2 $line; 
	}
	close $fh;
	close $fh2;
	unlink $filename;
### module File::Copy pour le renommage de fichiers
	move $newfile, $filename;	
}

###############################################################
# module.xml modification
###############################################################
###### for tests ######
# gray up filenames, newfiles, open fh2 , print fh2, close fh2, unlink filename, move
sub updatemodule {
	my ($mod, $name, $arm, $mim)=@_;
	print "Module: $name\n";
	my $filename = "../data/modules/$name/module.xml";
	my $newfile= "../data/modules/$name/temp.txt";
	#my $filename = "/Users/aminatambengue/Documents/ISO/WG12/STEP-ISO10303/stepmod/assembly_component/module.xml";
	#my $filename = "/Users/aminatambengue/Documents/ISO/WG12/STEP-ISO10303/stepmod/functional_specification/module.xml";
	my ($fh,$fh2);
	open ($fh,'<', $filename) or die "Impossible d'ouvrir le fichier $filename en lecture\n";
	open ($fh2, '>>', $newfile) or die "Impossible d'ouvrir le fichier $newfile en écriture \n";
	my $line;
	my $pubyear = '2015-05';
	my $pubdate = '2015-05-15';
	while (defined ($line = <$fh>)){
####### replace the wg number
		my @wg;
		$wg[0] = 'wg.number="';
		$wg[1] = 'wg.number.arm="';
		$wg[2] = 'wg.number.mim="';
		$wg[3] = 'publication.year="';
		$wg[4] = 'publication.date="';
		for my $elt(@wg){
			if ($line =~ m/$elt/) { 
				my $result = index($line, $elt);
				my $lg = length($elt);
				my $offset = $result + $lg;
				my $limit = index($line, '"', $offset);
				my $length = $limit - $offset;
				if (defined $mod && $elt eq $wg[0]){
					my $old = substr($line, $offset, $length);
					my $Nindex= index($mod, 'N') +1;
					my $wgnb= substr($mod, $Nindex, 4);
					$line =~ s/$old/$wgnb/g;
				}
				if (defined $arm && $elt eq $wg[1]){
					my $old = substr($line, $offset, $length);
					my $Nindex= index($arm, 'N') +1;
					my $wgnb= substr($arm, $Nindex, 4);
					$line =~ s/$old/$wgnb/g;
				}	
				if (defined $mim && $elt eq $wg[2]){
					my $old = substr($line, $offset, $length);
					my $Nindex= index($mim, 'N') +1;
					my $wgnb= substr($mim, $Nindex, 4);
					$line =~ s/$old/$wgnb/g;
				}	
				if ($elt eq $wg[3]){
					my $old = substr($line, $offset, $length);
					$line =~ s/$old/$pubyear/g;
				}
				if ($elt eq $wg[4]){
					my $old = substr($line, $offset, $length);
					$line =~ s/$old/$pubdate/g;
				}
				print "$line\n";	
			}	
		}
####### delete then re-write the content of document 		
		print $fh2 $line;
	}
### Close the files
	close $fh; 	
	close $fh2;
	unlink $filename;
	# File::Copy module for the naming of files
	move $newfile, $filename;
}
