use strict;

my $dirname = "../data/modules";

my $C_ARM = 0;
my $C_MIM = 1;


opendir my($dh), $dirname or die "Could not open directory '$dirname': $!";
my @modules = grep {!/CVS/} grep {/^[^.]/} readdir $dh;
closedir $dh;

my $nmodules;
my $count_entity;
my $count_extensible_select;
my $count_regular_select;
my %arm_data = process_modules($C_ARM);
my %mim_data = process_modules($C_MIM);
print "Number of modules: $nmodules\n";
print "ARM\n";
print_stat(%arm_data);
print "MIM\n";
print_stat(%mim_data);

sub print_stat {
    my (%data) = @_;

    my $n_entity = $data{'n_entity'};
    my $n_regular_select = $data{'n_regular_select'};
    my $n_extensible_select = $data{'n_extensible_select'};

    my $avg_entity = $n_entity / $nmodules;
    my $avg_regular_select = $n_regular_select / $nmodules;
    my $avg_extensible_select = $n_extensible_select / $nmodules;

    print sprintf("Entities          \t%5d\t%5.2f\n",$n_entity, $avg_entity);
    print sprintf("Regular SELECTS   \t%5d\t%5.2f\n",$n_regular_select, $avg_regular_select);
    print sprintf("Extensible SELECTS\t%5d\t%5.2f\n",$n_extensible_select, $avg_extensible_select);
}

sub process_modules {
    my ($schema_type) = @_;

    my $expfn;

    $nmodules = 0;
    $count_entity = 0;
    $count_extensible_select = 0;
    $count_regular_select = 0;

    if ($schema_type == $C_ARM) {
	$expfn = "arm.exp";
    }
    elsif ($schema_type == $C_MIM) {
	$expfn = "mim.exp";
    }
    else {
	die "Incorrect argument.";
    }

    # print "MODULE\tENTITIES\tREGULAR_SELECT\tEXTENSIBLE_SELECT\n";
    for my $module (@modules) {
	process_module($module, $expfn);
    }
    # print "TOTAL\t$count_entity\t$count_regular_select\t$count_extensible_select\n";
    # print "AVERAGE\t$avg_entity\t$avg_regular_select\t$avg_extensible_select\n";
    my %module_data = (
	n_entity => $count_entity,
	n_regular_select => $count_regular_select,
	n_extensible_select => $count_extensible_select
    );
    %module_data;
}

sub process_module {
    my ($module, $expfn) = @_;
    my $nentity = 0;
    my $nextensible_select = 0;
    my $nregular_select = 0;

    my $filepath = "$dirname/$module/$expfn";
    my $code = open(EXPFILE, $filepath);
    if ($code == 0) {
	warn("could not open file $filepath");
	return;
    }
    while (<EXPFILE>) {
	chomp;
	if (/^ENTITY /) {
	    $nentity++;
	}
	elsif (/EXTENSIBLE GENERIC_ENTITY SELECT/) {
	    $nextensible_select++;
	}
	elsif (/SELECT/) {
	    $nregular_select++;
	}
    }
    # print "$module\t$nentity\t$nregular_select\t$nextensible_select\n";
    $nmodules++;
    $count_entity += $nentity;
    $count_regular_select += $nregular_select;
    $count_extensible_select += $nextensible_select;
    close(EXPFILE);
}
